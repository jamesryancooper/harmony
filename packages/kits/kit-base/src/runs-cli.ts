#!/usr/bin/env node
/**
 * kit-runs CLI - Query and manage run records across all kits.
 *
 * Usage:
 *   kit-runs list [--kit <name>] [--status <status>] [--limit N]
 *   kit-runs show <runId>
 *   kit-runs stats [--kit <name>] [--since <date>]
 *   kit-runs find --trace <traceId>
 *   kit-runs cleanup --max-age <duration> [--dry-run]
 *   kit-runs export --export-format <fmt> [--output <path>]
 */

import { join } from "node:path";
import {
  readRunRecord,
  listRunRecords,
  getRunRecordStats,
  findRunRecordByTraceId,
  findRunRecordByIdempotencyKey,
  cleanupRunRecords,
  exportRunRecords,
  getRunsDirectory,
  getRunRecordDiskUsage,
  type RetentionPolicy,
} from "./run-record.js";
import {
  parseRunsCliArgs,
  toListOptions,
  parseDuration,
  formatRunRecordTable,
  formatRunRecordText,
  formatRunRecordDetail,
  formatStats,
  formatCleanupResult,
  formatExportResult,
  getRunsCliHelp,
} from "./runs-cli-shared.js";

/**
 * Main CLI entry point.
 */
async function main(): Promise<number> {
  const args = parseRunsCliArgs(process.argv.slice(2));

  if (args.help || args.command === "help") {
    console.log(getRunsCliHelp());
    return 0;
  }

  const runsDir = args.runsDir || getRunsDirectory(process.cwd());
  const format = args.format || "table";

  try {
    switch (args.command) {
      case "list":
        return handleList(runsDir, args, format);

      case "show":
        return handleShow(runsDir, args, format);

      case "stats":
        return handleStats(runsDir, args, format);

      case "find":
        return handleFind(runsDir, args, format);

      case "cleanup":
        return await handleCleanup(runsDir, args);

      case "export":
        return await handleExport(runsDir, args);

      case "usage":
        return handleUsage(runsDir, format);

      default:
        console.error(`Unknown command: ${args.command}`);
        console.log(getRunsCliHelp());
        return 1;
    }
  } catch (error) {
    console.error(
      "Error:",
      error instanceof Error ? error.message : String(error)
    );
    return 1;
  }
}

/**
 * Handle 'list' command.
 */
function handleList(
  runsDir: string,
  args: ReturnType<typeof parseRunsCliArgs>,
  format: string
): number {
  const options = toListOptions(args);
  const summaries = listRunRecords(runsDir, options);

  if (format === "json") {
    console.log(JSON.stringify(summaries, null, 2));
  } else if (format === "text") {
    console.log(formatRunRecordText(summaries));
  } else {
    console.log(formatRunRecordTable(summaries));
  }

  return 0;
}

/**
 * Handle 'show' command.
 */
function handleShow(
  runsDir: string,
  args: ReturnType<typeof parseRunsCliArgs>,
  format: string
): number {
  if (!args.runId) {
    console.error("Error: Run ID required");
    console.log("Usage: kit-runs show <runId>");
    return 1;
  }

  const record = readRunRecord(runsDir, args.runId);

  if (!record) {
    console.error(`Run record not found: ${args.runId}`);
    return 1;
  }

  if (format === "json") {
    console.log(JSON.stringify(record, null, 2));
  } else {
    console.log(formatRunRecordDetail(record));
  }

  return 0;
}

/**
 * Handle 'stats' command.
 */
function handleStats(
  runsDir: string,
  args: ReturnType<typeof parseRunsCliArgs>,
  format: string
): number {
  const options = {
    kit: args.kit,
    since: args.since,
    until: args.until,
  };

  const stats = getRunRecordStats(runsDir, options);

  if (format === "json") {
    console.log(JSON.stringify(stats, null, 2));
  } else {
    console.log(formatStats(stats));
  }

  return 0;
}

