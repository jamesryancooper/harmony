# Harness Integrity Tightening Cutover Evidence (2026-03-22)

## Scope

Single-promotion atomic migration implementing `harness-integrity-tightening`:

- replace framework-local runtime `state_dir` with explicit execution roots
- bind traces, egress evidence, and cost evidence to canonical retained run
  roots under `state/evidence/runs/**`
- remove ambient `net.http` from default `execution/flow`
- add repo-owned network egress and execution budget policy surfaces
- add machine-readable architecture contract registry plus blocking
  architecture-conformance validation and CI
- align runtime/bootstrap/operator docs to the tightened `_ops/` and execution
  write-root contract

## Cutover Assertions

- Runtime config exposes `run_evidence_root`, `execution_control_root`, and
  `execution_tmp_root` only; no live engine entrypoint still depends on a
  framework-local `state_dir`.
- `TraceWriter` emits `trace.ndjson` inside the canonical retained run root.
- External flow egress now requires repo-owned
  `instance/governance/policies/network-egress.yml` authorization and retained
  `network-egress.ndjson`.
- Model-backed workflow execution now evaluates repo-owned execution budgets and
  emits retained `cost.json` plus mutable budget-state updates.
- `contract-registry.yml`, `validate-architecture-conformance.sh`, and
  `.github/workflows/architecture-conformance.yml` are the new anti-drift
  enforcement surfaces.
- The proposal package was archived as implemented and the generated proposal
  registry now reflects that closeout state.

## Receipts And Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/061-harness-integrity-tightening-atomic-cutover.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-22-harness-integrity-tightening-cutover/plan.md`
