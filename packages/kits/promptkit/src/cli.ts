#!/usr/bin/env node
/**
 * PromptKit CLI
 *
 * Command-line interface for PromptKit operations with Harmony-standard flags.
 *
 * Pillar alignment: Quality through Determinism, Guided Agentic Autonomy
 *
 * @example
 * ```bash
 * # Compile a prompt
 * promptkit compile spec-from-intent --variables '{"intent":"...", "tier":"T2"}'
 *
 * # Compile in dry-run mode (default in local)
 * promptkit compile spec-from-intent --dry-run --variables '...'
 *
 * # Compile with risk tier
 * promptkit compile spec-from-intent --risk T2 --stage implement --variables '...'
 *
 * # List variants
 * promptkit variants spec-from-intent
 *
 * # Validate a prompt compiles correctly
 * promptkit validate spec-from-intent --variables '{"intent":"..."}'
 *
 * # List all prompts
 * promptkit list
 * ```
 */

import {
  parseStandardFlags,
  getStandardFlagsHelp,
  listRunRecords,
  readRunRecord,
  getRunRecordStats,
  findRunRecordByTraceId,
  findRunRecordByIdempotencyKey,
  getRunsDirectory,
  parseRunsCliArgs,
  toListOptions,
  formatRunRecordTable,
  formatRunRecordDetail,
  formatStats,
  getRunsCliHelp,
  type StandardKitFlags,
} from "@harmony/kit-base";

import { PromptKit } from "./index.js";
import { shortHash } from "./hasher.js";

const KIT_NAME = "promptkit";
const KIT_VERSION = "0.1.0";

interface CliOptions extends StandardKitFlags {
  variables?: string;
  variant?: string;
  maxTokens?: number;
  model?: string;
  tier?: string;
}

/**
 * Parse command line arguments with standard flag support.
 */
function parseArgs(args: string[]): {
  command: string;
  promptId?: string;
  options: CliOptions;
} {
  // First parse standard flags using kit-base
  const { flags: standardFlags, remaining } = parseStandardFlags(args);

  // Parse prompt-kit specific options from remaining args
  const options: CliOptions = { ...standardFlags };
  let command = "";
  let promptId: string | undefined;
  const finalRemaining: string[] = [];

  for (let i = 0; i < remaining.length; i++) {
    const arg = remaining[i];

    if (arg.startsWith("--")) {
      const [rawKey, ...valueParts] = arg.slice(2).split("=");
      const key = rawKey;
      const hasValue = valueParts.length > 0;
      const value = hasValue ? valueParts.join("=") : undefined;

      // For value-based flags, consume value from = or next argument
      let flagValue = value;
      if (!hasValue && i + 1 < remaining.length && !remaining[i + 1].startsWith("-")) {
        flagValue = remaining[++i];
      }

      switch (key) {
        case "variables":
        case "vars":
          options.variables = flagValue;
          break;
        case "variant":
          options.variant = flagValue;
          break;
        case "max-tokens":
          options.maxTokens = flagValue ? parseInt(flagValue, 10) : undefined;
          break;
        case "model":
          options.model = flagValue;
          break;
        case "tier":
          options.tier = flagValue;
          break;
        default:
          // Unknown flag, pass through
          finalRemaining.push(arg);
      }
    } else if (arg.startsWith("-")) {
      const key = arg.slice(1);
      switch (key) {
        case "j":
          options.format = "json";
          break;
        default:
          finalRemaining.push(arg);
      }
    } else if (!command) {
      command = arg;
    } else if (!promptId) {
      promptId = arg;
    } else {
      finalRemaining.push(arg);
    }
  }

  return { command, promptId, options };
}

/**
 * Parse variables from JSON string or file.
 */
function parseVariables(varsString?: string): Record<string, unknown> {
  if (!varsString) {
    return {};
  }

  try {
    return JSON.parse(varsString);
  } catch {
    console.error(`Error: Invalid JSON in --variables: ${varsString}`);
    process.exit(1);
  }
}

/**
 * Main CLI handler.
 */
async function main(): Promise<void> {
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === "--help" || args[0] === "-h") {
    printUsage();
    return;
  }

  const { command, promptId, options } = parseArgs(args);
  const promptKit = new PromptKit();

  switch (command) {
    case "compile":
      await cmdCompile(promptKit, promptId, options);
      break;

    case "validate":
      await cmdValidate(promptKit, promptId, options);
      break;

    case "tokens":
      await cmdTokens(promptKit, promptId, options);
      break;

    case "variants":
      await cmdVariants(promptKit, promptId, options);
      break;

    case "list":
      await cmdList(promptKit, options);
      break;

    case "info":
      await cmdInfo(promptKit, promptId, options);
      break;

    case "variables":
      await cmdVariables(promptKit, promptId, options);
      break;

    case "runs":
      await cmdRuns(promptId, options);
      break;

    default:
      console.error(`Unknown command: ${command}`);
      printUsage();
      process.exit(1);
  }
}

