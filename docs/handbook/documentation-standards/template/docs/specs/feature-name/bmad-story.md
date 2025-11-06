# {{feature-name}} — BMAD Story (Execution Plan)

## Context Packets

- Domain notes, glossary, examples (include sample payloads)
- Constraints: compliance, latency budgets, limits
- Links: [spec.md](./spec.md), ADRs, contracts, runbooks

## Agent Plan (tiny diffs)

1. **Contracts first**: author OpenAPI + JSON Schema; add stub handlers and contract tests.
2. **Adapters & service**: implement adapters and domain service logic.
3. **Routing/wiring**: expose `/v1/{{feature-name}}` routes; guard with `flag.{{feature-name}}`.
4. **Preview smoke**: deploy PR preview and validate acceptance.

## Acceptance Criteria (Observable)

- Given/When/Then tied to contracts and flags.
- Negative cases derived from STRIDE (authZ, rate limiting, idempotency).

## Contracts (Source of Truth)

- OpenAPI: `packages/contracts/openapi.yaml` (component `ExampleFeature`).
- JSON Schema: `packages/contracts/schemas/{{feature-name}}.schema.json`.
- Optional Pact tests if there is a consumer/provider.

## Test Plan

- Unit tests near logic.
- Contract tests at boundaries (API/UI).
- E2E smoke on preview for core flows.
- Golden tests for AI output (if applicable) guarded by JSON Schema.

## Rollout & Observability

- Flag: `flag.{{feature-name}}`; audience: internal → % ramp.
- Monitors: SLOs, burn-rate, dashboards/traces.

## Definition of Done (Gates)

- Lint, typecheck, unit, **contract diff**, static analysis, dependencies & license, secret scan, SBOM, perf/bundle budgets are green.
- Preview smoke passes; docs updated; feature remains behind flag until rollout conditions are met.

## Notes for Cursor (optional prompt)

```plaintext
Given the Spec and BMAD Story above, propose a minimal file-by-file diff with tests and contracts.
Highlight security/privacy/licensing concerns. Avoid new deps unless justified.
Propose negative tests from STRIDE and summarize risks + rollback plan.
```
