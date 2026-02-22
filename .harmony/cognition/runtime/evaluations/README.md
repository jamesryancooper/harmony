# Runtime Evaluations

Canonical runtime surface for periodic scorecard evaluations and follow-up actions.

## Purpose

- Store periodic evaluation digests generated from the scorecard contract.
- Keep weekly trend snapshots discoverable and auditable from runtime.
- Link action items to evidence references without mutating core score definitions.

## Canonical Index

- `index.yml` - machine-readable index of evaluation artifacts.

## Subsurfaces

- `digests/` - weekly scorecard digest artifacts and digest discovery index.
- `actions/` - remediation action ledger artifacts and action discovery index.

## Source Contract

- Scorecard contract: `/.harmony/cognition/runtime/context/metrics-scorecard.md`
