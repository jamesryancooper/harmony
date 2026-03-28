# ADR 075: Execution Constitution Completion Closeout

- Date: 2026-03-28
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-28-execution-constitution-completion-closeout/plan.md`
  - `/.octon/state/evidence/migration/2026-03-28-execution-constitution-completion-closeout/`
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/execution-constitution-completion-closeout/`
  - `/.octon/instance/cognition/decisions/074-wave6-retirement-cutover.md`

## Context

The repo had durable constitutional execution surfaces in place, but the final
completion proposal still remained active and under-reported its lifecycle
state. In particular:

- the proposal package still lived under the active proposal path
- its manifest still said `status: "draft"`
- the repo needed proposal-specific retained promotion evidence proving that
  the closeout landed in durable surfaces outside the proposal workspace

Without that lifecycle transition, the implementation could be materially
complete while the repository still claimed the proposal had not exited draft.

## Decision

Archive `execution-constitution-completion-closeout` as `implemented` once the
durable constitutional, runtime, continuity, evidence, governance, lab, and
observability outputs are present and validated outside the proposal workspace.

Rules:

1. The proposal package must move to the canonical archive path under
   `/.octon/inputs/exploratory/proposals/.archive/architecture/`.
2. `proposal.yml` must record `archived_from_status: implemented`,
   `disposition: implemented`, and non-empty `promotion_evidence`.
3. `/.octon/generated/proposals/registry.yml` must be regenerated so the
   proposal appears only in the archived projection.
4. Durable closeout evidence must remain outside the proposal path under
   cognition and migration evidence roots.

## Consequences

### Benefits

- The repository’s proposal lifecycle now matches the durable implementation
  state.
- Completion claims rely on canonical runtime, evidence, and governance
  surfaces rather than an active proposal packet.
- Operators can discover the proposal as historical lineage only.

### Costs

- Historical references to the active proposal path become stale and must move
  to archive-path lineage where retained.
- Proposal archive and registry updates must move in lockstep with the
  evidence bundle.

## Completion

This proposal is complete for repository lifecycle purposes once:

- the package is archived as implemented
- the registry projects only the archived state
- the completion evidence bundle validates the durable closeout surfaces
  without proposal-path dependencies
