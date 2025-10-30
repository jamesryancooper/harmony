'use server';

import createAIGateway, {
  type GenerateEmbeddingDTO,
  type EmbeddingResponseDTO,
  AIServiceError
} from '@adapters/src/ai-gateway';

const DEFAULT_MODEL = process.env.AI_DEFAULT_MODEL || 'text-embedding-3-small';

export default async function generateEmbedding(
  input: GenerateEmbeddingDTO
): Promise<
  | { ok: true; data: EmbeddingResponseDTO }
  | { ok: false; error: string; status?: number }
> {
  try {
    const gateway = createAIGateway(process.env.AI_SERVICE_URL);

    const payload: GenerateEmbeddingDTO = {
      input: input.input?.trim() || '',
      model: input.model || DEFAULT_MODEL
    };

    if (!payload.input) {
      return { ok: false, error: 'Input text is required.' };
    }

    const data = await gateway.generateEmbedding(payload);
    return { ok: true, data };
  } catch (err) {
    if (err instanceof AIServiceError) {
      return { ok: false, error: err.message, status: err.status };
    }
    return { ok: false, error: 'Unexpected error' };
  }
}


