# Harmony AI Gateway (Python)

Model-agnostic gateway for text completions and embeddings, built with FastAPI, LiteLLM, and OpenTelemetry. It centralizes provider keys, policies, and observability behind a single HTTP API that TypeScript apps consume via a small client adapter.

## Features

- Vendor-neutral API for LLM completions and embeddings (LiteLLM under the hood)
- JSON logs and OTLP traces for observability
- Stateless service suitable for serverless/containers
- TypeScript client in `packages/adapters` for easy consumption

## Endpoints

- `GET /health` → service status
- `POST /v1/llm/completions` → text generation
  - Request: `{ prompt: string, model?: string, temperature?: number, max_tokens?: number }`
  - Response: `{ output, model, promptTokens, completionTokens, totalTokens }`
- `POST /v1/embeddings` → dense vector embeddings
  - Request: `{ input: string, model?: string }`
  - Response: `{ embedding: number[], model }`

### API Examples

Completions:

```bash
curl -sS -X POST http://localhost:8000/v1/llm/completions \
  -H 'content-type: application/json' \
  -d '{"prompt":"Say hello","temperature":0.2,"max_tokens":64}'
```

Embeddings:

```bash
curl -sS -X POST http://localhost:8000/v1/embeddings \
  -H 'content-type: application/json' \
  -d '{"input":"The quick brown fox"}'
```

## Quick Start (Local)

Prereqs:

- Python 3.11+
- `uv` (fast Python package manager)
- Provider API key(s) for your chosen LLM(s), e.g. `OPENAI_API_KEY`

Run the service:

```bash
# Using PNPM (monorepo friendly)
pnpm --filter @harmony/ai-gateway dev

# Or directly
cd apps/ai-gateway
uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Smoke test:

```bash
curl -sS http://localhost:8000/health
```

## Configuration

Environment variables:

- `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY` (as needed by LiteLLM)
- `LITELLM_MODEL` (default completion model, e.g. `gpt-4o-mini`)
- `LITELLM_EMBED_MODEL` (default embed model, e.g. `text-embedding-3-small`)
- `OTEL_EXPORTER_OTLP_ENDPOINT` (default `http://localhost:4318`)

Example `.env`:

```bash
OPENAI_API_KEY=sk-...
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
LITELLM_MODEL=gpt-4o-mini
LITELLM_EMBED_MODEL=text-embedding-3-small
```

## TypeScript Client Usage

Use the adapter exported from `packages/adapters`:

```ts
import { createAIGateway } from '@adapters/src';

const ai = createAIGateway(process.env.AI_SERVICE_URL || 'http://localhost:8000');

const completion = await ai.generateCompletion({ prompt: 'Hello world', temperature: 0.2 });
console.log(completion.output);

const embedding = await ai.generateEmbedding({ input: 'The quick brown fox' });
console.log(embedding.embedding.length);
```

## Development

Common commands (via PNPM scripts calling `uv`):

```bash
# Install deps (creates a .venv managed by uv)
cd apps/ai-gateway && uv sync --all-extras

# Lint + format check
pnpm --filter @harmony/ai-gateway lint

# Type check (mypy)
pnpm --filter @harmony/ai-gateway typecheck

# Tests (pytest)
pnpm --filter @harmony/ai-gateway test
```

## Observability

- Traces exported to OTLP: set `OTEL_EXPORTER_OTLP_ENDPOINT` (default `http://localhost:4318`).
- When the calling service (Node) is instrumented, W3C trace context propagates across HTTP.

## Security & Hardening

- Keep provider API keys only in this service.
- Before exposing publicly, add authentication (e.g., HMAC service token) and rate limiting.
- Consider request/response schema enforcement and logging redaction for sensitive data.

## CI

- The repo’s PR workflow includes a conditional Python job for this app: `uv sync`, ruff/black, mypy, pytest, and a license report.
- See `infra/ci/pr.yml` for details.
