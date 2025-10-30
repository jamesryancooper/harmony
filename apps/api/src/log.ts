import pino from 'pino';
import { context, trace } from '@opentelemetry/api';

export const log = pino({
  level: process.env.LOG_LEVEL || 'info',
  base: undefined,
  mixin() {
    const span = trace.getSpan(context.active());
    const traceId = span?.spanContext().traceId;
    return traceId ? { traceId } : {};
  },
  transport:
    process.env.NODE_ENV !== 'production'
      ? { target: 'pino-pretty', options: { colorize: true, translateTime: 'HH:MM:ss.l o' } }
      : undefined
});

export function withTrace(fields: Record<string, unknown> = {}) {
  const span = trace.getSpan(context.active());
  const traceId = span?.spanContext().traceId;
  return log.child(traceId ? { traceId, ...fields } : fields);
}

