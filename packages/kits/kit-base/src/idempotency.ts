/**
 * Idempotency key management for Harmony Kits.
 *
 * Provides utilities for generating, validating, and tracking idempotency keys
 * to ensure deterministic, repeatable operations.
 */

import { createHash, randomUUID } from "node:crypto";
import { IdempotencyConflictError } from "./errors.js";
import type { LifecycleStage } from "./types.js";

// ============================================================================
// Types
// ============================================================================

/**
 * Configuration for idempotency key derivation.
 */
export interface IdempotencyKeyConfig {
  /** Kit name */
  kitName: string;

  /** Operation name */
  operation: string;

  /** Stable inputs to hash (should exclude timestamps and random values) */
  stableInputs: Record<string, unknown>;

  /** Git SHA for additional stability */
  gitSha?: string;

  /** Lifecycle stage */
  stage?: LifecycleStage;
}

/**
 * State of an idempotency record.
 */
export type IdempotencyState = "pending" | "completed" | "failed";

/**
 * Stored idempotency record.
 */
export interface IdempotencyRecord<T = unknown> {
  /** The idempotency key */
  key: string;

  /** When the record was created */
  createdAt: string;

  /** When the operation completed (if completed) */
  completedAt?: string;

  /** Current state */
  state: IdempotencyState;

  /** Kit that created the record */
  kitName: string;

  /** Operation name */
  operation: string;

  /** Run ID associated with this operation */
  runId?: string;

  /** Hash of the inputs for verification */
  inputsHash: string;

  /** Cached result from completed operation */
  cachedResult?: T;
}

/**
 * Options for IdempotencyManager.
 */
export interface IdempotencyManagerOptions {
  /** Time-to-live for pending records in milliseconds (default: 1 hour) */
  pendingTtlMs?: number;

  /** Time-to-live for completed records in milliseconds (default: 24 hours) */
  completedTtlMs?: number;
}

// ============================================================================
// Key Generation
// ============================================================================

/**
 * Derive a stable idempotency key from configuration.
 *
 * The key is derived from:
 * - Kit name
 * - Operation name
 * - Stable inputs (JSON stringified with sorted keys)
 * - Git SHA (if provided)
 * - Lifecycle stage (if provided)
 *
 * Format: `<kitName>:<operation>:<hash>`
 */
export function deriveIdempotencyKey(config: IdempotencyKeyConfig): string {
  const { kitName, operation, stableInputs, gitSha, stage } = config;

  // Create a canonical representation of inputs
  const canonicalInputs = JSON.stringify(stableInputs, Object.keys(stableInputs).sort());

  // Combine all stable factors
  const factors = [
    kitName,
    operation,
    canonicalInputs,
    gitSha || "",
    stage || "",
  ].join(":");

  // Generate SHA-256 hash and take first 16 chars for brevity
  const hash = createHash("sha256").update(factors).digest("hex").slice(0, 16);

  return `${kitName}:${operation}:${hash}`;
}

/**
 * Generate a hash of inputs for verification.
 */
export function hashInputs(inputs: Record<string, unknown>): string {
  const canonical = JSON.stringify(inputs, Object.keys(inputs).sort());
  return createHash("sha256").update(canonical).digest("hex").slice(0, 32);
}

/**
 * Parse an idempotency key into its components.
 */
export function parseIdempotencyKey(key: string): {
  kitName: string;
  operation: string;
  hash: string;
} | null {
  const parts = key.split(":");
  if (parts.length !== 3) {
    return null;
  }

  return {
    kitName: parts[0],
    operation: parts[1],
    hash: parts[2],
  };
}

// ============================================================================
// Idempotency Manager
// ============================================================================

/**
 * In-memory idempotency manager for tracking operation state.
 *
 * In production, this would typically be backed by a persistent store
 * (Redis, database, etc.). The in-memory implementation is suitable for
 * single-process scenarios and testing.
 */
export class IdempotencyManager {
  private records: Map<string, IdempotencyRecord<unknown>> = new Map();
  private pendingTtlMs: number;
  private completedTtlMs: number;

  constructor(options: IdempotencyManagerOptions = {}) {
    this.pendingTtlMs = options.pendingTtlMs ?? 60 * 60 * 1000; // 1 hour
    this.completedTtlMs = options.completedTtlMs ?? 24 * 60 * 60 * 1000; // 24 hours
  }

  /**
   * Check if an operation can proceed with the given idempotency key.
   *
   * @returns The existing record if found, null if the operation can proceed
   * @throws IdempotencyConflictError if there's a pending operation with the same key
   */
  checkIdempotency<T = unknown>(
    key: string,
    kitName: string,
    operation: string,
    inputsHash: string
  ): IdempotencyRecord<T> | null {
    this.cleanupExpired();

    const existing = this.records.get(key);
    if (!existing) {
      return null;
    }

    // If completed successfully, return the existing record
    if (existing.state === "completed") {
      // Verify inputs match
      if (existing.inputsHash !== inputsHash) {
        throw new IdempotencyConflictError(
          `Idempotency key ${key} was used with different inputs`,
          {
            idempotencyKey: key,
            conflictingRunId: existing.runId,
          }
        );
      }
      return existing as IdempotencyRecord<T>;
    }

    // If failed, allow retry
    if (existing.state === "failed") {
      return null;
    }

    // If pending, check if it's stale
    const createdAt = new Date(existing.createdAt).getTime();
    const isStale = Date.now() - createdAt > this.pendingTtlMs;

    if (isStale) {
      // Remove stale record and allow retry
      this.records.delete(key);
      return null;
    }

    // Active pending operation - conflict
    throw new IdempotencyConflictError(
      `Operation with idempotency key ${key} is already in progress`,
      {
        idempotencyKey: key,
        conflictingRunId: existing.runId,
      }
    );
  }

