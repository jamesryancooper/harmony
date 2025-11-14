---
title: Implementation Profile — Next.js/Astro/Vercel
description: Stack-specific guidance for applying HSP using Next.js 16/React 19, Astro, and Vercel with the canonical apps/* + packages/* layout.
---

# Implementation Profile: Next.js/Astro/Vercel

Related docs: [overview](./overview.md), [monorepo layout](./monorepo-layout.md), [repository blueprint](./repository-blueprint.md), [runtime policy](./runtime-policy.md), [observability requirements](./observability-requirements.md), [tooling integration](./tooling-integration.md)

This profile applies the Harmony Structural Paradigm (HSP) to the Next.js/Astro/Vercel stack. It does not change HSP’s architectural decisions; it provides concrete practices for this stack using the canonical `apps/* + packages/*` layout.

## Layout

- `apps/ai-console` (Next.js 16, App Router)
  - Thin controllers (server actions/route handlers); orchestrate flows; delegate to `packages/<feature>/domain`.
  - Prefer Node runtime for heavy/AI tasks; reserve Edge runtime for read-mostly endpoints and low-latency fanout.
- `apps/api` (Node HTTP ports)
  - Hosts OpenAPI-defined routes; imports DTOs/contracts from `packages/*`.
- `apps/ai-gateway` (optional, Python)
  - Optional specialized gateway behind a stable HTTP port for AI/runtime workloads when needed; keep contracts unchanged for the modulith.
- `apps/web` (Astro)
  - Docs/marketing; can embed runtime status/read-only telemetry.
- `packages/<feature>.*`
  - `*.domain`: pure use cases; no framework imports; deterministic by default.
  - `*.adapters`: DB/HTTP/cache; implement ports; unit/integration tested.
  - `*.api`: interfaces, generated clients/servers from OpenAPI/JSON Schema when applicable.
  - `*.tests`: unit, contract (Pact), and Schemathesis-driven negative tests.

## Contracts

- Contract-first for published HTTP APIs: maintain OpenAPI/JSON Schema in `packages/<feature>.api`.
- CI gates: run Pact consumer/provider tests and Schemathesis fuzz/negative tests; block merges on failures unless explicitly waived per governance.

## Observability

- Use OpenTelemetry SDK for traces/logs/metrics across apps and packages.
- Propagate W3C trace context (traceparent) through server actions/route handlers.
- Link traces to PRs/builds via custom PR annotations in CI (see Tooling Integration) and expose trace IDs in PR comments for reviewers.

## Runtime Guidance

- Server Actions:
  - Keep controllers thin; avoid embedding domain logic.
  - Validate inputs at boundaries; return typed DTOs from packages.
- Caching:
  - Default dynamic reads to `no-store` unless proven safe via tests and monitoring.
  - For route handlers, assume GET handlers are uncached by default in modern Next.js; opt in to caching explicitly with stable keys/TTL.
  - Note: Next.js 16 changed caching semantics — GET route handlers are uncached by default; do not rely on implicit caches for correctness.
  - Use explicit, stable keys; avoid implicit cache coupling across features.
- Scheduling/Background:
  - Offload heavy work to background jobs (e.g., Next.js `next/after` or platform scheduler) guarded by feature flags.
- Edge vs Node:
  - Prefer Node for compute-heavy or stateful interactions; Edge for read-mostly, latency-sensitive endpoints.
 - Partial Prerendering (PPR):
  - Opt in selectively for pages with well-defined dynamic "holes"; keep critical correctness paths server-rendered and deterministic.

## Flags and Rollouts

- Manage feature flags in `platform/runtime`; guard new paths and risky adapters.
- Default flags off; fail-closed on resolution errors.
- Progressive rollout: internal → small percentage → full; clean up flags post-stabilization.
- Provider integration: use a lightweight provider (e.g., Vercel Edge Config via an adapter) for server-side evaluation; evaluate flags at the server boundary and pass decisions inward.
  - Default new flags OFF; under resolution failure, use deterministic safe defaults (fail‑closed). Record flag decisions and changes for auditability.

## CI/CD & KP Correlation

- PR annotation via custom GitHub Action posts `{build_id, pr_number, trace_context, commit_sha}` to PR and `POST /kp/correlation`.
- KP stores PR↔PipelineRun↔BuildArtifact↔Deployment↔Trace relationships and a `pr_correlation` materialized view keyed by PR number.

## Example Dependency Boundaries

- `apps/*` → may depend on `packages/<feature>/api` and `packages/<feature>/domain` (via interfaces); never the reverse.
- `packages/<feature>/adapters` depend inward on `packages/<feature>/domain` only.
- `packages/common/*` are dependency-light and reviewed to avoid accidental coupling.

## Testing Strategy

- Domain: deterministic, fast unit tests; property-based where useful.
- Adapters: integration tests with containers/emulators; contract tests for HTTP providers/consumers.
- API: Schemathesis for fuzz/negative; snapshot OpenAPI diffs in PRs.

## Deployment

- Vercel previews on every PR for `apps/*`.
- Manual promote to production after preview verification; rehearse instant rollback regularly.
- Keep deploy and release decoupled via feature flags; treat promote/rollback as operational runbooks.

## Notes

- Profile-specific details are advisory and can evolve; HSP pillars and decisions remain authoritative.
