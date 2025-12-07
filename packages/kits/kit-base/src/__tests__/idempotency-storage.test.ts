/**
 * Tests for idempotency storage backends.
 */

import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { mkdirSync, writeFileSync, rmSync, existsSync } from "node:fs";
import { join } from "node:path";
import { tmpdir } from "node:os";
import { randomUUID } from "node:crypto";
import {
  InMemoryIdempotencyStorage,
  RunRecordIdempotencyStorage,
  IdempotencyManager,
  createDurableIdempotencyManager,
  createInMemoryIdempotencyManager,
  type IdempotencyRecord,
} from "../idempotency.js";
import { createRunRecord, type RunRecord } from "../run-record.js";

describe("InMemoryIdempotencyStorage", () => {
  let storage: InMemoryIdempotencyStorage;

  beforeEach(() => {
    storage = new InMemoryIdempotencyStorage();
  });

  it("should store and retrieve records", () => {
    const record: IdempotencyRecord = {
      key: "test:op:abc123",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "abc123",
    };

    storage.set("test:op:abc123", record);
    const retrieved = storage.get<unknown>("test:op:abc123");

    expect(retrieved).not.toBeNull();
    expect(retrieved?.key).toBe(record.key);
    expect(retrieved?.state).toBe("pending");
  });

  it("should delete records", () => {
    const record: IdempotencyRecord = {
      key: "test:op:abc123",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "abc123",
    };

    storage.set("test:op:abc123", record);
    storage.delete("test:op:abc123");
    const retrieved = storage.get("test:op:abc123");

    expect(retrieved).toBeNull();
  });

  it("should check existence", () => {
    const record: IdempotencyRecord = {
      key: "test:op:abc123",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "abc123",
    };

    expect(storage.has("test:op:abc123")).toBe(false);
    storage.set("test:op:abc123", record);
    expect(storage.has("test:op:abc123")).toBe(true);
  });

  it("should clear all records", () => {
    const record: IdempotencyRecord = {
      key: "test:op:abc123",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "abc123",
    };

    storage.set("test:op:abc123", record);
    storage.set("test:op:def456", { ...record, key: "test:op:def456" });
    storage.clear();

    expect(storage.has("test:op:abc123")).toBe(false);
    expect(storage.has("test:op:def456")).toBe(false);
  });

  it("should cleanup expired pending records", () => {
    const oldRecord: IdempotencyRecord = {
      key: "test:op:old",
      createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(), // 2 hours ago
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "old",
    };

    const newRecord: IdempotencyRecord = {
      key: "test:op:new",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "new",
    };

    storage.set("test:op:old", oldRecord);
    storage.set("test:op:new", newRecord);

    // Cleanup with 1 hour TTL for pending
    storage.cleanupExpired(60 * 60 * 1000, 24 * 60 * 60 * 1000);

    expect(storage.has("test:op:old")).toBe(false);
    expect(storage.has("test:op:new")).toBe(true);
  });

  it("should cleanup expired completed records", () => {
    const oldCompleted: IdempotencyRecord = {
      key: "test:op:old",
      createdAt: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(), // 48 hours ago
      completedAt: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(),
      state: "completed",
      kitName: "test",
      operation: "op",
      inputsHash: "old",
    };

    const newCompleted: IdempotencyRecord = {
      key: "test:op:new",
      createdAt: new Date().toISOString(),
      completedAt: new Date().toISOString(),
      state: "completed",
      kitName: "test",
      operation: "op",
      inputsHash: "new",
    };

    storage.set("test:op:old", oldCompleted);
    storage.set("test:op:new", newCompleted);

    // Cleanup with 24 hour TTL for completed
    storage.cleanupExpired(60 * 60 * 1000, 24 * 60 * 60 * 1000);

    expect(storage.has("test:op:old")).toBe(false);
    expect(storage.has("test:op:new")).toBe(true);
  });
});

