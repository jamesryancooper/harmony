from __future__ import annotations

import os
from typing import Optional

from fastapi import FastAPI
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.logging import LoggingInstrumentation
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor


def init_otel(app: FastAPI, service_name: str = "ai-gateway") -> Optional[callable]:
    """
    Initialize OpenTelemetry tracing and instrument FastAPI and logging.

    Returns an optional shutdown callable for graceful teardown.
    """
    otlp_endpoint = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4318")
    resource = Resource.create({"service.name": service_name})

    provider = TracerProvider(resource=resource)
    trace.set_tracer_provider(provider)

    span_exporter = OTLPSpanExporter(endpoint=f"{otlp_endpoint}/v1/traces")
    provider.add_span_processor(BatchSpanProcessor(span_exporter))

    FastAPIInstrumentor.instrument_app(app)
    LoggingInstrumentation(set_logging_format=True)

    def _shutdown() -> None:
        provider.shutdown()

    return _shutdown


