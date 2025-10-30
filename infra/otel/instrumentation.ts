const otlpEndpoint = process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4318';

// Load Node-only OpenTelemetry modules at runtime using a dynamic import that
// the bundler cannot statically analyze. This prevents build-time resolution
// when this file is included in environments where Node-only deps are
// unavailable.
(async () => {
  try {
    // eslint-disable-next-line no-new-func
    const dynImport = new Function('m', 'return import(m)');

    const [{ NodeSDK }, { getNodeAutoInstrumentations }, { OTLPTraceExporter }, { OTLPMetricExporter }, { PeriodicExportingMetricReader }] = await Promise.all([
      dynImport('@opentelemetry/sdk-node'),
      dynImport('@opentelemetry/auto-instrumentations-node'),
      dynImport('@opentelemetry/exporter-trace-otlp-proto'),
      dynImport('@opentelemetry/exporter-metrics-otlp-proto'),
      dynImport('@opentelemetry/sdk-metrics')
    ]);

    const sdk = new NodeSDK({
      traceExporter: new OTLPTraceExporter({ url: `${otlpEndpoint}/v1/traces` }),
      metricReader: new PeriodicExportingMetricReader({
        exporter: new OTLPMetricExporter({ url: `${otlpEndpoint}/v1/metrics` })
      }),
      instrumentations: [getNodeAutoInstrumentations()]
    });

    // Some versions of @opentelemetry/sdk-node expose start() returning void rather than Promise.
    await Promise.resolve(sdk.start() as unknown as Promise<void>);
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('OTel init error', err);
  }
})();

