import type { HealthPort } from '@domain/src/index';

export class HealthAdapter implements HealthPort {
  async check(): Promise<boolean> {
    return true; // placeholder implementation
  }
}

export { default as createAIGateway } from './ai-gateway';
export type {
  AIGateway,
  GenerateCompletionDTO,
  CompletionResponseDTO,
  GenerateEmbeddingDTO,
  EmbeddingResponseDTO
} from './ai-gateway';
export { AIServiceError } from './ai-gateway';

