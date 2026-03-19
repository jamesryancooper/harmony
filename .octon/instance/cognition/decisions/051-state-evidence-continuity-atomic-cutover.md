# ADR 051: State, Evidence, And Continuity Atomic Cutover

- Date: 2026-03-19
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/architecture/7-state-evidence-continuity/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-19-state-evidence-continuity-cutover/plan.md`
  - `/.octon/framework/cognition/_meta/architecture/specification.md`

## Context

Packet 7 formalizes `state/**` as one class-rooted operational surface, but the
live repository still had partial drift:

1. repo continuity, retained evidence, and control-state files already lived
   under `state/**`,
2. scope continuity was still treated as gated or future-only in active docs
   and validators,
3. continuity architecture docs still described decisions and runs as if they
   were continuity child surfaces rather than retained evidence siblings,
4. the harness gate did not yet enforce the full Packet 7 repo/scope
   continuity, evidence, and control-state contract.

That left one remaining state-class risk: the live tree and the live docs
partially matched Packet 7, but the operational contract could still drift by
convention rather than by one enforced, fail-closed model.

## Decision

Promote Packet 7 as one atomic clean-break cutover.

Rules:

1. Packet 7 lands as a single promotion event.
2. After cutover, active continuity lives only under
   `/.octon/state/continuity/**`.
3. After cutover, retained operational evidence lives only under
   `/.octon/state/evidence/**`.
4. After cutover, mutable publication and quarantine truth lives under
   `/.octon/state/control/**`.
5. After cutover, scope continuity is legal only for declared, non-quarantined
   scopes and is bootstrapped immediately for the live `octon-harness` scope.
6. No compatibility shims, fallback continuity roots, or dual old/new state
   semantics are allowed after promotion.
7. Rollback is full-revert-only for the cutover change set.
8. If Packet 7 validation cannot converge to one class-rooted state contract,
   promotion is blocked and the harness fails closed.

## Consequences

### Benefits

- Deterministic separation between active continuity, retained evidence, and
  mutable control truth.
- Scope continuity becomes a real, validator-enforced surface instead of a
  future placeholder.
- Runtime-vs-ops mutation policy and harness gates now align to the same
  class-rooted state boundary.

### Costs

- Large one-shot sweep across docs, validators, templates, state scaffolds,
  migration records, and publication receipts.
- Reduced flexibility for partial rollback or transitional wording.

### Follow-on Work

1. Packet 8 can rely on the desired/actual/quarantine/compiled extension split
   without re-litigating state placement.
2. Packet 11 can consume the final continuity/evidence/ADR routing model
   without carrying Packet 7 caveats.
3. Packet 14 can treat scope continuity, evidence placement, and control-state
   publication as first-class fail-closed rules.
