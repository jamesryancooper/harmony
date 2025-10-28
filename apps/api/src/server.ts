// Import OpenTelemetry bootstrap early so it instruments the process.
import '@infra/otel/instrumentation';
import { withTrace } from './log';

async function main() {
  const log = withTrace({ svc: 'api' });
  log.info('API bootstrap (placeholder)');
}

main().catch((err) => {
  // minimal error logging for placeholder
  // eslint-disable-next-line no-console
  console.error(err);
  process.exit(1);
});
