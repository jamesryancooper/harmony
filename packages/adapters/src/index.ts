import type { HealthPort } from '@domain/src/index';

export class HealthAdapter implements HealthPort {
  async check(): Promise<boolean> {
    return true; // placeholder implementation
  }
}

