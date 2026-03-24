# ADR 063: Mission-Scoped Reversible Autonomy Atomic Cutover

- Date: 2026-03-23
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/mission-scoped-reversible-autonomy/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-23-mission-scoped-reversible-autonomy-cutover/plan.md`
  - `/.octon/state/evidence/migration/2026-03-23-mission-scoped-reversible-autonomy-cutover/`

## Context

Octon's execution governance already enforced intent binding, ACP stage/promote
control, retained run evidence, and fail-closed execution policy. What it did
not yet have as one live operating model was a durable mission charter rich
enough for standing delegation, a canonical mission control tree, retained
control-plane receipts, generated mission/operator summaries, or a fail-closed
runtime contract requiring mission autonomy context for autonomous workflow
execution.

## Decision

Promote Mission-Scoped Reversible Autonomy as one pre-1.0 atomic cutover.

Rules:

1. Long-running and always-running autonomy is governed by mission authority
   under `instance/orchestration/missions/**`.
2. Mission control truth lives under
   `state/control/execution/missions/<mission-id>/**`.
3. Retained control-plane mutation evidence lives under
   `state/evidence/control/execution/**`.
4. Generated mission/operator views live under
   `generated/cognition/summaries/{missions,operators}/**` and are never
   authoritative.
5. Autonomous workflow execution must provide mission autonomy context and may
   not silently fall back to mission-less operation.
6. Global execution budgets and exception leases remain authoritative and stay
   distinct from per-mission autonomy burn and breaker state.
7. The cutover ships with dedicated mission-autonomy validators, alignment
   profile wiring, CI coverage, ADR lineage, and a retained migration evidence
   bundle.

## Consequences

### Benefits

- Long-running autonomy now has one explicit repo-native authority/control/
  evidence/read-model split.
- Autonomous workflow execution fails closed when mission context or mission
  control surfaces are missing.
- Operators gain generated mission `now / next / recent / recover` views and
  routed operator digests without introducing a second control plane.
- Mission authority, control truth, and validation now evolve together under
  one atomic contract.

### Costs

- Runtime request/receipt structs, pipeline execution, cognition generation,
  assurance scripts, and mission scaffolding all changed together.
- Mission workflow guidance now requires seeded control and continuity state,
  not just `mission.yml` and `mission.md`.
- Validation surface area increased with dedicated mission-autonomy gates.

### Follow-on Work

1. Integrate the new mission control helper scripts into higher-level operator
   and client entrypoints so mission seeding and closure no longer rely on
   manual script invocation.
2. Extend generated mission/operator views from the current summary baseline to
   richer read models once live missions exist in this repository.
