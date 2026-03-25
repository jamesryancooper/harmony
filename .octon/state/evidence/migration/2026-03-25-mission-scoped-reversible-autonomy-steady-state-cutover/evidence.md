# Mission-Scoped Reversible Autonomy Steady-State Cutover Evidence (2026-03-25)

## Scope

Atomic closeout of the remaining Mission-Scoped Reversible Autonomy cutover
gaps after ADR 064:

- release/version parity hardened at `0.6.1`
- durable migration and ADR records added for the steady-state closeout
- mission control/control-evidence coverage expanded
- `create-mission` upgraded from overview-only to a mutating staged workflow
  contract
- live mission projection switched to `mission-view.yml`
- architecture-conformance CI expanded to the full mission validator stack

## Cutover Assertions

- The repo now has one enforced version story: `version.txt` and
  `/.octon/octon.yml` agree at `0.6.1`.
- The live validation mission demonstrates a slice-linked intent,
  non-null route linkage, generated mission summaries, operator digest, and
  machine-readable `mission-view.yml`.
- Retained control evidence now includes the required mutation-class coverage
  receipts for directives, authorize-updates, schedule mutations, budget
  transitions, breaker transitions, safing transitions, break-glass
  transitions, and finalize block/unblock.
- The `create-mission` workflow contract now declares mutating stages for
  validation, authority scaffold, control/generation seed, and reporting.

## Receipts And Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/066-mission-scoped-reversible-autonomy-steady-state-cutover.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/mission-scoped-reversible-autonomy-steady-state-cutover/plan.md`
- Prior completion-cutover ADR:
  `/.octon/instance/cognition/decisions/064-mission-scoped-reversible-autonomy-completion-cutover.md`
