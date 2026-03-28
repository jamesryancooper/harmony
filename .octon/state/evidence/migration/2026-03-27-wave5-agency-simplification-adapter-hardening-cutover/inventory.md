# Change Inventory

## Summary

- Wave 5 touched 58 files across agency, constitution, engine runtime,
  assurance, bootstrap, and governance surfaces.
- The kernel agency default was renamed from persona-heavy `architect` /
  `auditor` roles to `orchestrator` / `verifier`.
- A new constitutional adapter family and runtime adapter manifest surface were
  added.

## Major Change Groups

### Agency simplification

- `framework/agency/manifest.yml`
- `framework/agency/runtime/agents/registry.yml`
- `framework/agency/runtime/agents/{orchestrator,verifier}/**`
- `framework/agency/runtime/assistants/{registry.yml,*/assistant.md}`
- `framework/agency/runtime/teams/{registry.yml,delivery-core/team.md}`
- `framework/agency/_ops/scripts/validate/validate-agency.sh`

### Adapter contracts and support targets

- `framework/constitution/contracts/adapters/**`
- `framework/engine/runtime/adapters/**`
- `framework/constitution/support-targets.schema.json`
- `instance/governance/support-targets.yml`
- `framework/engine/runtime/config/policy-interface.yml`
- `framework/engine/runtime/spec/policy-interface-v1.md`
- `framework/constitution/contracts/disclosure/{family.yml,run-card-v1.schema.json,harness-card-v1.schema.json}`
- `framework/orchestration/runtime/_ops/scripts/write-run.sh`
- `framework/lab/runtime/_ops/scripts/write-harness-card.sh`
- `octon.yml`

### Runtime and assurance hardening

- `framework/engine/runtime/crates/kernel/src/{authorization.rs,pipeline.rs,workflow.rs}`
- `framework/engine/runtime/crates/{core,studio}/src/{orchestration.rs,app_state.rs}`
- `framework/assurance/runtime/_ops/scripts/{alignment-check.sh,validate-execution-governance.sh,validate-harness-structure.sh,validate-wave5-agency-adapter-hardening.sh}`
- `framework/assurance/runtime/contracts/alignment-profiles.yml`
- `.github/workflows/architecture-conformance.yml`

### Remaining-gap cleanup

- active orchestration/watcher/automation ownership examples normalized from
  `architect` to `orchestrator`
- active service generated manifests normalized from `agent_id=architect` to
  `agent_id=orchestrator`
- retained sample RunCards and HarnessCards extended with adapter provenance and
  conformance criteria

### Durable rollout records

- `instance/cognition/context/shared/migrations/2026-03-27-wave5-agency-simplification-adapter-hardening-cutover/plan.md`
- `instance/cognition/decisions/073-wave5-agency-simplification-and-adapter-hardening-cutover.md`
