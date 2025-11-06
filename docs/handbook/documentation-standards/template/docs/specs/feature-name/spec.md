---
feature: {{feature-name}}
author: <owner>
flag: flag.{{feature-name}}
slo_targets:
  api_availability: 99.9%
  api_p95_ms: 300
  ttfb_p95_ms: 400
  error_rate_pct: 0.5
contracts:
  openapi: packages/contracts/openapi.yaml
  schemas:
    - packages/contracts/schemas/{{feature-name}}.schema.json
rollout:
  audience: internal
  rollback: vercel promote <preview-url>
---

# {{feature-name}} — Specification One-Pager

## Problem & Intended Outcome

<One paragraph: who is affected, why now, and the observable metric of success.>

## Scope

- **Must**: <bullets of concrete outcomes>
- **Defer**: <explicitly out-of-scope items for this cut>

## Interfaces & Contracts

- **API**: see OpenAPI in `packages/contracts/openapi.yaml` (paths under `/v1/{{feature-name}}`).
- **Schemas**: see JSON Schema in `packages/contracts/schemas/{{feature-name}}.schema.json`.
- **UI contracts** (if applicable): <link to wireframes or state contracts>.

## Non-Functionals (Budgets)

- **Performance**: p95 <= 300ms; bundle <= 250KB
- **Reliability**: 99.9% availability, error-rate <0.5%
- **Privacy/Safety**: <data class, PII handling, logging redaction>

## Architecture (Sketch)

Ports & adapters; boundaries; where contracts freeze edges.

```mermaid
flowchart LR
UI[UI] --> API[HTTP API /v1/{{feature-name}}]
API --> SVC[Domain Service]
SVC --> ADAPT[(Adapters: DB/Upstreams)]
```

## Risks (STRIDE) & Mitigations

- Spoofing: <mitigation + test>
- Tampering: <mitigation + test>
- Repudiation: <mitigation + test>
- Information disclosure: <mitigation + test>
- Denial of service: <mitigation + test>
- Elevation of privilege: <mitigation + test>

## Flags & Rollout

- Feature flag: `flag.{{feature-name}}` (default **off**)
- Initial audience: <internal/canary>, rollout steps, rollback path.

## Acceptance in Preview

- <behavior 1>
- <behavior 2>

## Decisions & ADR Link

- Decision summary → [ADR-0001: Initial approach](./adr-0001.md)
- Consequences/Tradeoffs: <bullets>
