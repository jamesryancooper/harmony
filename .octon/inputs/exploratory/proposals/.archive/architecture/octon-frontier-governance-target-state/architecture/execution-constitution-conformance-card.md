# Execution Constitution Conformance Card

## Summary

This proposal conforms to Octon's constitutional intent if and only if it strengthens engine-owned authorization, fail-closed support claims, retained evidence, generated-output boundaries, and run-first execution. It must not become a new authority plane.

## Conformance table

| Constitutional / runtime obligation | Current source | Proposal effect | Required proof |
|---|---|---|---|
| `/.octon` is the single authoritative super-root | `.octon/README.md`, cognition umbrella spec | Preserved. New surfaces are placed under existing class roots. | Placement validator passes. |
| Only `framework/**` and `instance/**` are authored authority | `.octon/README.md` | Preserved. Proposal targets authority under these roots; state is control/evidence; generated is derived. | Source-of-truth map and path validators. |
| Raw `inputs/**` never participate directly in runtime/policy | `.octon/README.md`, cognition umbrella spec | Preserved. This packet is non-authoritative. | Durable targets contain no proposal-path dependencies. |
| Generated outputs are never source of truth | `.octon/README.md`, cognition umbrella spec | Strengthened with context-pack/generation freshness rules. | Generated authority ban validator. |
| Material execution passes through `authorize_execution` | `execution-authorization-v1.md` | Strengthened to include context pack, materiality, rollback, browser/API, egress. | Runtime path tests and receipts. |
| No side effect before grant | `execution-authorization-v1.md` | Preserved and broadened. | Side-effect denial tests. |
| Receipt emission mandatory | `execution-authorization-v1.md`, execution receipt schema | Strengthened with context/replay/rollback/browser/API references. | Receipt completeness validator. |
| Support claims bounded by support targets | support-targets surfaces | Strengthened; schema drift fixed first. | Support-target validation and HarnessCards. |
| Host UI/comments/checks are projections only | execution authorization, cognition umbrella | Preserved. Browser/UI records are evidence, not authority. | Host projection tests. |
| Missions are continuity; runs are atomic execution | `.octon/README.md`, runtime README | Preserved. Context packs and receipts bind to runs. | Mission/run lifecycle tests. |
| Long-running autonomy is mission-scoped and reversible | `.octon/README.md` | Strengthened with leases/directives/breakers/recovery drills. | Intervention/recovery evidence. |

## Required negative tests

- Generated cognition attempts to approve a run: must fail.
- Proposal path referenced by durable runtime target: must fail.
- Browser action without replay evidence: must fail.
- API action without egress lease: must fail.
- Unsupported tuple claim: must fail.
- Material action without context pack when required: must fail.
- Material action without rollback posture when materiality requires it: must fail.
- Team/specialist attempts to own run without accountable orchestrator: must fail.

## Conformance disposition

The proposal is constitution-conformant as an exploratory packet. It becomes implementable only after Phase 0 drift correction and remains non-authoritative until durable promotion targets are updated and validated.
