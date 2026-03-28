# Constitutional Retention Contracts

`/.octon/framework/constitution/contracts/retention/**` defines the active
retention, replay, and externalized-evidence lifecycle model for governed
execution.

## Status

The retention family is active.

- run continuity remains mutable under `/.octon/state/continuity/runs/**`
- retained run and control evidence remain append-oriented under:
  `/.octon/state/evidence/{runs/**,control/execution/**}`
- replay-heavy or externally retained immutable payloads are indexed under:
  `/.octon/state/evidence/external-index/**`

## Storage Classes

- `git-inline`: retained directly under canonical in-repo evidence roots
- `pointered`: canonical run evidence stores a stable in-repo pointer to
  another retained artifact family
- `external-immutable`: canonical run evidence stores a content-addressed
  pointer to an immutable payload outside the Git tree, with the lookup index
  retained under `state/evidence/external-index/**`

## Canonical Files

- `family.yml`
- `external-replay-index-v1.schema.json`
- `replay-storage-class-v1.schema.json`
