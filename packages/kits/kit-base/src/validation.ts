/**
 * Zod-based schema validation for Harmony Kits.
 *
 * Provides runtime validation utilities that mirror the JSON Schema definitions
 * for kit inputs/outputs and metadata.
 */

import { z } from "zod";
import { InputValidationError } from "./errors.js";

// ============================================================================
// Core Type Schemas
// ============================================================================

/**
 * Harmony methodology pillars.
 */
export const HarmonyPillarSchema = z.enum([
  "speed_with_safety",
  "simplicity_over_complexity",
  "quality_through_determinism",
  "guided_agentic_autonomy",
  "evolvable_modularity",
]);

/**
 * Lifecycle stages in the Harmony methodology.
 */
export const LifecycleStageSchema = z.enum([
  "spec",
  "plan",
  "implement",
  "verify",
  "ship",
  "operate",
  "learn",
]);

/**
 * Risk tier classification.
 */
export const RiskTierSchema = z.enum(["T1", "T2", "T3"]);

/**
 * Risk level for HITL gates.
 */
export const RiskLevelSchema = z.enum(["trivial", "low", "medium", "high"]);

/**
 * Run status.
 */
export const RunStatusSchema = z.enum(["success", "failure"]);

// ============================================================================
// Kit Metadata Schemas
// ============================================================================

/**
 * Policy configuration schema.
 */
export const PolicyConfigSchema = z.object({
  rules: z.array(z.string()).optional(),
  rulesetVersion: z.string().optional(),
  failClosed: z.boolean().optional(),
});

/**
 * Observability configuration schema.
 */
export const ObservabilityConfigSchema = z.object({
  serviceName: z.string(),
  requiredSpans: z.array(z.string()),
  logRedaction: z.boolean().optional(),
});

/**
 * AI determinism configuration schema.
 */
export const AIConfigSchema = z.object({
  provider: z.string().optional(),
  model: z.string().optional(),
  temperatureMax: z.number().optional(),
  supportsSeed: z.boolean().optional(),
  promptHashAlgorithm: z.string().optional(),
});

/**
 * Determinism configuration schema.
 */
export const DeterminismConfigSchema = z.object({
  ai: AIConfigSchema.nullable().optional(),
  artifactNaming: z.string().optional(),
});

/**
 * HITL configuration schema.
 */
export const HITLConfigSchema = z.object({
  requiredFor: z.array(z.enum(["medium", "high"])).optional(),
});

/**
 * Safety configuration schema.
 */
export const SafetyConfigSchema = z.object({
  hitl: HITLConfigSchema.optional(),
});

/**
 * Idempotency configuration schema.
 */
export const IdempotencyConfigSchema = z.object({
  required: z.boolean().optional(),
  idempotencyKeyFrom: z.array(z.string()).optional(),
});

/**
 * Compatibility configuration schema.
 */
export const CompatibilityConfigSchema = z.object({
  contracts: z.array(z.string()).optional(),
  kits: z.array(z.string()).optional(),
  breakingChangePolicy: z.string().optional(),
  deprecatedSince: z.string().optional(),
});

/**
 * Dry-run configuration schema.
 */
export const DryRunConfigSchema = z.object({
  supported: z.boolean().optional(),
});

/**
 * Complete kit metadata schema (v1.1 - determinism, safety, idempotency required).
 */
export const KitMetadataSchema = z.object({
  name: z.string(),
  version: z.string().regex(/^\d+\.\d+\.\d+(-[A-Za-z0-9.-]+)?$/),
  description: z.string().optional(),
  pillars: z.array(HarmonyPillarSchema).min(1),
  lifecycleStages: z.array(LifecycleStageSchema).min(1),
  inputsSchema: z.string(),
  outputsSchema: z.string(),
  policy: PolicyConfigSchema.optional(),
  observability: ObservabilityConfigSchema,
  determinism: DeterminismConfigSchema,
  safety: SafetyConfigSchema,
  idempotency: IdempotencyConfigSchema,
  compatibility: CompatibilityConfigSchema.optional(),
  dryRun: DryRunConfigSchema.optional(),
});

