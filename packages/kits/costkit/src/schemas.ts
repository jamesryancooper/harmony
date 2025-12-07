/**
 * CostKit Zod Schemas
 *
 * Runtime validation schemas for CostKit inputs and outputs.
 */

import { z } from "zod";

// ============================================================================
// Input Schemas
// ============================================================================

/**
 * Risk tier schema.
 */
export const RiskTierSchema = z.enum(["T1", "T2", "T3"]);

/**
 * Workflow stage schema.
 */
export const WorkflowStageSchema = z.enum(["draft", "final"]);

/**
 * Budget period schema.
 */
export const BudgetPeriodSchema = z.enum(["daily", "weekly", "monthly"]);

/**
 * CostKit configuration schema.
 */
export const CostKitConfigSchema = z.object({
  /** Path to cost policy YAML */
  policyPath: z.string().optional(),

  /** Path to cost data file */
  dataPath: z.string().optional(),

  /** Enable run records (default: true) */
  enableRunRecords: z.boolean().default(true),

  /** Directory to write run records */
  runsDir: z.string().optional(),

  /** Idempotency key */
  idempotencyKey: z.string().optional(),

  /** Dry-run mode */
  dryRun: z.boolean().default(false),
});

/**
 * Estimate request schema.
 */
export const EstimateRequestSchema = z.object({
  /** Workflow type */
  workflowType: z.string(),

  /** Risk tier */
  tier: RiskTierSchema.default("T2"),

  /** Workflow stage */
  stage: WorkflowStageSchema.default("final"),

  /** Override model */
  model: z.string().optional(),

  /** Idempotency key */
  idempotencyKey: z.string().optional(),
});

/**
 * Record usage request schema.
 */
export const RecordUsageRequestSchema = z.object({
  /** Model used */
  model: z.string(),

  /** Input tokens */
  inputTokens: z.number().nonnegative(),

  /** Output tokens */
  outputTokens: z.number().nonnegative(),

  /** Workflow type */
  workflowType: z.string(),

  /** Risk tier */
  tier: RiskTierSchema.default("T2"),

  /** Duration in milliseconds */
  durationMs: z.number().nonnegative(),

  /** Whether the operation succeeded */
  success: z.boolean(),

  /** Idempotency key */
  idempotencyKey: z.string().optional(),
});

// ============================================================================
// Output Schemas
// ============================================================================

/**
 * Cost range schema.
 */
export const CostRangeSchema = z.object({
  min: z.number(),
  max: z.number(),
});

/**
 * Token estimate schema.
 */
export const TokenEstimateSchema = z.object({
  input: z.number(),
  output: z.number(),
});

/**
 * Cost estimate schema.
 */
export const CostEstimateSchema = z.object({
  /** Workflow type */
  workflowType: z.string(),

  /** Risk tier */
  tier: RiskTierSchema,

  /** Model used for estimate */
  model: z.string(),

  /** Estimated cost in USD */
  estimatedCostUsd: z.number(),

  /** Cost range */
  costRange: CostRangeSchema,

  /** Estimated tokens */
  estimatedTokens: TokenEstimateSchema,

  /** Whether this exceeds budget */
  exceedsBudget: z.boolean(),

  /** Budget remaining after this estimate */
  budgetRemainingUsd: z.number().optional(),
});

/**
 * Usage record schema.
 */
export const UsageRecordSchema = z.object({
  /** Record ID */
  id: z.string(),

  /** Timestamp */
  timestamp: z.string(),

  /** Model used */
  model: z.string(),

  /** Input tokens */
  inputTokens: z.number(),

  /** Output tokens */
  outputTokens: z.number(),

  /** Actual cost in USD */
  actualCostUsd: z.number(),

  /** Workflow type */
  workflowType: z.string(),

  /** Risk tier */
  tier: RiskTierSchema,

  /** Duration in milliseconds */
  durationMs: z.number(),

  /** Whether the operation succeeded */
  success: z.boolean(),
});

/**
 * Budget status schema.
 */
