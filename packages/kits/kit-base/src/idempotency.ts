/**
 * Idempotency key management for Harmony Kits.
 *
 * Provides utilities for generating, validating, and tracking idempotency keys
 * to ensure deterministic, repeatable operations.
 *
 * Supports pluggable storage backends:
 * - In-memory (default, single process)
 * - Run records (durable, survives restarts)
 */

import { createHash, randomUUID } from "node:crypto";
import { IdempotencyConflictError } from "./errors.js";
import type { LifecycleStage } from "./types.js";
import {
  findRunRecordByIdempotencyKey,
  getRunsDirectory,
  type RunRecord,
} from "./run-record.js";

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

  /** Storage backend (default: in-memory) */
  storage?: IdempotencyStorage;
}

// ============================================================================
// Storage Abstraction
// ============================================================================

/**
 * Storage backend interface for idempotency records.
 *
 * Implementations can use different storage mechanisms:
 * - In-memory (default, single process)
 * - Run records (file-based, durable)
 * - Redis, database, etc. (external, distributed)
 */
export interface IdempotencyStorage {
  /**
   * Get an idempotency record by key.
   */
  get<T>(key: string): IdempotencyRecord<T> | null;

  /**
   * Set an idempotency record.
   */
  set(key: string, record: IdempotencyRecord<unknown>): void;

  /**
   * Delete an idempotency record.
   */
  delete(key: string): void;

  /**
   * Check if a record exists.
   */
  has(key: string): boolean;

  /**
   * Clear all records (for testing).
   */
  clear(): void;

  /**
   * Clean up expired records.
   */
  cleanupExpired(pendingTtlMs: number, completedTtlMs: number): void;
}

/**
 * In-memory storage backend for idempotency records.
 *
 * Suitable for single-process scenarios and testing.
 * Records are lost when the process exits.
 */
export class InMemoryIdempotencyStorage implements IdempotencyStorage {
  private records = new Map<string, IdempotencyRecord<unknown>>();

  get<T>(key: string): IdempotencyRecord<T> | null {
    const record = this.records.get(key);
    return record ? (record as IdempotencyRecord<T>) : null;
  }

  set(key: string, record: IdempotencyRecord<unknown>): void {
    this.records.set(key, record);
  }

  delete(key: string): void {
    this.records.delete(key);
  }

  has(key: string): boolean {
    return this.records.has(key);
  }

  clear(): void {
    this.records.clear();
  }

  cleanupExpired(pendingTtlMs: number, completedTtlMs: number): void {
    const now = Date.now();

    for (const [key, record] of this.records) {
      const createdAt = new Date(record.createdAt).getTime();
      const completedAt = record.completedAt
        ? new Date(record.completedAt).getTime()
        : null;

      if (record.state === "pending") {
        if (now - createdAt > pendingTtlMs) {
          this.records.delete(key);
        }
      } else if (record.state === "completed" || record.state === "failed") {
        const referenceTime = completedAt || createdAt;
        if (now - referenceTime > completedTtlMs) {
          this.records.delete(key);
        }
      }
    }
  }
}

/**
 * Run record-backed storage for idempotency records.
 *
 * Uses run records as a durable store for idempotency state.
 * Records persist across process restarts.
 *
 * Behavior:
 * - On get: Searches run records for matching idempotency key
 * - On set: Stores in memory (actual run record written by kit)
 * - Pending operations: In-memory only (not durable)
 * - Completed operations: Backed by run records on disk
 */
export class RunRecordIdempotencyStorage implements IdempotencyStorage {
  private runsDir: string;
  // In-memory cache for pending operations (not yet in run records)
  private pendingCache = new Map<string, IdempotencyRecord<unknown>>();

  constructor(runsDir?: string) {
    this.runsDir = runsDir || getRunsDirectory(process.cwd());
  }

  get<T>(key: string): IdempotencyRecord<T> | null {
    // First check pending cache
    const pending = this.pendingCache.get(key);
    if (pending) {
      return pending as IdempotencyRecord<T>;
    }

    // Then check run records for completed operations
    const runRecord = findRunRecordByIdempotencyKey(this.runsDir, key);
    if (runRecord) {
      return this.runRecordToIdempotencyRecord<T>(runRecord);
    }

    return null;
  }

  set(key: string, record: IdempotencyRecord<unknown>): void {
    // Pending operations go to cache
    // Completed operations will be persisted via run records
    if (record.state === "pending") {
      this.pendingCache.set(key, record);
    } else {
      // Remove from pending cache when completed/failed
      this.pendingCache.delete(key);
      // Note: The actual run record is written by the kit, not here
    }
  }

  delete(key: string): void {
    this.pendingCache.delete(key);
    // Note: We don't delete run records - they're append-only audit logs
  }

  has(key: string): boolean {
    if (this.pendingCache.has(key)) {
      return true;
    }
    const runRecord = findRunRecordByIdempotencyKey(this.runsDir, key);
    return runRecord !== null;
  }

  clear(): void {
    this.pendingCache.clear();
    // Note: We don't clear run records - they're append-only audit logs
  }

  cleanupExpired(pendingTtlMs: number, _completedTtlMs: number): void {
    // Only clean up pending cache (run records have their own retention)
    const now = Date.now();
    for (const [key, record] of this.pendingCache) {
      const createdAt = new Date(record.createdAt).getTime();
      if (now - createdAt > pendingTtlMs) {
        this.pendingCache.delete(key);
      }
    }
  }