// ============================================================================
// Standard Kit Config Schemas
// ============================================================================

/**
 * Base configuration schema that all kits should extend.
 */
export const BaseKitConfigSchema = z.object({
  /** Enable run record generation (default: true) */
  enableRunRecords: z.boolean().default(true),

  /** Directory to write run records */
  runsDir: z.string().optional(),

  /** Dry-run mode - validate without side effects */
  dryRun: z.boolean().default(false),

  /** Idempotency key for operations */
  idempotencyKey: z.string().optional(),
});

// ============================================================================
// Type Exports (inferred from schemas)
// ============================================================================

export type HarmonyPillar = z.infer<typeof HarmonyPillarSchema>;
export type LifecycleStage = z.infer<typeof LifecycleStageSchema>;
export type RiskTier = z.infer<typeof RiskTierSchema>;
export type RiskLevel = z.infer<typeof RiskLevelSchema>;
export type RunStatus = z.infer<typeof RunStatusSchema>;
export type PolicyConfig = z.infer<typeof PolicyConfigSchema>;
export type ObservabilityConfig = z.infer<typeof ObservabilityConfigSchema>;
export type DeterminismConfig = z.infer<typeof DeterminismConfigSchema>;
export type SafetyConfig = z.infer<typeof SafetyConfigSchema>;
export type IdempotencyConfig = z.infer<typeof IdempotencyConfigSchema>;
export type KitMetadata = z.infer<typeof KitMetadataSchema>;
export type BaseKitConfig = z.infer<typeof BaseKitConfigSchema>;

// ============================================================================
// Validation Functions
// ============================================================================

/**
 * Validation result type.
 */
export interface ValidationResult<T> {
  success: boolean;
  data?: T;
  errors?: Array<{
    path: string;
    message: string;
  }>;
}

/**
 * Validate kit metadata against the schema.
 */
export function validateKitMetadata(
  metadata: unknown
): ValidationResult<KitMetadata> {
  const result = KitMetadataSchema.safeParse(metadata);

  if (result.success) {
    return { success: true, data: result.data };
  }

  return {
    success: false,
    errors: result.error.errors.map((e) => ({
      path: e.path.join("."),
      message: e.message,
    })),
  };
}

/**
 * Validate and parse data against a Zod schema.
 * Throws InputValidationError on failure.
 */
export function validateWithSchema<T extends z.ZodType>(
  schema: T,
  data: unknown,
  schemaName: string
): z.infer<T> {
  const result = schema.safeParse(data);

  if (result.success) {
    return result.data;
  }

  const validationErrors = result.error.errors.map((e) => ({
    path: e.path.join("."),
    message: e.message,
  }));

  throw new InputValidationError(
    `Validation failed for ${schemaName}: ${validationErrors.map((e) => `${e.path}: ${e.message}`).join("; ")}`,
    {
      schema: schemaName,
      validationErrors,
    }
  );
}

/**
 * Create a validation function for a specific schema.
 */
export function createValidator<T extends z.ZodType>(
  schema: T,
  schemaName: string
): (data: unknown) => z.infer<T> {
  return (data: unknown) => validateWithSchema(schema, data, schemaName);
}

/**
 * Safe validation that returns a result instead of throwing.
 */
export function safeValidate<T extends z.ZodType>(
  schema: T,
  data: unknown
): ValidationResult<z.infer<T>> {
  const result = schema.safeParse(data);

  if (result.success) {
    return { success: true, data: result.data };
  }

  return {
    success: false,
    errors: result.error.errors.map((e) => ({
      path: e.path.join("."),
      message: e.message,
    })),
  };
}

/**
 * Merge base kit config with kit-specific config.
 */
export function mergeWithBaseConfig<T extends z.ZodRawShape>(
  kitSpecificSchema: z.ZodObject<T>
): z.ZodObject<T & typeof BaseKitConfigSchema.shape> {
  return BaseKitConfigSchema.merge(kitSpecificSchema);
}

// ============================================================================
// Re-export Zod for convenience
// ============================================================================

export { z } from "zod";

