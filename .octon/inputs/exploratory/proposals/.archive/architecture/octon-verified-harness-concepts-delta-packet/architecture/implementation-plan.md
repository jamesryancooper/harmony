# Consolidated implementation plan

## Ranking

### By leverage
1. Slice-to-stage binding refinement for mission-bound runs
2. Evaluator calibration by disagreement distillation
3. Proposal-packet-backed expansion of terse objectives (already covered; no change)

### By implementation readiness
1. Evaluator calibration by disagreement distillation
2. Slice-to-stage binding refinement for mission-bound runs
3. Proposal-packet-backed expansion of terse objectives

### By governance risk
1. Proposal-packet-backed expansion of terse objectives (already covered)
2. Evaluator calibration by disagreement distillation
3. Slice-to-stage binding refinement for mission-bound runs

## Immediate backlog

### Workstream A — evaluator disagreement distillation
1. Extend the generic distillation-bundle schema with disagreement/calibration optional fields.
2. Extend the failure-distillation workflow overlay to define evaluator disagreement inputs and required artifacts.
3. Add a deterministic authoring script for disagreement bundle generation.
4. Add a validator for disagreement bundles and wire it into architecture conformance.
5. Produce one real retained disagreement bundle from existing evaluator evidence and review dispositions.

### Workstream B — stage-to-slice binding
1. Extend `stage-attempt-v2` with an explicit action-slice binding field for mission-bound runs.
2. Extend `validate-mission-runtime-contracts.sh` so a mission-bound stage attempt without an action slice fails closed.
3. Extend `test-mission-autonomy-scenarios.sh` with one scenario that proves stage-attempt → action-slice binding.
4. Backfill any mission-bound retained run bundles affected by the new field.
5. Emit retained binding receipts for those backfilled runs.

## No-change confirmation item

### Workstream C — proposal-backed objective expansion
1. Reconfirm that the existing proposal packet lineage, mission-classification control record, mission-autonomy policy, and run-contract proposal refs remain sufficient.
2. Do not create a specialized mission-plan-draft authority family.
3. Record this as `already_covered` in closure evidence rather than converting it into unnecessary changes.

## Preferred Change Path by concept

| Concept | Preferred Change Path | Why narrower alternatives are insufficient | Why broader alternatives are unnecessary |
|---|---|---|---|
| Evaluator calibration by disagreement distillation | Extend current distillation + evaluator proof plane | Evidence-only without repeatable disagreement bundles would remain ad hoc and non-reusable | A new top-level calibration subsystem would duplicate existing proof/evidence surfaces |
| Slice-to-stage binding refinement | Extend stage-attempt schema and existing mission runtime validators | Documentation-only references between stage attempts and action slices would be pseudo-coverage | A new mission-slice run-contract family would duplicate existing run contract and action-slice surfaces |
| Proposal-backed objective expansion | No change | A new “mission-plan-draft” family would add ceremony without additional control strength | Broader redesign is unnecessary because fail-closed proposal gating already exists |

## Proposal-first vs direct backlog

- **Proposal-first:** both adapted concepts, because they touch either constitutional/runtime contracts or consequential execution validation.
- **Direct backlog:** none.
- **Already covered / no change:** proposal-packet-backed expansion of terse objectives.