export const BudgetStatusSchema = z.object({
  /** Budget period */
  period: BudgetPeriodSchema,

  /** Amount spent in USD */
  spentUsd: z.number(),

  /** Budget limit in USD */
  limitUsd: z.number(),

  /** Remaining budget in USD */
  remainingUsd: z.number(),

  /** Usage percentage */
  usedPercent: z.number(),

  /** Whether over budget */
  overBudget: z.boolean(),

  /** Whether warning threshold triggered */
  warningTriggered: z.boolean(),
});

/**
 * Model cost breakdown schema.
 */
export const ModelCostBreakdownSchema = z.object({
  costUsd: z.number(),
  requests: z.number(),
  tokens: z.number(),
});

/**
 * Cost trend schema.
 */
export const CostTrendSchema = z.object({
  changePercent: z.number(),
  direction: z.enum(["up", "down", "stable"]),
});

/**
 * Cost summary schema.
 */
export const CostSummarySchema = z.object({
  /** Period covered */
  period: z.object({
    start: z.string(),
    end: z.string(),
  }),

  /** Total cost in USD */
  totalCostUsd: z.number(),

  /** Total requests */
  totalRequests: z.number(),

  /** Total tokens */
  totalTokens: z.number(),

  /** Breakdown by model */
  byModel: z.record(ModelCostBreakdownSchema).optional(),

  /** Breakdown by workflow */
  byWorkflow: z.record(ModelCostBreakdownSchema).optional(),

  /** Trend compared to previous period */
  trend: CostTrendSchema.optional(),
});

/**
 * Alert severity schema.
 */
export const AlertSeveritySchema = z.enum(["info", "warning", "critical"]);

/**
 * Cost alert schema.
 */
export const CostAlertSchema = z.object({
  /** Alert ID */
  id: z.string(),

  /** Alert type */
  type: z.string(),

  /** Severity */
  severity: AlertSeveritySchema,

  /** Alert message */
  message: z.string(),

  /** Timestamp */
  timestamp: z.string(),

  /** Whether acknowledged */
  acknowledged: z.boolean(),
});

// ============================================================================
// Type Exports
// ============================================================================

export type RiskTier = z.infer<typeof RiskTierSchema>;
export type WorkflowStage = z.infer<typeof WorkflowStageSchema>;
export type BudgetPeriod = z.infer<typeof BudgetPeriodSchema>;
export type CostKitConfig = z.infer<typeof CostKitConfigSchema>;
export type EstimateRequest = z.infer<typeof EstimateRequestSchema>;
export type RecordUsageRequest = z.infer<typeof RecordUsageRequestSchema>;
export type CostRange = z.infer<typeof CostRangeSchema>;
export type TokenEstimate = z.infer<typeof TokenEstimateSchema>;
export type CostEstimate = z.infer<typeof CostEstimateSchema>;
export type UsageRecord = z.infer<typeof UsageRecordSchema>;
export type BudgetStatus = z.infer<typeof BudgetStatusSchema>;
export type CostSummary = z.infer<typeof CostSummarySchema>;
export type CostTrend = z.infer<typeof CostTrendSchema>;
export type AlertSeverity = z.infer<typeof AlertSeveritySchema>;
export type CostAlert = z.infer<typeof CostAlertSchema>;

// ============================================================================
// Validation Functions
// ============================================================================

/**
 * Validate CostKit configuration.
 */
export function validateCostKitConfig(config: unknown): CostKitConfig {
  return CostKitConfigSchema.parse(config);
}

/**
 * Validate estimate request.
 */
export function validateEstimateRequest(request: unknown): EstimateRequest {
  return EstimateRequestSchema.parse(request);
}

/**
 * Validate record usage request.
 */
export function validateRecordUsageRequest(request: unknown): RecordUsageRequest {
  return RecordUsageRequestSchema.parse(request);
}

/**
 * Safe validation that returns a result instead of throwing.
 */
export function safeValidateCostKitConfig(config: unknown): {
  success: boolean;
  data?: CostKitConfig;
  error?: z.ZodError;
} {
  const result = CostKitConfigSchema.safeParse(config);
  if (result.success) {
    return { success: true, data: result.data };
  }
  return { success: false, error: result.error };
}

