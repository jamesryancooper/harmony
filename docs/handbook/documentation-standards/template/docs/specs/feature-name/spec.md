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
    - packages/contracts/schemas/feature-name.schema.json
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
 - **Schemas**: see JSON Schema in `packages/contracts/schemas/feature-name.schema.json`.
- **UI contracts** (if applicable): <link to wireframes or state contracts>.

## I/O & Artifacts (if applicable)

- **Inputs**: <normalized records, events, payloads; stable IDs/provenance>
- **Outputs**: <responses, events>
- **Artifacts**: <files with `schema_version`, manifests/snapshots>

## Non-Functionals (Budgets)

- **Performance**: p95 <= 300ms; bundle <= 250KB
- **Reliability**: 99.9% availability, error-rate <0.5%
- **Privacy/Safety**: <data class, PII handling, logging redaction>

## Security & Compliance Mapping (ASVS/SSDF)

- ASVS controls (examples, replace with actual IDs): V2.x Input Validation; V4.x Access Control; V7.x Error Handling/Logging; V9.x Communication Security; V14.x Configuration.
- SSDF activities: Plan/Organize (PO) — threat model, SLO/SLA; Protect Software (PS) — SCA, secret mgmt; Produce Well-Secured Software (PW) — code review, static analysis, tests; Respond to Vulnerabilities (RV) — triage SOP, patch SLAs, SBOM updates.
- Evidence per PR: CodeQL/Semgrep results; dependency + license review; SBOM artifact path; OpenAPI diff (oasdiff) output; contract test results.

## Architecture (Sketch)

Ports & adapters; boundaries; where contracts freeze edges.

```mermaid
flowchart LR
UI[UI] --> API[HTTP API /v1/{{feature-name}}]
API --> SVC[Domain Service]
SVC --> ADAPT[(Adapters: DB/Upstreams)]
```

## Opinionated Choices (summary)

- Briefly note key frameworks/libs/backends/models and rationale. Keep details in the Component Guide and record consequential/org‑wide decisions as an ADR.
- ADR link: [ADR-0001](./adr-0001.md)

## Harmony Alignment

- Spec‑first, contract‑driven; contracts are enforced in CI.
- Auditability: reproducible artifacts/snapshots and drift checks where applicable.
- Security baseline: OWASP ASVS/NIST SSDF controls applied (see Non‑Functionals).
- Modular flow: tiny PRs, previews, feature flags; clear rollback.

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