  /**
   * Start tracking an operation with the given idempotency key.
   */
  startOperation(
    key: string,
    kitName: string,
    operation: string,
    inputsHash: string,
    runId?: string
  ): IdempotencyRecord<unknown> {
    const record: IdempotencyRecord<unknown> = {
      key,
      createdAt: new Date().toISOString(),
      state: "pending",
      kitName,
      operation,
      runId,
      inputsHash,
    };

    this.records.set(key, record);
    return record;
  }

  /**
   * Mark an operation as completed and store the result.
   */
  completeOperation<T = unknown>(key: string, result?: T, runId?: string): void {
    const record = this.records.get(key);
    if (record) {
      record.state = "completed";
      record.completedAt = new Date().toISOString();
      record.cachedResult = result;
      if (runId) {
        record.runId = runId;
      }
    }
  }

  /**
   * Mark an operation as failed.
   */
  failOperation(key: string): void {
    const record = this.records.get(key);
    if (record) {
      record.state = "failed";
      record.completedAt = new Date().toISOString();
    }
  }

  /**
   * Get a record by key.
   */
  getRecord<T = unknown>(key: string): IdempotencyRecord<T> | undefined {
    return this.records.get(key) as IdempotencyRecord<T> | undefined;
  }

  /**
   * Clear all records (for testing).
   */
  clear(): void {
    this.records.clear();
  }

  /**
   * Clean up expired records.
   */
  private cleanupExpired(): void {
    const now = Date.now();

    for (const [key, record] of this.records) {
      const createdAt = new Date(record.createdAt).getTime();
      const completedAt = record.completedAt
        ? new Date(record.completedAt).getTime()
        : null;

      if (record.state === "pending") {
        if (now - createdAt > this.pendingTtlMs) {
          this.records.delete(key);
        }
      } else if (record.state === "completed" || record.state === "failed") {
        const referenceTime = completedAt || createdAt;
        if (now - referenceTime > this.completedTtlMs) {
          this.records.delete(key);
        }
      }
    }
  }
}

// ============================================================================
// Singleton Instance
// ============================================================================

let defaultManager: IdempotencyManager | null = null;

/**
 * Get the default idempotency manager instance.
 */
export function getIdempotencyManager(): IdempotencyManager {
  if (!defaultManager) {
    defaultManager = new IdempotencyManager();
  }
  return defaultManager;
}

/**
 * Reset the default idempotency manager (for testing).
 */
export function resetIdempotencyManager(): void {
  defaultManager = null;
}

// ============================================================================
// Helper Functions
// ============================================================================

/**
 * Execute an operation with idempotency protection.
 *
 * @param key - Idempotency key (or config to derive one)
 * @param kitName - Kit name
 * @param operation - Operation name
 * @param inputs - Operation inputs
 * @param fn - The operation to execute
 * @returns The result of the operation, or the cached result if already completed
 */
export async function withIdempotency<T>(
  key: string | IdempotencyKeyConfig,
  kitName: string,
  operation: string,
  inputs: Record<string, unknown>,
  fn: () => Promise<T>
): Promise<{ result: T; cached: boolean; runId?: string }> {
  const manager = getIdempotencyManager();

  const idempotencyKey =
    typeof key === "string" ? key : deriveIdempotencyKey(key);
  const inputsHash = hashInputs(inputs);

  // Check for existing operation
  const existing = manager.checkIdempotency<T>(
    idempotencyKey,
    kitName,
    operation,
    inputsHash
  );

  if (existing && existing.state === "completed") {
    // Return the cached result from the previous execution
    return {
      result: existing.cachedResult as T,
      cached: true,
      runId: existing.runId,
    };
  }

  // Start new operation
  const runId = randomUUID();
  manager.startOperation(idempotencyKey, kitName, operation, inputsHash, runId);

  try {
    const result = await fn();
    manager.completeOperation(idempotencyKey, result, runId);
    return { result, cached: false, runId };
  } catch (error) {
    manager.failOperation(idempotencyKey);
    throw error;
  }
}

/**
 * Check if an operation should be skipped due to idempotency.
 *
 * Returns the existing record if the operation was already completed,
 * null if the operation should proceed.
 */
export function checkIdempotencyKey<T = unknown>(
  key: string,
  kitName: string,
  operation: string,
  inputs: Record<string, unknown>
): IdempotencyRecord<T> | null {
  const manager = getIdempotencyManager();
  const inputsHash = hashInputs(inputs);
  return manager.checkIdempotency<T>(key, kitName, operation, inputsHash);
}

