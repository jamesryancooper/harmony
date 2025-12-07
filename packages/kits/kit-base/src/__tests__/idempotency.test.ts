/**
 * Tests for idempotency key management.
 */

import { describe, it, expect, beforeEach } from "vitest";
import {
  deriveIdempotencyKey,
  hashInputs,
  parseIdempotencyKey,
  IdempotencyManager,
  withIdempotency,
  checkIdempotencyKey,
  getIdempotencyManager,
  resetIdempotencyManager,
} from "../idempotency.js";
import { IdempotencyConflictError } from "../errors.js";

describe("idempotency", () => {
  beforeEach(() => {
    resetIdempotencyManager();
  });

  describe("deriveIdempotencyKey", () => {
    it("should generate stable key from inputs", () => {
      const key1 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "test-flow" },
      });

      const key2 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "test-flow" },
      });

      expect(key1).toBe(key2);
      expect(key1).toMatch(/^flowkit:run:[a-f0-9]{16}$/);
    });

    it("should generate different keys for different inputs", () => {
      const key1 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "flow-a" },
      });

      const key2 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "flow-b" },
      });

      expect(key1).not.toBe(key2);
    });

    it("should include gitSha in key derivation", () => {
      const key1 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "test" },
        gitSha: "abc123",
      });

      const key2 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "test" },
        gitSha: "def456",
      });

      expect(key1).not.toBe(key2);
    });

    it("should include stage in key derivation", () => {
      const key1 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "test" },
        stage: "implement",
      });

      const key2 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { flowName: "test" },
        stage: "verify",
      });

      expect(key1).not.toBe(key2);
    });

    it("should produce deterministic order for object keys", () => {
      const key1 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { a: 1, b: 2, c: 3 },
      });

      const key2 = deriveIdempotencyKey({
        kitName: "flowkit",
        operation: "run",
        stableInputs: { c: 3, a: 1, b: 2 },
      });

      expect(key1).toBe(key2);
    });
  });

  describe("hashInputs", () => {
    it("should hash inputs deterministically", () => {
      const hash1 = hashInputs({ a: 1, b: 2 });
      const hash2 = hashInputs({ b: 2, a: 1 });

      expect(hash1).toBe(hash2);
      expect(hash1).toHaveLength(32);
    });
  });

  describe("parseIdempotencyKey", () => {
    it("should parse valid key", () => {
      const parsed = parseIdempotencyKey("flowkit:run:abc123def456gh");

      expect(parsed).toEqual({
        kitName: "flowkit",
        operation: "run",
        hash: "abc123def456gh",
      });
    });

    it("should return null for invalid key", () => {
      expect(parseIdempotencyKey("invalid")).toBeNull();
      expect(parseIdempotencyKey("only:two")).toBeNull();
    });
  });

  describe("IdempotencyManager", () => {
    let manager: IdempotencyManager;

    beforeEach(() => {
      manager = new IdempotencyManager();
    });

    it("should return null for new operation", () => {
      const existing = manager.checkIdempotency(
        "flowkit:run:abc123",
        "flowkit",
        "run",
        "hash123"
      );

      expect(existing).toBeNull();
    });

    it("should track pending operations", () => {
      manager.startOperation("flowkit:run:abc123", "flowkit", "run", "hash123", "run-1");

      expect(() =>
        manager.checkIdempotency("flowkit:run:abc123", "flowkit", "run", "hash123")
      ).toThrow(IdempotencyConflictError);
    });

    it("should return completed operations with cached result", () => {
      const key = "flowkit:run:abc123";
      const cachedResult = { status: "success", value: 42 };
      manager.startOperation(key, "flowkit", "run", "hash123", "run-1");
      manager.completeOperation(key, cachedResult, "run-1");

      const existing = manager.checkIdempotency(key, "flowkit", "run", "hash123");

      expect(existing).toBeDefined();
      expect(existing?.state).toBe("completed");
      expect(existing?.runId).toBe("run-1");
      expect(existing?.cachedResult).toEqual(cachedResult);
    });

    it("should allow retry after failure", () => {
      const key = "flowkit:run:abc123";
      manager.startOperation(key, "flowkit", "run", "hash123", "run-1");
      manager.failOperation(key);

      const existing = manager.checkIdempotency(key, "flowkit", "run", "hash123");

      expect(existing).toBeNull(); // Allow retry
    });

    it("should detect mismatched inputs", () => {
      const key = "flowkit:run:abc123";
      manager.startOperation(key, "flowkit", "run", "hash123", "run-1");
      manager.completeOperation(key, { result: "test" }, "run-1");

      expect(() =>
        manager.checkIdempotency(key, "flowkit", "run", "different-hash")
      ).toThrow(IdempotencyConflictError);
    });

    it("should clear all records", () => {
      manager.startOperation("key1", "flowkit", "run", "hash1");
      manager.startOperation("key2", "flowkit", "run", "hash2");

      manager.clear();

      expect(manager.getRecord("key1")).toBeUndefined();
      expect(manager.getRecord("key2")).toBeUndefined();
    });
  });

  describe("withIdempotency", () => {
    beforeEach(() => {
      resetIdempotencyManager();
    });

    it("should execute operation and return result", async () => {
      const key = deriveIdempotencyKey({
        kitName: "testkit",
        operation: "test",
        stableInputs: { id: "test-1" },
      });

      const { result, cached, runId } = await withIdempotency(
        key,
        "testkit",
        "test",
        { id: "test-1" },
        async () => {
          return { success: true };
        }
      );

      expect(result).toEqual({ success: true });
      expect(cached).toBe(false);
      expect(runId).toBeDefined();
    });

    it("should return cached result for completed operation", async () => {
      const config = {
        kitName: "testkit",
        operation: "test",
        stableInputs: { id: "test-2" },
      };
      const key = deriveIdempotencyKey(config);
      const inputs = { id: "test-2" };
      const expectedResult = { value: 42, data: "test-data" };

      // First call - operation executes
      const firstCall = await withIdempotency(key, "testkit", "test", inputs, async () => {
        return expectedResult;
      });

      expect(firstCall.result).toEqual(expectedResult);
      expect(firstCall.cached).toBe(false);

      // Second call - should return cached result, not execute
      const secondCall = await withIdempotency(key, "testkit", "test", inputs, async () => {
        throw new Error("Should not execute - operation should be cached");
      });

      expect(secondCall.cached).toBe(true);
      expect(secondCall.result).toEqual(expectedResult);
      expect(secondCall.runId).toBe(firstCall.runId);
    });

    it("should mark operation as failed on error", async () => {
      const key = deriveIdempotencyKey({
        kitName: "testkit",
        operation: "test",
        stableInputs: { id: "test-3" },
      });

      await expect(
        withIdempotency(key, "testkit", "test", { id: "test-3" }, async () => {
          throw new Error("Test error");
        })
      ).rejects.toThrow("Test error");

      // Should allow retry after failure
      const { result, cached } = await withIdempotency(
        key,
        "testkit",
        "test",
        { id: "test-3" },
        async () => {
          return { retried: true };
        }
      );

      expect(result).toEqual({ retried: true });
      expect(cached).toBe(false);
    });
  });

  describe("checkIdempotencyKey", () => {
    it("should return null for new key", () => {
      const result = checkIdempotencyKey(
        "testkit:check:abc123",
        "testkit",
        "check",
        { data: "test" }
      );

      expect(result).toBeNull();
    });
  });

  describe("getIdempotencyManager", () => {
    it("should return singleton instance", () => {
      const manager1 = getIdempotencyManager();
      const manager2 = getIdempotencyManager();

      expect(manager1).toBe(manager2);
    });
  });
});

