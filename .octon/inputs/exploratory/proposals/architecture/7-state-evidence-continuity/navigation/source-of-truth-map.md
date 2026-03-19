# Source Of Truth Map

## Canonical Authority

| Concern | Source of truth | Notes |
| --- | --- | --- |
| State class semantics and placement after promotion | `.octon/README.md` and `.octon/framework/cognition/_meta/architecture/specification.md` | `state/**` is authoritative only for operational truth, retained evidence, and mutable control state |
| Repo-wide active continuity | `.octon/state/continuity/repo/{log.md,tasks.json,entities.json,next.md}` | Canonical repo continuity home for repo-wide and cross-scope active work |
| Scope identity and scope validity | `.octon/instance/locality/{manifest.yml,registry.yml,scopes/<scope-id>/scope.yml}` | Scope continuity depends on locality authority; `state/**` does not author scope identity |
| Scope-bound active continuity | `.octon/state/continuity/scopes/<scope-id>/**` | Legal only for declared, valid scopes after locality validation and publication are live |
| Retained run evidence | `.octon/state/evidence/runs/**` | Append-oriented operational receipts, digests, and execution trace artifacts |
| Retained operational decision evidence | `.octon/state/evidence/decisions/{repo,scopes/<scope-id>}/**` | Operational allow/block/escalate evidence; not an ADR surface |
| Retained validation evidence | `.octon/state/evidence/validation/**` | Validation receipts and enforcement evidence that must survive regeneration |
| Retained migration evidence | `.octon/state/evidence/migration/**` | Migration receipts, provenance, and rollback traceability artifacts |
| Desired extension configuration | `.octon/instance/extensions.yml` | Human-authored desired configuration; not actual active state |
| Actual extension activation state | `.octon/state/control/extensions/active.yml` | Current validated published extension set and generated publication references |
| Extension quarantine and withdrawal state | `.octon/state/control/extensions/quarantine.yml` | Mutable control truth for blocked packs, affected dependents, and reason codes |
| Locality quarantine state | `.octon/state/control/locality/quarantine.yml` | Mutable control truth for quarantined scopes and locality failures |
| Durable context, memory policy, and ADR authority | `.octon/framework/agency/governance/MEMORY.md`, `.octon/instance/cognition/context/**`, and `.octon/instance/cognition/decisions/**` | Memory remains routing, not a directory; durable context and ADRs stay outside `state/**` |
| Runtime-versus-ops mutation boundary | `.octon/framework/cognition/_meta/architecture/runtime-vs-ops-contract.md` | Declares fail-closed mutation rules for governed automation targeting `state/**` and `generated/**` |

## Derived Or Enforced Projections

| Concern | Derived path or enforcement surface | Notes |
| --- | --- | --- |
| Runtime-facing compiled extension behavior | `.octon/generated/effective/extensions/**` | Rebuildable effective view referenced by `state/control/extensions/active.yml`; publication must remain atomic |
| Runtime-facing compiled locality behavior | `.octon/generated/effective/locality/**` | Rebuildable effective view used by locality consumers and scope-validation workflows |
| Continuity schema and lifecycle contracts | `.octon/framework/cognition/_meta/architecture/state/continuity/**` | Canonical schema family and lifecycle guidance for continuity artifacts and related state docs |
| Fail-closed validation for state placement and shape | `.octon/framework/assurance/runtime/**` | Validators reject malformed continuity, invalid evidence placement, stale generated locks, and out-of-policy writes |
| Working-state resets and migration workflows | `.octon/framework/orchestration/runtime/workflows/**` | Reset and migration procedures must treat continuity, evidence, and control state differently |
| Proposal discovery for this temporary package | `.octon/generated/proposals/registry.yml` | Derived non-authoritative registry entry for proposal discovery while this package is active |

## Boundary Rules

- `state/**` is authoritative only for operational truth, retained evidence,
  and mutable control state.
- `instance/**` remains the authoritative home for durable repo-owned context,
  ADRs, locality authority, and desired extension configuration.
- `generated/**` remains rebuildable and non-authoritative even when committed
  by default.
- Detailed active work state has one primary home: repo continuity for
  repo-wide or cross-scope work, scope continuity for stable single-scope
  work.
- Scope continuity is invalid for undeclared, invalid, or quarantined
  `scope_id` values.
- Evidence is append-oriented and retention-governed; it is not reset by
  ordinary working-state cleanup or by generated regeneration.
- `instance/extensions.yml` remains desired configuration, while
  `state/control/extensions/{active,quarantine}.yml` records actual mutable
  operational truth.
- Additional domain-specific `state/control/**` records may exist when ratified
  by their owning domain contracts, but this proposal standardizes the
  extension and locality control surfaces required by the super-root
  blueprint.