describe("RunRecordIdempotencyStorage", () => {
  let testDir: string;
  let storage: RunRecordIdempotencyStorage;

  beforeEach(() => {
    testDir = join(tmpdir(), `idem-storage-test-${randomUUID().slice(0, 8)}`);
    mkdirSync(testDir, { recursive: true });
    storage = new RunRecordIdempotencyStorage(testDir);
  });

  afterEach(() => {
    if (existsSync(testDir)) {
      rmSync(testDir, { recursive: true, force: true });
    }
  });

  /**
   * Helper to create and write a test run record with idempotency info.
   */
  function createTestRunRecord(
    kit: string,
    idempotencyKey: string,
    status: "success" | "failure" = "success"
  ): RunRecord {
    const record = createRunRecord({
      kit: { name: kit, version: "0.1.0" },
      inputs: { test: true },
      status,
      summary: `Test ${kit} run`,
      stage: "implement",
      risk: "low",
      traceId: randomUUID(),
      determinism: { idempotencyKey },
    });

    const kitDir = join(testDir, kit);
    mkdirSync(kitDir, { recursive: true });
    const filePath = join(kitDir, `${record.runId}.json`);
    writeFileSync(filePath, JSON.stringify(record, null, 2));

    return record;
  }

  it("should find completed operations from run records", () => {
    const key = "guardkit:check:abc123";
    createTestRunRecord("guardkit", key, "success");

    const retrieved = storage.get(key);

    expect(retrieved).not.toBeNull();
    expect(retrieved?.key).toBe(key);
    expect(retrieved?.state).toBe("completed");
    expect(retrieved?.kitName).toBe("guardkit");
  });

  it("should return failed state for failed run records", () => {
    const key = "guardkit:check:def456";
    createTestRunRecord("guardkit", key, "failure");

    const retrieved = storage.get(key);

    expect(retrieved).not.toBeNull();
    expect(retrieved?.state).toBe("failed");
  });

  it("should cache pending operations in memory", () => {
    const record: IdempotencyRecord = {
      key: "test:op:pending",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "pending",
    };

    storage.set("test:op:pending", record);
    const retrieved = storage.get("test:op:pending");

    expect(retrieved).not.toBeNull();
    expect(retrieved?.state).toBe("pending");
  });

  it("should remove from pending cache when completed", () => {
    const pendingRecord: IdempotencyRecord = {
      key: "test:op:pending",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "pending",
    };

    storage.set("test:op:pending", pendingRecord);

    // Mark as completed
    const completedRecord: IdempotencyRecord = {
      ...pendingRecord,
      state: "completed",
      completedAt: new Date().toISOString(),
    };
    storage.set("test:op:pending", completedRecord);

    // Should not be in pending cache anymore
    // (would need to create a run record for it to be found)
    const retrieved = storage.get("test:op:pending");
    expect(retrieved).toBeNull(); // No run record exists
  });

  it("should check existence via has()", () => {
    const key = "guardkit:check:exists";
    expect(storage.has(key)).toBe(false);

    createTestRunRecord("guardkit", key, "success");

    expect(storage.has(key)).toBe(true);
  });

  it("should cleanup expired pending records only", () => {
    const oldPending: IdempotencyRecord = {
      key: "test:op:old",
      createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "old",
    };

    const newPending: IdempotencyRecord = {
      key: "test:op:new",
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName: "test",
      operation: "op",
      inputsHash: "new",
    };

    storage.set("test:op:old", oldPending);
    storage.set("test:op:new", newPending);

    // Cleanup with 1 hour TTL for pending
    storage.cleanupExpired(60 * 60 * 1000, 24 * 60 * 60 * 1000);

    expect(storage.get("test:op:old")).toBeNull();
    expect(storage.get("test:op:new")).not.toBeNull();
  });
});

describe("IdempotencyManager with storage backends", () => {
  describe("with InMemoryIdempotencyStorage (default)", () => {
    let manager: IdempotencyManager;

    beforeEach(() => {
      manager = createInMemoryIdempotencyManager();
    });

    afterEach(() => {
      manager.clear();
    });

    it("should track operations through lifecycle", () => {
      const key = "test:op:abc123";

      // Check - should return null (proceed)
      const check1 = manager.checkIdempotency(key, "test", "op", "hash123");
      expect(check1).toBeNull();

      // Start operation
      manager.startOperation(key, "test", "op", "hash123", "run-1");

      // Check again - should throw (in progress)
      expect(() =>
        manager.checkIdempotency(key, "test", "op", "hash123")
      ).toThrow();

      // Complete operation
      manager.completeOperation(key, { result: "data" }, "run-1");

      // Check again - should return completed record
      const check2 = manager.checkIdempotency<{ result: string }>(
        key,
        "test",
        "op",
        "hash123"
      );
      expect(check2).not.toBeNull();
      expect(check2?.state).toBe("completed");
      expect(check2?.cachedResult?.result).toBe("data");
    });

    it("should allow retry after failure", () => {
      const key = "test:op:retry";

      manager.startOperation(key, "test", "op", "hash123", "run-1");
      manager.failOperation(key);

      // Should allow retry
      const check = manager.checkIdempotency(key, "test", "op", "hash123");
      expect(check).toBeNull();
    });
  });

  describe("with RunRecordIdempotencyStorage", () => {
    let testDir: string;
    let manager: IdempotencyManager;

    beforeEach(() => {
      testDir = join(tmpdir(), `idem-manager-test-${randomUUID().slice(0, 8)}`);
      mkdirSync(testDir, { recursive: true });
      manager = createDurableIdempotencyManager(testDir);
    });

    afterEach(() => {
      manager.clear();
      if (existsSync(testDir)) {
        rmSync(testDir, { recursive: true, force: true });
      }
    });

    it("should find completed operations from run records", () => {
      // Create a run record directly with inputsHash stored
      const key = "guardkit:check:abc123";
      const inputsHash = "stored-hash-123";
      const record = createRunRecord({
        kit: { name: "guardkit", version: "0.1.0" },
        inputs: { test: true },
        status: "success",
        summary: "Test run",
        stage: "implement",
        risk: "low",
        traceId: randomUUID(),
        determinism: { idempotencyKey: key, inputsHash },
      });

      const kitDir = join(testDir, "guardkit");
      mkdirSync(kitDir, { recursive: true });
      writeFileSync(
        join(kitDir, `${record.runId}.json`),
        JSON.stringify(record, null, 2)
      );

      // Check should find it - use the same inputsHash
      const check = manager.checkIdempotency(key, "guardkit", "check", inputsHash);
      expect(check).not.toBeNull();
      expect(check?.state).toBe("completed");
    });

    it("should track pending operations in memory", () => {
      const key = "test:op:pending";

      manager.startOperation(key, "test", "op", "hash123", "run-1");

      // Should throw (in progress)
      expect(() =>
        manager.checkIdempotency(key, "test", "op", "hash123")
      ).toThrow();
    });
  });
});

