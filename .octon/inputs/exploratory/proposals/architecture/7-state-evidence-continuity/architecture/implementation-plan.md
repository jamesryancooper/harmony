# Implementation Plan

This proposal does not ask the repository to invent a new mutable surface.
Most of the Packet 7 target already exists under `state/**`. The remaining
work is to align contracts, validators, lifecycle rules, and migration
language so the repository stops carrying overlapping explanations of the same
stateful behavior.

## Workstream 1: Lock The State Class Contract

- Ratify `state/continuity/**`, `state/evidence/**`, and `state/control/**`
  as the required Packet 7 state subdomains in the durable architecture
  specification.
- Align `.octon/README.md`, `.octon/instance/bootstrap/START.md`, and the
  cognition architecture references so they describe the same state boundary.
- Clarify that `state/**` is authoritative only as operational truth and
  retained evidence, not as authored policy or durable design authority.

## Workstream 2: Normalize Continuity Placement And Sequencing

- Keep repo continuity anchored at `state/continuity/repo/**`.
- Define the canonical schema family and lifecycle rules for `log.md`,
  `tasks.json`, `entities.json`, and `next.md`.
- Preserve the one-primary-home rule so repo continuity and future scope
  continuity do not become duplicate ledgers.
- Keep scope continuity blocked until locality registry, effective locality
  outputs, and scope validation are canonical and fail closed.

## Workstream 3: Separate And Govern Evidence Classes

- Normalize run, decision, validation, and migration evidence under
  `state/evidence/**`.
- Align evidence retention docs and evidence-placement guidance so retained
  receipts are never treated as generated output.
- Update continuity-plane docs so evidence remains linked to continuity but is
  no longer described as an undifferentiated continuity appendage.
- Ensure migration and audit workflows emit receipts into the canonical
  evidence classes only.

## Workstream 4: Harden Control-State Publication

- Preserve `instance/extensions.yml` as the desired authored configuration
  surface.
- Keep `state/control/extensions/active.yml` and
  `generated/effective/extensions/**` in an atomic publication relationship.
- Preserve `state/control/extensions/quarantine.yml` and
  `state/control/locality/quarantine.yml` as mutable current-state truth for
  blocked publications.
- Ensure future domain-specific `state/control/**` surfaces obey the same
  operational-truth and fail-closed publication rules.

## Workstream 5: Align Validation, Mutation Policy, And Lifecycle Operations

- Extend the runtime-vs-ops mutation contract from repo-continuity special
  casing to the full class-rooted state model.
- Ensure validators reject malformed continuity, invalid evidence placement,
  stale active-state publication, and undeclared state write targets.
- Define explicit working-state reset behavior that may clear continuity and
  selected control state but not retained evidence.
- Define explicit retention and compaction workflows for evidence under
  `state/evidence/**`.

## Workstream 6: Promote Memory Routing And Scaffolding

- Update `.octon/instance/cognition/context/shared/memory-map.md` so memory
  routing names continuity, evidence, control state, durable context, and ADRs
  distinctly.
- Update continuity artifact guidance in
  `.octon/instance/cognition/context/shared/continuity.md`.
- Align continuity scaffolding and proposal-writing references with the final
  `state/**` placement contract.
- Keep durable context and ADR guidance outside `state/**` to preserve the
  authored-versus-operational split.

## Workstream 7: Finish Migration And Cutover

- Treat the current repository state as a partial Packet 7 migration rather
  than a clean slate.
- Move or normalize any remaining mixed-path continuity or evidence language
  before downstream packets consume the state model.
- Land repo continuity normalization before any scope continuity population.
- Remove special-case or compatibility wording only after the canonical state
  contract, validators, and generated publication references converge.

## Downstream Dependency Impact

This proposal is a prerequisite for:

- inputs/additive/extensions work that depends on desired versus actual versus
  quarantine versus compiled state
- memory and decision-surface work that must keep operational evidence
  separate from ADRs
- unified validation, fail-closed, quarantine, and staleness work that needs
  one coherent model for mutable operational truth
- migration and rollout work that must distinguish resettable continuity from
  retained evidence

## Exit Condition

This proposal is complete only when durable architecture docs, state
artifacts, control-state publication, reset/retention workflows, validators,
and scaffolding all converge on one class-rooted `state/**` model and no
mixed-path or continuity-plane wording can still be interpreted as an
alternate mutable authority surface.
