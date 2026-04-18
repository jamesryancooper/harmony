# Execution Constitution Conformance Card

| Constraint | Status | Notes |
|---|---|---|
| Proposal remains non-authoritative | pass | packet stays under `inputs/exploratory/proposals/**` only |
| No new top-level root introduced | pass | all promotion targets remain inside existing `framework/**` and `instance/**` families |
| No support-target widening | pass | the packet tightens workflow semantics; it does not widen the admitted support universe |
| GitHub remains a host merge gate, not a new repo-local authority layer | pass | helper scripts and docs continue to defer final mergeability to GitHub rulesets/checks |
| Workflow is not Codex-app-specific | pass | packet defines behavior in Git/worktree/GitHub terms and requires plain Git lane validation |
| Hidden authority widening is avoided | pass | new machine-readable workflow contract narrows drift rather than adding host-side authority |
| Evidence-backed closure is required | pass | validation plan and closure plan require retained proof before packet closeout |