/**
 * Print usage information.
 */
function printUsage(): void {
  console.log(`
PromptKit CLI v0.1.0 - Runtime prompt compiler for Harmony

USAGE:
  promptkit <command> [prompt-id] [options]

COMMANDS:
  compile <prompt-id>   Compile a prompt with variables
  validate <prompt-id>  Validate a prompt compiles correctly
  tokens <prompt-id>    Estimate tokens for a prompt
  variants <prompt-id>  List available variants for a prompt
  variables <prompt-id> List expected variables for a prompt
  list                  List all available prompts
  info <prompt-id>      Show detailed prompt information
  runs [subcommand]     Query and manage run records

RUNS SUBCOMMANDS:
  list                  List run records
  show <runId>          Show details of a run record
  stats                 Show aggregate statistics
  find --trace <id>     Find by trace ID
  help                  Show runs help

PROMPT OPTIONS:
  --variables, --vars   JSON string of variables
  --variant             Specific variant to use
  --max-tokens          Maximum tokens (truncates if exceeded)
  --model               Override model selection
  --tier                Risk tier (T1, T2, T3)
  -j                    JSON output (shorthand for --format json)

${getStandardFlagsHelp()}

EXAMPLES:
  # Compile a prompt
  promptkit compile spec-from-intent --vars '{"intent":"Add auth","tier":"T2"}'

  # Compile with dry-run (validates without side effects)
  promptkit compile spec-from-intent --dry-run --vars '{"intent":"Add auth"}'

  # Compile with risk tier and stage for telemetry
  promptkit compile spec-from-intent --risk T2 --stage implement --vars '...'

  # Validate with variables
  promptkit validate spec-from-intent --vars '{"intent":"Add auth"}'

  # Get token estimate
  promptkit tokens spec-from-intent --vars '{"intent":"Add auth"}'

  # List variants
  promptkit variants spec-from-intent

  # List all prompts as JSON
  promptkit list -j
`);
}

/**
 * Compile command.
 */
async function cmdCompile(
  promptKit: PromptKit,
  promptId: string | undefined,
  options: CliOptions
): Promise<void> {
  if (!promptId) {
    console.error("Error: prompt-id is required");
    process.exit(1);
  }

  const variables = parseVariables(options.variables);

  try {
    const compiled = promptKit.compile(promptId, variables, {
      variantId: options.variant,
      maxTokens: options.maxTokens,
      model: options.model,
    });

    // Add standard kit metadata to output
    const output = {
      ...compiled,
      _kit: {
        name: "promptkit",
        version: "0.1.0",
        dryRun: options.dryRun,
        stage: options.stage,
        risk: options.risk,
        traceEnabled: options.trace,
        traceParent: options.traceParent,
      },
    };

    if (options.format === "json") {
      console.log(JSON.stringify(output, null, 2));
    } else {
      console.log(promptKit.formatCompiled(compiled));
      if (options.verbose) {
        console.log(`\n[Kit] dry-run=${options.dryRun}, stage=${options.stage || "none"}, risk=${options.risk || "none"}`);
      }
    }
  } catch (error) {
    console.error(
      `Error: ${error instanceof Error ? error.message : String(error)}`
    );
    process.exit(1);
  }
}

/**
 * Validate command.
 */
async function cmdValidate(
  promptKit: PromptKit,
  promptId: string | undefined,
  options: CliOptions
): Promise<void> {
  if (!promptId) {
    console.error("Error: prompt-id is required");
    process.exit(1);
  }

  const variables = parseVariables(options.variables);

  try {
    const result = promptKit.validate(promptId, variables);

    if (options.format === "json") {
      console.log(JSON.stringify(result, null, 2));
    } else {
      if (result.valid) {
        console.log("✅ Prompt is valid");
      } else {
        console.log("❌ Prompt validation failed:");
        for (const error of result.errors) {
          console.log(`  • ${error}`);
        }
      }

      if (result.warnings.length > 0) {
        console.log("\n⚠️  Warnings:");
        for (const warning of result.warnings) {
          console.log(`  • ${warning}`);
        }
      }
    }

    if (!result.valid) {
      process.exit(1);
    }
  } catch (error) {
    console.error(
      `Error: ${error instanceof Error ? error.message : String(error)}`
    );
    process.exit(1);
  }
}

