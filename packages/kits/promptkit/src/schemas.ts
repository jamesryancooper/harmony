/**
 * PromptKit Zod Schemas
 *
 * Runtime validation schemas for PromptKit inputs and outputs.
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
 * Compile options schema.
 */
export const CompileOptionsSchema = z.object({
  /** Specific variant to use */
  variantId: z.string().optional(),

  /** Maximum tokens (truncates if exceeded) */
  maxTokens: z.number().positive().optional(),

  /** Override model selection */
  model: z.string().optional(),

  /** Risk tier for variant selection */
  tier: RiskTierSchema.optional(),

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
 * PromptKit configuration schema.
 */
export const PromptKitConfigSchema = z.object({
  /** Directory containing prompt files */
  promptsDir: z.string().optional(),

  /** Enable run records (default: true) */
  enableRunRecords: z.boolean().default(true),

  /** Directory to write run records */
  runsDir: z.string().optional(),
});

// ============================================================================
// Output Schemas
// ============================================================================

/**
 * Message role schema.
 */
export const MessageRoleSchema = z.enum(["system", "user", "assistant"]);

/**
 * Chat message schema.
 */
export const ChatMessageSchema = z.object({
  role: MessageRoleSchema,
  content: z.string(),
});

/**
 * Prompt metadata schema.
 */
export const PromptMetadataSchema = z.object({
  promptId: z.string(),
  variantId: z.string(),
  model: z.string(),
  temperature: z.number().optional(),
  maxOutputTokens: z.number().optional(),
});

/**
 * Compiled prompt schema.
 */
export const CompiledPromptSchema = z.object({
  /** Rendered prompt text */
  prompt: z.string(),

  /** Stable hash of the prompt */
  prompt_hash: z.string(),

  /** Chat messages (if applicable) */
  messages: z.array(ChatMessageSchema).optional(),

  /** Prompt metadata */
  metadata: PromptMetadataSchema,

  /** Variables used */
  variables: z.record(z.unknown()),

  /** Token estimate */
  estimatedTokens: z.number().optional(),
});

/**
 * Validation result schema.
 */
export const ValidationResultSchema = z.object({
  valid: z.boolean(),
  errors: z.array(z.string()),
  warnings: z.array(z.string()),
});

/**
 * Token info schema.
 */
export const TokenInfoSchema = z.object({
  tokens: z.number(),
  contextWindow: z.number(),
  usagePercent: z.number(),
  availableForOutput: z.number(),
  fitsInContext: z.boolean(),
});

/**
 * Prompt info schema.
 */
export const PromptInfoSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string(),
  version: z.string(),
  status: z.string(),
  category: z.string(),
  tierSupport: z.array(z.string()),
  variants: z.array(z.string()),
});

// ============================================================================
// Type Exports
// ============================================================================

export type RiskTier = z.infer<typeof RiskTierSchema>;
export type CompileOptions = z.infer<typeof CompileOptionsSchema>;
export type PromptKitConfig = z.infer<typeof PromptKitConfigSchema>;
export type MessageRole = z.infer<typeof MessageRoleSchema>;
export type ChatMessage = z.infer<typeof ChatMessageSchema>;
export type PromptMetadata = z.infer<typeof PromptMetadataSchema>;
export type CompiledPrompt = z.infer<typeof CompiledPromptSchema>;
export type ValidationResult = z.infer<typeof ValidationResultSchema>;
export type TokenInfo = z.infer<typeof TokenInfoSchema>;
export type PromptInfo = z.infer<typeof PromptInfoSchema>;

// ============================================================================
// Validation Functions
// ============================================================================

/**
 * Validate compile options.
 */
export function validateCompileOptions(options: unknown): CompileOptions {
  return CompileOptionsSchema.parse(options);
}

/**
 * Validate PromptKit configuration.
 */
export function validatePromptKitConfig(config: unknown): PromptKitConfig {
  return PromptKitConfigSchema.parse(config);
}

/**
 * Safe validation that returns a result instead of throwing.
 */
export function safeValidateCompileOptions(options: unknown): {
  success: boolean;
  data?: CompileOptions;
  error?: z.ZodError;
} {
  const result = CompileOptionsSchema.safeParse(options);
  if (result.success) {
    return { success: true, data: result.data };
  }
  return { success: false, error: result.error };
}

