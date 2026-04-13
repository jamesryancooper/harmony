# Validation strategy

## 1. Structural validation

- Validate updated JSON/YAML contracts and overlays against existing schema families.
- Validate that all new evidence bundles contain the required artifacts declared in the relevant workflow contract.
- Validate packet metadata and promotion target coherence.

## 2. Runtime / control validation

### Evaluator calibration
- Run the new disagreement bundle authoring script against an existing evaluator evidence set.
- Confirm that the resulting bundle references real evaluator outputs, review findings, and review dispositions.
- Confirm that no control artifact is created as a side effect.

### Slice-to-stage binding
- Run mission runtime contract validation on a mission-bound retained run bundle with explicit action-slice bindings.
- Confirm fail-closed behavior when `action_slice_ref` is missing.
- Confirm pass behavior when bindings resolve to declared mission action slices.

## 3. Assurance validation

- Extend existing architecture-conformance workflow to include the disagreement-bundle validator.
- Extend mission autonomy scenario coverage to exercise stage-to-slice binding.
- Require two consecutive clean passes with no new blockers.

## 4. Evidence retention

### Must retain
- disagreement bundle
- disagreement bundle validation receipt
- stage-action-slice binding receipt
- updated scenario results
- promotion/closure evidence

### Must not be treated as truth
- generated distillation summaries
- proposal packet artifacts
- chat transcripts or informal comments

## 5. Generated output validation

- Generated distillation summaries must be reproducible from retained evidence and must declare themselves non-authoritative.
- No generated output may become a runtime dependency.

## 6. Operator/runtime usability validation

### Evaluator calibration
- A maintainer can inspect one disagreement bundle and understand:
  - what the evaluator said,
  - what canonical finding/disposition was recorded,
  - what calibration candidate is being proposed,
  - and why that proposal is still non-authoritative until separately promoted.

### Slice-to-stage binding
- A maintainer can inspect one mission-bound run and determine, from run control + mission control alone, exactly which action slice each stage attempt was executing against.