/**
 * Tokens command.
 */
async function cmdTokens(
  promptKit: PromptKit,
  promptId: string | undefined,
  options: CliOptions
): Promise<void> {
  if (!promptId) {
    console.error("Error: prompt-id is required");
    process.exit(1);
  }

  const variables = parseVariables(options.variables);

  try {
    const compiled = promptKit.compile(promptId, variables, {
      variantId: options.variant,
      model: options.model,
    });

    const tokenInfo = promptKit.getTokenInfo(compiled);

    if (options.format === "json") {
      console.log(
        JSON.stringify(
          {
            promptId,
            model: compiled.metadata.model,
            hash: shortHash(compiled.prompt_hash),
            ...tokenInfo,
          },
          null,
          2
        )
      );
    } else {
      console.log("📊 Token Estimate");
      console.log("─────────────────────────────");
      console.log(`Prompt ID: ${promptId}`);
      console.log(`Model: ${compiled.metadata.model}`);
      console.log(`Hash: ${shortHash(compiled.prompt_hash)}`);
      console.log("");
      console.log(`Tokens: ~${tokenInfo.tokens.toLocaleString()}`);
      console.log(`Context Window: ${tokenInfo.contextWindow.toLocaleString()}`);
      console.log(`Usage: ${tokenInfo.usagePercent.toFixed(1)}%`);
      console.log(
        `Available for Output: ~${tokenInfo.availableForOutput.toLocaleString()}`
      );
      console.log("");
      console.log(
        tokenInfo.fitsInContext
          ? "✅ Fits in context"
          : "❌ Exceeds context window"
      );
    }
  } catch (error) {
    console.error(
      `Error: ${error instanceof Error ? error.message : String(error)}`
    );
    process.exit(1);
  }
}

/**
 * Variants command.
 */
async function cmdVariants(
  promptKit: PromptKit,
  promptId: string | undefined,
  options: CliOptions
): Promise<void> {
  if (!promptId) {
    console.error("Error: prompt-id is required");
    process.exit(1);
  }

  try {
    const info = promptKit.getPromptInfo(promptId);

    if (options.format === "json") {
      console.log(
        JSON.stringify(
          {
            promptId,
            variants: info.variants,
          },
          null,
          2
        )
      );
    } else {
      console.log(`Variants for ${promptId}:`);
      console.log("─────────────────────────────");
      for (const variantId of info.variants) {
        console.log(`  • ${variantId}`);
      }
    }
  } catch (error) {
    console.error(
      `Error: ${error instanceof Error ? error.message : String(error)}`
    );
    process.exit(1);
  }
}

/**
 * List command.
 */
async function cmdList(
  promptKit: PromptKit,
  options: CliOptions
): Promise<void> {
  try {
    const prompts = promptKit.listPrompts();

    if (options.format === "json") {
      if (options.verbose) {
        const detailed = prompts.map((id) => promptKit.getPromptInfo(id));
        console.log(JSON.stringify(detailed, null, 2));
      } else {
        console.log(JSON.stringify(prompts, null, 2));
      }
    } else {
      console.log("Available Prompts:");
      console.log("─────────────────────────────");
      for (const id of prompts) {
        if (options.verbose) {
          const info = promptKit.getPromptInfo(id);
          console.log(`  ${id}`);
          console.log(`    ${info.description}`);
          console.log(`    Status: ${info.status} | Tiers: ${info.tierSupport.join(", ")}`);
          console.log("");
        } else {
          console.log(`  • ${id}`);
        }
      }
    }
  } catch (error) {
    console.error(
      `Error: ${error instanceof Error ? error.message : String(error)}`
    );
    process.exit(1);
  }
}

/**
 * Info command.
 */
async function cmdInfo(
  promptKit: PromptKit,
  promptId: string | undefined,
  options: CliOptions
): Promise<void> {
  if (!promptId) {
    console.error("Error: prompt-id is required");
    process.exit(1);
  }

  try {
    const info = promptKit.getPromptInfo(promptId);
    const variables = promptKit.getExpectedVariables(promptId);

    if (options.format === "json") {
      console.log(
        JSON.stringify(
          {
            ...info,
            expectedVariables: variables,
          },
          null,
          2
        )
      );
    } else {
      console.log("Prompt Information");
      console.log("═══════════════════════════════════════");
      console.log(`ID: ${info.id}`);
      console.log(`Name: ${info.name}`);
      console.log(`Description: ${info.description}`);
      console.log(`Version: ${info.version}`);
      console.log(`Status: ${info.status}`);
      console.log(`Category: ${info.category}`);
      console.log(`Tier Support: ${info.tierSupport.join(", ")}`);
      console.log(`Variants: ${info.variants.join(", ")}`);
      console.log("");
      console.log("Expected Variables:");
      for (const v of variables) {
        console.log(`  • ${v}`);
      }
    }
  } catch (error) {
    console.error(
      `Error: ${error instanceof Error ? error.message : String(error)}`
    );
    process.exit(1);
  }
}

