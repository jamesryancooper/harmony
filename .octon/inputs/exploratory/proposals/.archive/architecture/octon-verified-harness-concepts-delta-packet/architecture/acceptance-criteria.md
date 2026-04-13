# Acceptance criteria

## Concept-level acceptance

### 1. Evaluator calibration by disagreement distillation
Accepted only when all of the following are true:

1. The generic distillation bundle contract can represent evaluator disagreement and calibration candidate data without inventing a new top-level family.
2. The failure-distillation workflow overlay names the required disagreement artifacts and source roots.
3. A deterministic authoring path exists for producing disagreement bundles.
4. CI validates disagreement bundles fail-closed.
5. At least one real retained disagreement bundle exists and links:
   - evaluator evidence,
   - canonical review finding(s),
   - canonical review disposition(s),
   - and a proposed calibration candidate.
6. Any generated summary remains explicitly non-authoritative.

### 2. Slice-to-stage binding refinement for mission-bound runs
Accepted only when all of the following are true:

1. Mission-bound stage attempts can carry an explicit `action_slice_ref` (or equivalent field).
2. The runtime contract validator fails closed when mission-bound stage attempts are missing that binding.
3. The mission autonomy scenario suite includes at least one passing stage-to-slice binding scenario.
4. Any affected retained mission-bound run bundles have been backfilled.
5. A retained binding receipt exists for each backfilled run.
6. No new mission-slice contract family is introduced.

### 3. Proposal-packet-backed expansion of terse objectives
Accepted as already covered only when all of the following remain true:

1. Proposal packets remain non-authoritative lineage under `inputs/exploratory/proposals/**`.
2. Mission classification records retain `proposal_requirement` and `proposal_refs`.
3. The mission autonomy policy retains fail-closed behavior when proposals are required and absent.
4. Run-contract-v3 retains proposal-ref support.
5. No runtime or policy consumer reads proposal-local paths directly as authority.

## Packet-level acceptance

The packet is ready for implementation review only when:
- every in-scope concept has one coverage status and one final repository disposition;
- every adapted concept has a concrete authoritative/control/evidence/enforcement path;
- every no-change concept has a concrete rationale for already-covered status;
- every proposed promotion target is outside the proposal tree;
- no recommendation creates shadow authority or docs-only pseudo-coverage.
