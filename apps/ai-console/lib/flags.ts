import { listFlags } from '@config/flags';

export function getFlagSnapshot(): Readonly<Record<string, boolean>> {
  return listFlags();
}