/**
 * Variables command.
 */
async function cmdVariables(
  promptKit: PromptKit,
  promptId: string | undefined,
  options: CliOptions
): Promise<void> {
  if (!promptId) {
    console.error("Error: prompt-id is required");
    process.exit(1);
  }

  try {
    const variables = promptKit.getExpectedVariables(promptId);

    if (options.format === "json") {
      console.log(JSON.stringify({ promptId, variables }, null, 2));
    } else {
      console.log(`Expected variables for ${promptId}:`);
      console.log("─────────────────────────────");
      for (const v of variables) {
        console.log(`  • ${v}`);
      }
    }
  } catch (error) {
    console.error(
      `Error: ${error instanceof Error ? error.message : String(error)}`
    );
    process.exit(1);
  }
}

/**
 * Runs command - query and manage run records.
 */
async function cmdRuns(
  subcommandArg: string | undefined,
  options: CliOptions
): Promise<void> {
  const subcommand = subcommandArg || "list";
  const runsDir = options.runsDir || getRunsDirectory(process.cwd());
  const format = options.format || "table";

  // Parse runs-specific args from process.argv
  const argsStart = process.argv.findIndex(arg => arg === "runs");
  const runsArgv = argsStart >= 0 ? process.argv.slice(argsStart + 1) : [];
  const subArg = runsArgv.find(arg => !arg.startsWith("-") && arg !== subcommand);

  const runsArgs = parseRunsCliArgs([subcommand, ...(subArg ? [subArg] : []), "--kit", KIT_NAME]);

  try {
    switch (subcommand) {
      case "list": {
        const listOptions = toListOptions({ ...runsArgs, kit: KIT_NAME });
        const summaries = listRunRecords(runsDir, listOptions);
        
        if (format === "json") {
          console.log(JSON.stringify({ summaries, _kit: { name: KIT_NAME, version: KIT_VERSION } }, null, 2));
        } else {
          console.log(formatRunRecordTable(summaries));
        }
        break;
      }

      case "show": {
        if (!subArg) {
          console.error("Error: Run ID required. Usage: promptkit runs show <runId>");
          process.exit(1);
        }
        const record = readRunRecord(runsDir, subArg);
        if (!record) {
          console.error(`Run record not found: ${subArg}`);
          process.exit(1);
        }
        if (format === "json") {
          console.log(JSON.stringify({ record, _kit: { name: KIT_NAME, version: KIT_VERSION } }, null, 2));
        } else {
          console.log(formatRunRecordDetail(record));
        }
        break;
      }

      case "stats": {
        const stats = getRunRecordStats(runsDir, { kit: KIT_NAME, since: runsArgs.since });
        if (format === "json") {
          console.log(JSON.stringify({ stats, _kit: { name: KIT_NAME, version: KIT_VERSION } }, null, 2));
        } else {
          console.log(formatStats(stats));
        }
        break;
      }

      case "find": {
        let record = null;
        if (runsArgs.traceId) {
          record = findRunRecordByTraceId(runsDir, runsArgs.traceId);
        } else if (runsArgs.idempotencyKey) {
          record = findRunRecordByIdempotencyKey(runsDir, runsArgs.idempotencyKey);
        } else {
          console.error("Error: Use --trace or --idempotency-key to find records");
          process.exit(1);
        }
        
        if (!record) {
          console.error("Run record not found");
          process.exit(1);
        }
        if (format === "json") {
          console.log(JSON.stringify({ record, _kit: { name: KIT_NAME, version: KIT_VERSION } }, null, 2));
        } else {
          console.log(formatRunRecordDetail(record));
        }
        break;
      }

      case "help":
        console.log(getRunsCliHelp(KIT_NAME));
        break;

      default:
        console.error(`Unknown runs subcommand: ${subcommand}. Use: list|show|stats|find|help`);
        process.exit(1);
    }
  } catch (error) {
    console.error(`Error: ${error instanceof Error ? error.message : String(error)}`);
    process.exit(1);
  }
}

// Run CLI
main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
