/**
 * GuardKit Zod Schemas
 *
 * Runtime validation schemas for GuardKit inputs and outputs.
 */

import { z } from "zod";

// ============================================================================
// Input Schemas
// ============================================================================

/**
 * Block threshold levels.
 */
export const BlockThresholdSchema = z.enum(["critical", "high", "medium", "low"]);

/**
 * GuardKit configuration schema.
 */
export const GuardKitConfigSchema = z.object({
  /** Project root for import verification */
  projectRoot: z.string().optional(),

  /** Threshold at which content is blocked */
  blockThreshold: BlockThresholdSchema.default("high"),

  /** Enable run records (default: true) */
  enableRunRecords: z.boolean().default(true),

  /** Directory to write run records */
  runsDir: z.string().optional(),

  /** Dry-run mode */
  dryRun: z.boolean().default(false),

  /** Idempotency key */
  idempotencyKey: z.string().optional(),
});

/**
 * Check options schema.
 */
export const CheckOptionsSchema = z.object({
  /** Skip specific checks */
  skipChecks: z.array(z.string()).optional(),

  /** Additional context for checks */
  context: z.record(z.unknown()).optional(),
});

// ============================================================================
// Output Schemas
// ============================================================================

/**
 * Severity levels.
 */
export const SeveritySchema = z.enum(["critical", "high", "medium", "low", "info"]);

/**
 * Individual check result schema.
 */
export const CheckResultSchema = z.object({
  /** Check name */
  name: z.string(),

  /** Whether the check passed */
  passed: z.boolean(),

  /** Severity level */
  severity: SeveritySchema,

  /** Human-readable message */
  message: z.string(),

  /** Suggested fix */
  suggestion: z.string().optional(),

  /** Location information */
  location: z.object({
    start: z.number().optional(),
    end: z.number().optional(),
    line: z.number().optional(),
    column: z.number().optional(),
  }).optional(),
});

/**
 * Check summary schema.
 */
export const CheckSummarySchema = z.object({
  critical: z.number(),
  high: z.number(),
  medium: z.number(),
  low: z.number(),
  info: z.number(),
});

/**
 * Guardrail result schema.
 */
export const GuardrailResultSchema = z.object({
  /** Whether content is safe */
  safe: z.boolean(),

  /** Individual check results */
  checks: z.array(CheckResultSchema),

  /** Summary counts */
  summary: CheckSummarySchema,

  /** Total checks run */
  totalChecks: z.number(),

  /** Checks that passed */
  passedChecks: z.number(),

  /** Content hash for caching */
  contentHash: z.string().optional(),
});

/**
 * Modification record schema.
 */
export const ModificationSchema = z.object({
  type: z.string(),
  reason: z.string(),
  original: z.string().optional(),
  replacement: z.string().optional(),
});

/**
 * Redaction record schema.
 */
export const RedactionSchema = z.object({
  type: z.string(),
  count: z.number(),
});

/**
 * Sanitize result schema.
 */
export const SanitizeResultSchema = z.object({
  /** Sanitized content */
  sanitized: z.string(),

  /** Whether content was modified */
  modified: z.boolean(),

  /** List of modifications made */
  modifications: z.array(ModificationSchema),

  /** Redaction summary */
  redactions: z.array(RedactionSchema),
});

/**
 * Quick check result schema.
 */
export const QuickCheckResultSchema = z.object({
  /** Whether content is safe */
  safe: z.boolean(),

  /** Reason if unsafe */
  reason: z.string().optional(),
});

// ============================================================================
// Type Exports
// ============================================================================

export type BlockThreshold = z.infer<typeof BlockThresholdSchema>;
export type GuardKitConfig = z.infer<typeof GuardKitConfigSchema>;
export type CheckOptions = z.infer<typeof CheckOptionsSchema>;
export type Severity = z.infer<typeof SeveritySchema>;
export type CheckResult = z.infer<typeof CheckResultSchema>;
export type CheckSummary = z.infer<typeof CheckSummarySchema>;
export type GuardrailResult = z.infer<typeof GuardrailResultSchema>;
export type Modification = z.infer<typeof ModificationSchema>;
export type Redaction = z.infer<typeof RedactionSchema>;
export type SanitizeResult = z.infer<typeof SanitizeResultSchema>;
export type QuickCheckResult = z.infer<typeof QuickCheckResultSchema>;

// ============================================================================
// Validation Functions
// ============================================================================

/**
 * Validate GuardKit configuration.
 */
export function validateGuardKitConfig(config: unknown): GuardKitConfig {
  return GuardKitConfigSchema.parse(config);
}

/**
 * Safe validation that returns a result instead of throwing.
 */
export function safeValidateGuardKitConfig(config: unknown): {
  success: boolean;
  data?: GuardKitConfig;
  error?: z.ZodError;
} {
  const result = GuardKitConfigSchema.safeParse(config);
  if (result.success) {
    return { success: true, data: result.data };
  }
  return { success: false, error: result.error };
}