/**
 * Handle 'find' command.
 */
function handleFind(
  runsDir: string,
  args: ReturnType<typeof parseRunsCliArgs>,
  format: string
): number {
  let record = null;

  if (args.traceId) {
    record = findRunRecordByTraceId(runsDir, args.traceId);
  } else if (args.idempotencyKey) {
    record = findRunRecordByIdempotencyKey(runsDir, args.idempotencyKey);
  } else {
    console.error("Error: --trace or --idempotency-key required");
    console.log("Usage: kit-runs find --trace <traceId>");
    console.log("       kit-runs find --idempotency-key <key>");
    return 1;
  }

  if (!record) {
    console.error("Run record not found");
    return 1;
  }

  if (format === "json") {
    console.log(JSON.stringify(record, null, 2));
  } else {
    console.log(formatRunRecordDetail(record));
  }

  return 0;
}

/**
 * Handle 'cleanup' command.
 */
async function handleCleanup(
  runsDir: string,
  args: ReturnType<typeof parseRunsCliArgs>
): Promise<number> {
  if (!args.maxAge) {
    console.error("Error: --max-age required");
    console.log("Usage: kit-runs cleanup --max-age <duration> [--dry-run]");
    console.log("Example: kit-runs cleanup --max-age 30d --dry-run");
    return 1;
  }

  const maxAgeMs = parseDuration(args.maxAge);
  if (!maxAgeMs) {
    console.error(`Invalid duration: ${args.maxAge}`);
    console.log("Supported formats: 30d, 7d, 24h, 60m, 30s");
    return 1;
  }

  const policy: RetentionPolicy = {
    maxAgeMs,
    keepFailures: true,
    failureMultiplier: 2,
    keepHighRisk: true,
    highRiskMultiplier: 3,
  };

  const result = cleanupRunRecords(runsDir, policy, args.dryRun ?? false);

  console.log(formatCleanupResult(result));

  return result.errors.length > 0 ? 1 : 0;
}

/**
 * Handle 'export' command.
 */
async function handleExport(
  runsDir: string,
  args: ReturnType<typeof parseRunsCliArgs>
): Promise<number> {
  const format = args.exportFormat || "json";
  const destination = args.outputPath
    ? "file"
    : args.collectorUrl
      ? "otel-collector"
      : "stdout";

  const result = await exportRunRecords(runsDir, {
    format,
    destination,
    outputPath: args.outputPath,
    collectorUrl: args.collectorUrl,
    filter: toListOptions(args),
  });

  // Only print result summary if not writing to stdout
  if (destination !== "stdout") {
    console.log(formatExportResult(result));
  }

  return result.errors.length > 0 ? 1 : 0;
}

/**
 * Handle 'usage' command - show disk usage.
 */
function handleUsage(runsDir: string, format: string): number {
  const usage = getRunRecordDiskUsage(runsDir);

  if (format === "json") {
    console.log(JSON.stringify(usage, null, 2));
  } else {
    const lines: string[] = [
      "=== RUN RECORDS DISK USAGE ===",
      "",
      `Total Files: ${usage.totalFiles}`,
      `Total Size:  ${formatBytes(usage.totalBytes)}`,
      "",
      "By Kit:",
    ];

    for (const [kit, bytes] of Object.entries(usage.byKit)) {
      const files = usage.fileCountByKit[kit] || 0;
      lines.push(`  ${kit}: ${formatBytes(bytes)} (${files} files)`);
    }

    console.log(lines.join("\n"));
  }

  return 0;
}

/**
 * Format bytes for display.
 */
function formatBytes(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  if (bytes < 1024 * 1024 * 1024)
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  return `${(bytes / (1024 * 1024 * 1024)).toFixed(1)} GB`;
}

// Run CLI
main().then((code) => {
  process.exitCode = code;
});

