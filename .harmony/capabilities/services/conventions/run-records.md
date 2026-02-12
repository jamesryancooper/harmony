---
title: Service Run Records
scope: harness
applies_to: services
migrated_from: packages/kits/kit-base/src/run-record.ts
---

# Service Run Records

Run records are canonical execution artifacts for reproducibility, auditability, and idempotency replay.

## Canonical Record Shape

Base implementation source:

- `packages/kits/kit-base/src/run-record.ts`
- `packages/kits/kit-base/schema/run-record.v1.json`

Core fields:

- Identity: `runId`, `kit/service name`, `version`
- Inputs: sanitized `inputs` (sensitive keys redacted)
- Outcome: `status`, `summary`, `durationMs`
- Methodology: `stage`, `risk`, optional `hitl`
- Telemetry: `telemetry.trace_id`, optional `telemetry.spans`
- Determinism: optional `determinism.prompt_hash`, `idempotencyKey`, `inputsHash`, `cacheKey`
- Replay: optional `outputs`
- Time: `createdAt`

## Lifecycle

1. Create run context at service entry.
2. Execute operation and capture output/failure.
3. Persist record to runs directory (`runs/<service>/<runId>.json`) using best-effort safety for non-critical write paths.
4. Index/query by trace ID or idempotency key when needed.
5. Apply retention cleanup separately.

## Enumerations

- `status`: `success | failure`
- `stage`: `spec | plan | implement | verify | ship | operate | learn`
- `risk`: `trivial | low | medium | high`

## Redaction Rules

Sensitive input key patterns include (case-insensitive):

- `api_key`, `secret`, `password`, `token`, `auth`, `credential`, `private_key`, `access_key`

Matched values must be replaced with `"<REDACTED>"` in persisted records.