  /**
   * Convert a run record to an idempotency record.
   */
  private runRecordToIdempotencyRecord<T>(
    runRecord: RunRecord
  ): IdempotencyRecord<T> {
    // Extract result from run record outputs if available
    const cachedResult = (runRecord as RunRecordWithOutputs).outputs as
      | T
      | undefined;

    return {
      key: runRecord.determinism?.idempotencyKey || "",
      createdAt: runRecord.createdAt,
      completedAt: runRecord.createdAt, // Run records are written on completion
      state: runRecord.status === "success" ? "completed" : "failed",
      kitName: runRecord.kit.name,
      operation: this.extractOperation(runRecord),
      runId: runRecord.runId,
      inputsHash: this.extractInputsHash(runRecord),
      cachedResult,
    };
  }

  /**
   * Extract operation name from run record.
   */
  private extractOperation(runRecord: RunRecord): string {
    // Try to extract from telemetry spans
    const spans = runRecord.telemetry.spans;
    if (spans && spans.length > 0) {
      // Span format: kit.<kitName>.<operation>
      const parts = spans[0].split(".");
      if (parts.length >= 3) {
        return parts[2];
      }
    }
    // Fallback to kit name
    return runRecord.kit.name;
  }

  /**
   * Extract inputs hash from run record.
   */
  private extractInputsHash(runRecord: RunRecord): string {
    // If we have the inputs hash stored in determinism, use it
    const determinismAny = runRecord.determinism as
      | (typeof runRecord.determinism & { inputsHash?: string })
      | undefined;
    if (determinismAny?.inputsHash) {
      return determinismAny.inputsHash;
    }
    // Otherwise, hash the inputs
    return hashInputs(runRecord.inputs);
  }
}

/**
 * Extended run record interface with outputs field.
 */
interface RunRecordWithOutputs extends RunRecord {
  outputs?: unknown;
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
 * Idempotency manager for tracking operation state.
 *
 * Supports pluggable storage backends:
 * - In-memory (default, single process)
 * - Run records (durable, survives restarts)
 * - Custom backends implementing IdempotencyStorage
 */
export class IdempotencyManager {
  private storage: IdempotencyStorage;
  private pendingTtlMs: number;
  private completedTtlMs: number;

  constructor(options: IdempotencyManagerOptions = {}) {
    this.pendingTtlMs = options.pendingTtlMs ?? 60 * 60 * 1000; // 1 hour
    this.completedTtlMs = options.completedTtlMs ?? 24 * 60 * 60 * 1000; // 24 hours
    this.storage = options.storage ?? new InMemoryIdempotencyStorage();
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

    const existing = this.storage.get<T>(key);
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
      return existing;
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
      this.storage.delete(key);
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

    this.storage.set(key, record);
    return record;
  }

  /**
   * Mark an operation as completed and store the result.
   */
  completeOperation<T = unknown>(key: string, result?: T, runId?: string): void {
    const existing = this.storage.get(key);
    if (existing) {
      const updated: IdempotencyRecord<unknown> = {
        ...existing,
        state: "completed",
        completedAt: new Date().toISOString(),
        cachedResult: result,
        ...(runId && { runId }),
      };
      this.storage.set(key, updated);
    }
  }

  /**
   * Mark an operation as failed.
   */
  failOperation(key: string): void {
    const existing = this.storage.get(key);
    if (existing) {
      const updated: IdempotencyRecord<unknown> = {
        ...existing,
        state: "failed",
        completedAt: new Date().toISOString(),
      };
      this.storage.set(key, updated);
    }
  }

  /**
   * Get a record by key.
   */
  getRecord<T = unknown>(key: string): IdempotencyRecord<T> | undefined {
    return this.storage.get<T>(key) ?? undefined;
  }

  /**
   * Clear all records (for testing).
   */
  clear(): void {
    this.storage.clear();
  }

  /**
   * Clean up expired records.
   */
  private cleanupExpired(): void {
    this.storage.cleanupExpired(this.pendingTtlMs, this.completedTtlMs);
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

/**
 * Create an idempotency manager with durable run record storage.
 *
 * Uses run records as the backing store, which:
 * - Survives process restarts
 * - Provides audit trail via run records
 * - Shares retention policy with run records cleanup
 *
 * @param runsDir - Directory containing run records (default: ./runs)
 * @param options - Additional manager options (TTLs)
 */
export function createDurableIdempotencyManager(
  runsDir?: string,
  options?: Omit<IdempotencyManagerOptions, "storage">
): IdempotencyManager {
  return new IdempotencyManager({
    ...options,
    storage: new RunRecordIdempotencyStorage(runsDir),
  });
}

/**
 * Create an idempotency manager with in-memory storage.
 *
 * Records are lost when the process exits. Suitable for:
 * - Single-process scenarios
 * - Testing
 * - Operations where durability isn't required
 *
 * @param options - Manager options (TTLs)
 */
export function createInMemoryIdempotencyManager(
  options?: Omit<IdempotencyManagerOptions, "storage">
): IdempotencyManager {
  return new IdempotencyManager({
    ...options,
    storage: new InMemoryIdempotencyStorage(),
  });
}

/**
 * Set the default idempotency manager to use durable storage.
 *
 * Call this early in your application if you want all kits
 * to use durable idempotency by default.
 *
 * @param runsDir - Directory containing run records (default: ./runs)
 */
export function useDurableIdempotency(runsDir?: string): void {
  defaultManager = createDurableIdempotencyManager(runsDir);
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

