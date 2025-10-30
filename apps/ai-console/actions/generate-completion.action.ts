'use server';

import createAIGateway, {
  type GenerateCompletionDTO,
  type CompletionResponseDTO,
  AIServiceError
} from '@adapters/src/ai-gateway';

const DEFAULT_MODEL = process.env.AI_DEFAULT_MODEL || 'gpt-4.1-mini';
const DEFAULT_TEMPERATURE = 0.7;
const MAX_TOKENS_LIMIT = 512;

export default async function generateCompletion(
  input: GenerateCompletionDTO
): Promise<
  | { ok: true; data: CompletionResponseDTO }
  | { ok: false; error: string; status?: number }
> {
  try {
    const gateway = createAIGateway(process.env.AI_SERVICE_URL);

    const payload: GenerateCompletionDTO = {
      prompt: input.prompt?.trim() || '',
      model: input.model || DEFAULT_MODEL,
      temperature:
        typeof input.temperature === 'number' ? input.temperature : DEFAULT_TEMPERATURE,
      maxTokens:
        typeof input.maxTokens === 'number' && input.maxTokens > 0
          ? Math.min(input.maxTokens, MAX_TOKENS_LIMIT)
          : MAX_TOKENS_LIMIT
    };

    if (!payload.prompt) {
      return { ok: false, error: 'Prompt is required.' };
    }

    const data = await gateway.generateCompletion(payload);
    return { ok: true, data };
  } catch (err) {
    if (err instanceof AIServiceError) {
      return { ok: false, error: err.message, status: err.status };
    }
    return { ok: false, error: 'Unexpected error' };
  }
}


