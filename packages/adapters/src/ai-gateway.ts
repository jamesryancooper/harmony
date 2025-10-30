export interface GenerateCompletionDTO {
  prompt: string;
  model?: string;
  temperature?: number;
  maxTokens?: number;
}

export interface CompletionResponseDTO {
  output: string;
  model: string;
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
}

export interface GenerateEmbeddingDTO {
  input: string;
  model?: string;
}

export interface EmbeddingResponseDTO {
  embedding: number[];
  model: string;
}

/**
 * Error class for AI Gateway failures.
 */
export class AIServiceError extends Error {
  status?: number;
  constructor(message: string, status?: number) {
    super(message);
    this.name = 'AIServiceError';
    this.status = status;
  }
}

/**
 * Contract for the AI Gateway client.
 */
export interface AIGateway {
  generateCompletion(
    req: GenerateCompletionDTO,
    signal?: AbortSignal
  ): Promise<CompletionResponseDTO>;
  generateEmbedding(
    req: GenerateEmbeddingDTO,
    signal?: AbortSignal
  ): Promise<EmbeddingResponseDTO>;
}

const DEFAULT_AI_BASE_URL = (process.env.AI_SERVICE_URL as string) || 'http://localhost:8000';

/**
 * Create a typed client to the Python AI Gateway.
 * Uses JSON over HTTP.
 */
export default function createAIGateway(baseUrl: string = DEFAULT_AI_BASE_URL): AIGateway {
  async function handle<T>(res: Response): Promise<T> {
    if (!res.ok) {
      const text = await res.text().catch(() => '');
      throw new AIServiceError(text || `AI service error (${res.status})`, res.status);
    }
    return (await res.json()) as T;
  }

  function url(path: string): string {
    return new URL(path, baseUrl).toString();
  }

  return {
    async generateCompletion(req, signal) {
      const res = await fetch(url('/v1/llm/completions'), {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(req),
        signal
      });
      return handle<CompletionResponseDTO>(res);
    },

    async generateEmbedding(req, signal) {
      const res = await fetch(url('/v1/embeddings'), {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(req),
        signal
      });
      return handle<EmbeddingResponseDTO>(res);
    }
  };
}


