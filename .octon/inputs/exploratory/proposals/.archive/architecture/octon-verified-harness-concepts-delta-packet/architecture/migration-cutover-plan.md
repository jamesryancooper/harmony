# Migration / cutover plan

## Posture

No big-bang migration is justified.

The correct packet-time posture is **additive schema/workflow refinement plus targeted backfill**.

## Why no big-bang cutover is correct

- Current live repo already has the relevant families in place.
- Both adapted concepts are refinements of existing surfaces.
- The already-covered concept needs no migration at all.
- A broad cutover would create unnecessary change risk without increasing usable capability.

## Additive migration plan

### A. Evaluator calibration by disagreement distillation
1. Promote schema/workflow/script/validator changes first.
2. Generate one retained disagreement bundle from existing evaluator evidence.
3. Wire CI gating after the bundle format and validator are proven locally.
4. Keep generated summaries non-authoritative throughout.

### B. Slice-to-stage binding refinement
1. Promote `stage-attempt-v2` field extension first.
2. Update mission runtime validator and scenario suite.
3. Backfill only mission-bound retained run bundles.
4. Emit one retained binding receipt per backfilled run.
5. Only then enable fail-closed CI validation for the new requirement.

## Rollback posture

### Evaluator disagreement distillation
- Safe to roll back by reverting the new schema fields, scripts, and validator wiring.
- Preserve all retained evidence bundles during rollback.

### Slice-to-stage binding
- Roll back by reverting the schema/validator change and removing only the new field requirement.
- Preserve backfilled stage-attempt files and receipts as historical evidence, even if validation is relaxed temporarily.
