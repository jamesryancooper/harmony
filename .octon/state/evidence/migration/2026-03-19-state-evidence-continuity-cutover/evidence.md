# State, Evidence, And Continuity Cutover Evidence (2026-03-19)

## Scope

Single-promotion atomic migration implementing Packet 7
`state-evidence-continuity`:

- ratify `state/**` as one class-rooted operational surface with continuity,
  evidence, and control subdomains
- bootstrap scope continuity for the live `octon-harness` scope
- separate active continuity from retained evidence in active docs and
  validators
- add Packet 7 control-state schema contracts
- align mutation policy, publication checks, scaffolding, and migration
  records to the final Packet 7 model

## Cutover Assertions

- `state/continuity/**` is now the only canonical continuity surface.
- `state/evidence/**` is now the only canonical retained operational evidence
  surface.
- `state/control/**` is now the canonical mutable control-truth surface.
- Scope continuity is live and validator-enforced for the declared
  `octon-harness` scope.
- Runtime-vs-ops mutation policy now allowlists governed writes to
  `state/continuity/**`, not just repo continuity.
- The harness alignment profile passes with Packet 7 continuity/evidence/control
  checks enabled.

## Receipts And Evidence

- Proposal:
  `/.octon/inputs/exploratory/proposals/architecture/state-evidence-continuity/`
- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-19-state-evidence-continuity-cutover/plan.md`
- ADR:
  `/.octon/instance/cognition/decisions/051-state-evidence-continuity-atomic-cutover.md`
