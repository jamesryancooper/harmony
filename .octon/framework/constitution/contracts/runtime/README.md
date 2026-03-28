# Constitutional Runtime Contracts

`/.octon/framework/constitution/contracts/runtime/**` defines the
constitutional run-lifecycle model for governed execution.

## Status

Run roots are the primary execution-time unit of truth.

- canonical runtime state lives under:
  `/.octon/state/control/execution/runs/<run-id>/runtime-state.yml`
- canonical resumability and handoff continuity live under:
  `/.octon/state/continuity/runs/<run-id>/handoff.yml`
- canonical rollback and contamination posture lives under:
  `/.octon/state/control/execution/runs/<run-id>/rollback-posture.yml`
- canonical control checkpoints live under:
  `/.octon/state/control/execution/runs/<run-id>/checkpoints/**`
- canonical retained run receipts live under:
  `/.octon/state/evidence/runs/<run-id>/receipts/**`
- canonical retained run assurance reports, measurements, interventions, and
  disclosure outputs live under:
  `/.octon/state/evidence/runs/<run-id>/{assurance/**,measurements/**,interventions/**,disclosure/**}`
- canonical replay and trace pointers live under:
  `/.octon/state/evidence/runs/<run-id>/{replay-pointers.yml,trace-pointers.yml}`

## Final Rules

- Mission remains the continuity and long-horizon autonomy container.
- Run continuity is first-class operational state and remains distinct from
  retained run evidence.
- Consequential stages must bind the run control and evidence roots before
  side effects occur.
- Mission continuity, summaries, and mission views may consume run evidence,
  but they may not replace the run root as the execution-time source of truth.

## Canonical Files

- `family.yml`
- `runtime-state-v1.schema.json`
- `run-continuity-v1.schema.json`
- `rollback-posture-v1.schema.json`
- `checkpoint-v1.schema.json`
- `replay-pointers-v1.schema.json`
