# Change Inventory

## Summary

- Added run continuity, retention, external replay indexing, governance
  overlays, and closeout validation so the durable execution closeout state is
  provable outside the proposal workspace.
- Added proposal-specific cognition and migration records proving that the
  implementation is complete and the proposal may exit active lifecycle use.
- Archived the proposal packet as implemented and refreshed the proposal
  registry projection.

## Major Change Groups

### Durable execution closeout surfaces

- `framework/constitution/contracts/{runtime,retention,disclosure}/**`
- `framework/engine/runtime/{config,crates}/**`
- `framework/orchestration/runtime/{_ops,runs}/**`
- `instance/governance/contracts/**`
- `state/{continuity,evidence,control}/**`

### Completion evidence and cognition receipts

- `instance/cognition/decisions/{index.yml,075-execution-constitution-completion-closeout.md}`
- `instance/cognition/context/shared/migrations/{index.yml,2026-03-28-execution-constitution-completion-closeout/**}`
- `state/evidence/migration/2026-03-28-execution-constitution-completion-closeout/**`

### Proposal lifecycle transition

- `inputs/exploratory/proposals/.archive/architecture/execution-constitution-completion-closeout/**`
- `generated/proposals/registry.yml`
