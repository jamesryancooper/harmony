# Harmony API (Node)

HTTP API boundary for the Harmony system. It composes Domain (`@harmony/domain`) and Adapters (`@harmony/adapters`) to expose stable, observable endpoints. Logging is structured (Pino) with OpenTelemetry trace correlation.

## Features

- Fastify-based HTTP server (v5)
- Health, flags, version, and example `v1/ping` endpoints
- Structured logs (Pino) with `traceId` auto-injected when spans are active
- OpenTelemetry Node SDK bootstrap (OTLP traces/metrics)
- Clean layering: UI-free, orchestration only, integrations via Adapters

## Endpoints

- `GET /health` → service health
  - Response: `{ ok: boolean, uptimeMs?: number, error?: string }`
- `GET /flags` → feature flags snapshot (see `packages/config/flags.ts`)
  - Response: `Record<string, boolean>`
- `GET /version` → running version
  - Response: `{ version: string }`
- `GET /v1/ping` → sample v1 endpoint
  - Response: `{ pong: true }`

### Examples

```bash
curl -sS http://localhost:3000/health | jq
curl -sS http://localhost:3000/flags | jq
curl -sS http://localhost:3000/version | jq
curl -sS http://localhost:3000/v1/ping | jq
```

## Quick Start (Local)

Prereqs:

- Node 22.x (recommended) and PNPM 10.x
- Optional: an OTLP collector (default `http://localhost:4318`)

Run the service:

```bash
# From repo root — API is the default app
pnpm dev

# Or explicitly by filter
pnpm --filter @harmony/api dev
```

Smoke test:

```bash
curl -sS http://localhost:3000/health
```

### Production-like run

```bash
pnpm --filter @harmony/api build
pnpm --filter @harmony/api start
```

## Configuration

Environment variables:

- `PORT` (default `3000`)
- `HOST` (default `0.0.0.0`)
- `LOG_LEVEL` (default `info`)
- `APP_VERSION` (optional; reported by `/version`)
- `OTEL_EXPORTER_OTLP_ENDPOINT` (default `http://localhost:4318`)

Example `.env` (shell):

```bash
PORT=3000
HOST=0.0.0.0
LOG_LEVEL=debug
APP_VERSION=0.0.1-local
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
```

## Development

Common commands:

```bash
# Dev server (watch mode)
pnpm --filter @harmony/api dev

# Type check
pnpm --filter @harmony/api typecheck

# Lint
pnpm --filter @harmony/api lint

# Build and start (prod)
pnpm --filter @harmony/api build && pnpm --filter @harmony/api start
```

## Architecture & Boundaries

- Purpose: HTTP transport, request validation, orchestration of use cases, error/status mapping
- Non-responsibilities: UI rendering, core business rules (see `packages/domain`), integration details (see `packages/adapters`)
- Feature flags: `packages/config/flags.ts` with provider → env (`HARMONY_FLAG_*`) → defaults resolution
- Logging: `apps/api/src/log.ts` (Pino) injects `traceId` via OpenTelemetry context
- Tracing/metrics: `infra/otel/instrumentation.ts` bootstraps auto-instrumentations and OTLP exporters

## Observability

- Traces/metrics exported to OTLP; configure `OTEL_EXPORTER_OTLP_ENDPOINT` (default `http://localhost:4318`)
- Logs are JSON in production; in dev, `pino-pretty` is enabled for readability
- Each log line includes `traceId` when a span is active, enabling log-trace correlation

## Security & Hardening

- Before exposing publicly, add: authentication/authorization, rate limiting, schema validation, CORS policy tightening
- Redact sensitive fields in logs; prefer structured logging with explicit keys
- Keep secrets in environment or a secret manager, not committed to the repo

## CI

- The PR workflow runs typecheck, lint, tests, build, plus security checks and SBOM generation
- Preview deployments may run for web apps; API can be containerized or run as a Node service

---

See also:

- `infra/otel/instrumentation.ts` for OpenTelemetry setup
- `packages/config/flags.ts` for feature flag behavior
- `packages/domain` / `packages/adapters` for business and integration layers
