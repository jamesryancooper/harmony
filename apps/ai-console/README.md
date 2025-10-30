# Harmony AI Console

Internal Next.js app for testing AI completions and embeddings via the Python AI Gateway.

## Scripts

- pnpm --filter @harmony/ai-console dev  (http://localhost:3001)
- pnpm --filter @harmony/ai-console build
- pnpm --filter @harmony/ai-console start (http://localhost:3001)

## Environment

- AI_SERVICE_URL (required): Base URL to the AI Gateway (e.g., http://localhost:8000).
- AI_DEFAULT_MODEL (optional): Default LLM model for completions.
- HARMONY_FLAG_* (optional): Feature flags consumed via @harmony/config (e.g., HARMONY_FLAG_ENABLENEWNAV=true).

## Pages

- /  (Home)
- /completions  (Prompt playground)
- /embeddings  (Embedding playground)
- /status  (Feature flags snapshot)

## Notes

- The dev server listens on port 3001 to avoid conflict with @harmony/api.
- OpenTelemetry is initialized through instrumentation.ts.
