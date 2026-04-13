# Coverage traceability matrix

| Source claim / concept | Extraction output | Verification output | Live repo evidence | Packet-time judgment | Proposed change / no-change proof |
|---|---|---|---|---|---|
| Separate evaluator from producer and learn from disagreement | Split across evaluator lane + rubric items | Refined into evaluator calibration by disagreement distillation | evaluator proof plane, review findings/dispositions, failure-distillation workflow, retained bundle | Partially covered | Extend distillation bundle/workflow + add disagreement authoring and validation |
| Bridge high-level mission intent to bounded executable slices | Overstated as new mission-slice run contract family | Corrected to slice-to-stage binding refinement | mission action-slices, mission classification, stage-attempt schema/example | Partially covered | Add explicit `action_slice_ref` to stage attempts + backfill + validator |
| Keep planner output exploratory and promote via canonical control refs | Planner-draft adaptation | Proposal-packet-backed objective expansion | mission-autonomy fail-closed defaults, mission-classification schema, run-contract-v3 proposal refs, proposal packet lineage | Fully covered | No change; record sufficiency |
