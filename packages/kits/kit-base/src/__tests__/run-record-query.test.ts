/**
 * Tests for run record query and management functionality.
 */

import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { mkdirSync, writeFileSync, rmSync, existsSync } from "node:fs";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { randomUUID } from "node:crypto";
import {
  createRunRecord,
  readRunRecord,
  safeReadRunRecord,
  listRunRecords,
  getRunRecordStats,
  findRunRecordByTraceId,
  findRunRecordByIdempotencyKey,
  findRunRecordsByInputsHash,
  cleanupRunRecords,
  getRunRecordDiskUsage,
  exportRunRecords,
  toOtlpLogRecord,
  type RunRecord,
  type RetentionPolicy,
} from "../run-record.js";

describe("run-record query functions", () => {
  let testDir: string;

  beforeEach(() => {
    // Create a unique test directory
    testDir = join(tmpdir(), `run-record-test-${randomUUID().slice(0, 8)}`);
    mkdirSync(testDir, { recursive: true });
  });

  afterEach(() => {
    // Clean up test directory
    if (existsSync(testDir)) {
      rmSync(testDir, { recursive: true, force: true });
    }
  });

  // Counter to ensure unique inputs for each record
  let recordCounter = 0;

  /**
   * Helper to create and write a test run record.
   */
  function createTestRecord(
    kit: string,
    status: "success" | "failure" = "success",
    overrides: Partial<Parameters<typeof createRunRecord>[0]> = {}
  ): RunRecord {
    // Use counter to ensure unique inputs (and thus unique run IDs)
    const uniqueId = ++recordCounter;
    const record = createRunRecord({
      kit: { name: kit, version: "0.1.0" },
      inputs: { test: true, uniqueId, ...overrides.inputs },
      status,
      summary: `Test ${kit} run`,
      stage: "implement",
      risk: "low",
      traceId: overrides.traceId || randomUUID(),
      determinism: overrides.determinism,
      durationMs: overrides.durationMs ?? 100,
      gitSha: randomUUID().slice(0, 8), // Add git SHA for more uniqueness
      ...overrides,
    });

    // Write to disk
    const kitDir = join(testDir, kit);
    mkdirSync(kitDir, { recursive: true });
    const filePath = join(kitDir, `${record.runId}.json`);
    writeFileSync(filePath, JSON.stringify(record, null, 2));

    return record;
  }

  describe("readRunRecord", () => {
    it("should read a run record by run ID", () => {
      const original = createTestRecord("guardkit");

      const read = readRunRecord(testDir, original.runId);

      expect(read).not.toBeNull();
      expect(read?.runId).toBe(original.runId);
      expect(read?.kit.name).toBe("guardkit");
    });

    it("should read a run record by full path", () => {
      const original = createTestRecord("flowkit");
      const filePath = join(testDir, "flowkit", `${original.runId}.json`);

      const read = readRunRecord(testDir, filePath);

      expect(read).not.toBeNull();
      expect(read?.runId).toBe(original.runId);
    });

    it("should return null for non-existent record", () => {
      const read = readRunRecord(testDir, "non-existent-run-id");

      expect(read).toBeNull();
    });
  });

  describe("safeReadRunRecord", () => {
    it("should return success with record", () => {
      const original = createTestRecord("promptkit");

      const result = safeReadRunRecord(testDir, original.runId);

      expect(result.success).toBe(true);
      expect(result.record?.runId).toBe(original.runId);
      expect(result.error).toBeUndefined();
    });

    it("should return failure for non-existent record", () => {
      const result = safeReadRunRecord(testDir, "non-existent");

      expect(result.success).toBe(false);
      expect(result.record).toBeUndefined();
      expect(result.error).toBeDefined();
    });
  });

  describe("listRunRecords", () => {
    it("should list all run records", () => {
      createTestRecord("guardkit");
      createTestRecord("flowkit");
      createTestRecord("promptkit");

      const summaries = listRunRecords(testDir);

      expect(summaries.length).toBe(3);
    });

    it("should filter by kit name", () => {
      createTestRecord("guardkit");
      createTestRecord("guardkit");
      createTestRecord("flowkit");

      const summaries = listRunRecords(testDir, { kit: "guardkit" });

      expect(summaries.length).toBe(2);
      expect(summaries.every((s) => s.kit === "guardkit")).toBe(true);
    });

    it("should filter by status", () => {
      createTestRecord("guardkit", "success");
      createTestRecord("guardkit", "failure");
      createTestRecord("flowkit", "success");

      const summaries = listRunRecords(testDir, { status: "success" });

      expect(summaries.length).toBe(2);
      expect(summaries.every((s) => s.status === "success")).toBe(true);
    });

    it("should sort by createdAt descending by default", () => {
      const r1 = createTestRecord("guardkit");
      // Add small delay to ensure different timestamps
      const r2 = createTestRecord("flowkit");

      const summaries = listRunRecords(testDir);

      // Most recent should be first
      expect(summaries[0].runId).toBe(r2.runId);
      expect(summaries[1].runId).toBe(r1.runId);
    });

    it("should support pagination", () => {
      createTestRecord("guardkit");
      createTestRecord("flowkit");
      createTestRecord("promptkit");

      const page1 = listRunRecords(testDir, { limit: 2, offset: 0 });
      const page2 = listRunRecords(testDir, { limit: 2, offset: 2 });

      expect(page1.length).toBe(2);
      expect(page2.length).toBe(1);
    });

    it("should return empty array for non-existent directory", () => {
      const summaries = listRunRecords("/non/existent/dir");

      expect(summaries).toEqual([]);
    });
  });

  describe("getRunRecordStats", () => {
    it("should compute statistics for all records", () => {
      createTestRecord("guardkit", "success", { durationMs: 100 });
      createTestRecord("guardkit", "failure", { durationMs: 200 });
      createTestRecord("flowkit", "success", { durationMs: 300 });

      const stats = getRunRecordStats(testDir);

      expect(stats.totalRuns).toBe(3);
      expect(stats.byKit.guardkit).toBe(2);
      expect(stats.byKit.flowkit).toBe(1);
      expect(stats.byStatus.success).toBe(2);
      expect(stats.byStatus.failure).toBe(1);
      expect(stats.avgDurationMs).toBe(200);
      expect(stats.totalDurationMs).toBe(600);
    });

    it("should filter by kit", () => {
      createTestRecord("guardkit");
      createTestRecord("flowkit");

      const stats = getRunRecordStats(testDir, { kit: "guardkit" });

      expect(stats.totalRuns).toBe(1);
      expect(stats.byKit.guardkit).toBe(1);
    });
  });

  describe("findRunRecordByTraceId", () => {
    it("should find record by trace ID", () => {
      const traceId = randomUUID();
      const original = createTestRecord("guardkit", "success", { traceId });

      const found = findRunRecordByTraceId(testDir, traceId);

      expect(found).not.toBeNull();
      expect(found?.runId).toBe(original.runId);
      expect(found?.telemetry.trace_id).toBe(traceId);
    });

    it("should return null for non-existent trace ID", () => {
      createTestRecord("guardkit");

      const found = findRunRecordByTraceId(testDir, "non-existent-trace");

      expect(found).toBeNull();
    });
  });

  describe("findRunRecordByIdempotencyKey", () => {
    it("should find record by idempotency key", () => {
      const idempotencyKey = "guardkit:check:abc123";
      const original = createTestRecord("guardkit", "success", {
        determinism: { idempotencyKey },
      });

      const found = findRunRecordByIdempotencyKey(testDir, idempotencyKey);

      expect(found).not.toBeNull();
      expect(found?.runId).toBe(original.runId);
      expect(found?.determinism?.idempotencyKey).toBe(idempotencyKey);
    });

    it("should return null for non-existent idempotency key", () => {
      createTestRecord("guardkit");

      const found = findRunRecordByIdempotencyKey(testDir, "non-existent");

      expect(found).toBeNull();
    });
  });

  describe("findRunRecordsByInputsHash", () => {
    it("should find records with matching inputs hash in idempotency key", () => {
      const inputsHash = "abc123def456";
      createTestRecord("guardkit", "success", {
        determinism: { idempotencyKey: `guardkit:check:${inputsHash}` },
      });
      createTestRecord("guardkit", "success", {
        determinism: { idempotencyKey: `guardkit:sanitize:${inputsHash}` },
      });
      createTestRecord("flowkit", "success");

      const found = findRunRecordsByInputsHash(testDir, inputsHash);

      expect(found.length).toBe(2);
    });
  });

  describe("cleanupRunRecords", () => {
    it("should delete old records based on maxAgeMs", () => {
      // Create a record with old timestamp
      const oldRecord = createTestRecord("guardkit");
      // Manually set old createdAt by rewriting the file
      const oldData = readRunRecord(testDir, oldRecord.runId)!;
      oldData.createdAt = new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString(); // 10 days ago
      const filePath = join(testDir, "guardkit", `${oldRecord.runId}.json`);
      writeFileSync(filePath, JSON.stringify(oldData, null, 2));

      // Create a recent record
      createTestRecord("flowkit");

      const policy: RetentionPolicy = {
        maxAgeMs: 7 * 24 * 60 * 60 * 1000, // 7 days
      };

      const result = cleanupRunRecords(testDir, policy, false);

      expect(result.deletedCount).toBe(1);
      expect(result.retainedCount).toBe(1);
      expect(result.deletedByKit.guardkit).toBe(1);
    });

    it("should support dry-run mode", () => {
      const oldRecord = createTestRecord("guardkit");
      const oldData = readRunRecord(testDir, oldRecord.runId)!;
      oldData.createdAt = new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString();
      const filePath = join(testDir, "guardkit", `${oldRecord.runId}.json`);
      writeFileSync(filePath, JSON.stringify(oldData, null, 2));

      const policy: RetentionPolicy = { maxAgeMs: 7 * 24 * 60 * 60 * 1000 };

      const result = cleanupRunRecords(testDir, policy, true);

      expect(result.dryRun).toBe(true);
      expect(result.deletedCount).toBe(1);
      // File should still exist in dry-run mode
      expect(existsSync(filePath)).toBe(true);
    });

    it("should keep failures longer with failureMultiplier", () => {
      // Create old failure
      const oldFailure = createTestRecord("guardkit", "failure");
      const failureData = readRunRecord(testDir, oldFailure.runId)!;
      failureData.createdAt = new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString();
      const failurePath = join(testDir, "guardkit", `${oldFailure.runId}.json`);
      writeFileSync(failurePath, JSON.stringify(failureData, null, 2));

      // Create old success
      const oldSuccess = createTestRecord("flowkit", "success");
      const successData = readRunRecord(testDir, oldSuccess.runId)!;
      successData.createdAt = new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString();
      const successPath = join(testDir, "flowkit", `${oldSuccess.runId}.json`);
      writeFileSync(successPath, JSON.stringify(successData, null, 2));

      const policy: RetentionPolicy = {
        maxAgeMs: 7 * 24 * 60 * 60 * 1000, // 7 days
        keepFailures: true,
        failureMultiplier: 2, // Keep failures for 14 days
      };

      const result = cleanupRunRecords(testDir, policy, false);

      // Success should be deleted (> 7 days), failure retained (< 14 days)
      expect(result.deletedCount).toBe(1);
      expect(result.retainedCount).toBe(1);
      expect(existsSync(failurePath)).toBe(true);
      expect(existsSync(successPath)).toBe(false);
    });
  });

  describe("getRunRecordDiskUsage", () => {
    it("should compute disk usage per kit", () => {
      createTestRecord("guardkit");
      createTestRecord("guardkit");
      createTestRecord("flowkit");

      const usage = getRunRecordDiskUsage(testDir);

      expect(usage.totalFiles).toBe(3);
      expect(usage.fileCountByKit.guardkit).toBe(2);
      expect(usage.fileCountByKit.flowkit).toBe(1);
      expect(usage.totalBytes).toBeGreaterThan(0);
      expect(usage.byKit.guardkit).toBeGreaterThan(0);
      expect(usage.byKit.flowkit).toBeGreaterThan(0);
    });
  });

  describe("toOtlpLogRecord", () => {
    it("should convert run record to OTLP format", () => {
      const record = createTestRecord("guardkit", "success", {
        traceId: "trace-123",
        determinism: { idempotencyKey: "key-123", prompt_hash: "hash-123" },
        durationMs: 500,
      });

      const otlp = toOtlpLogRecord(record);

      expect(otlp.severityNumber).toBe(9); // INFO for success
      expect(otlp.severityText).toBe("INFO");
      expect(otlp.traceId).toBe("trace-123");
      expect(otlp.body).toEqual({ stringValue: record.summary });
      expect(otlp.attributes).toContainEqual({
        key: "kit.name",
        value: { stringValue: "guardkit" },
      });
      expect(otlp.attributes).toContainEqual({
        key: "idempotency_key",
        value: { stringValue: "key-123" },
      });
    });

    it("should use ERROR severity for failures", () => {
      const record = createTestRecord("guardkit", "failure");

      const otlp = toOtlpLogRecord(record);

      expect(otlp.severityNumber).toBe(17); // ERROR
      expect(otlp.severityText).toBe("ERROR");
    });
  });

  describe("exportRunRecords", () => {
    it("should export to JSON format", async () => {
      createTestRecord("guardkit");
      createTestRecord("flowkit");

      const result = await exportRunRecords(testDir, {
        format: "json",
        destination: "file",
        outputPath: join(testDir, "export.json"),
      });

      expect(result.exportedCount).toBe(2);
      expect(result.format).toBe("json");
      expect(existsSync(join(testDir, "export.json"))).toBe(true);
    });

    it("should export to NDJSON format", async () => {
      createTestRecord("guardkit");

      const result = await exportRunRecords(testDir, {
        format: "ndjson",
        destination: "file",
        outputPath: join(testDir, "export.ndjson"),
      });

      expect(result.exportedCount).toBe(1);
      expect(result.format).toBe("ndjson");
    });

    it("should export to OTLP format", async () => {
      createTestRecord("guardkit");

      const result = await exportRunRecords(testDir, {
        format: "otlp",
        destination: "file",
        outputPath: join(testDir, "export.otlp.json"),
      });

      expect(result.exportedCount).toBe(1);
      expect(result.format).toBe("otlp");
    });

    it("should filter exports", async () => {
      createTestRecord("guardkit", "success");
      createTestRecord("flowkit", "failure");

      const result = await exportRunRecords(testDir, {
        format: "json",
        destination: "file",
        outputPath: join(testDir, "export-filtered.json"),
        filter: { status: "success" },
      });

      expect(result.exportedCount).toBe(1);
    });
  });
});

