# Inventory

## Added

- Packet 9 cutover decision and migration records:
  - `.octon/instance/cognition/decisions/052-inputs-exploratory-proposals-atomic-cutover.md`
  - `.octon/instance/cognition/context/shared/migrations/2026-03-20-inputs-exploratory-proposals-cutover/plan.md`
  - `.octon/state/evidence/migration/2026-03-20-inputs-exploratory-proposals-cutover/{bundle.yml,evidence.md,commands.md,validation.md,inventory.md}`

## Modified

- Proposal workspace and super-root contract docs:
  - `.octon/inputs/exploratory/proposals/README.md`
  - `.octon/README.md`
  - `.octon/instance/bootstrap/START.md`
  - `.octon/framework/cognition/_meta/architecture/{specification.md,shared-foundation.md}`
- Proposal standards, scaffold templates, and registry schema:
  - `.octon/framework/scaffolding/governance/patterns/{proposal-standard.md,design-proposal-standard.md,migration-proposal-standard.md,policy-proposal-standard.md,architecture-proposal-standard.md}`
  - `.octon/framework/scaffolding/runtime/templates/proposal-*/README.md`
  - `.octon/framework/scaffolding/runtime/templates/proposal-core/navigation/source-of-truth-map.md`
  - `.octon/framework/scaffolding/runtime/templates/proposal-registry.schema.json`
- Proposal validators, workflow generator, and workflow guidance:
  - `.octon/framework/assurance/runtime/_ops/scripts/validate-{proposal-standard,design-proposal,migration-proposal,policy-proposal,architecture-proposal}.sh`
  - `.octon/framework/engine/runtime/crates/kernel/src/workflow.rs`
  - `.octon/framework/orchestration/practices/workflow-authoring-standards.md`
- Engine runtime cache path surfaces:
  - `.octon/framework/engine/runtime/{run,run.cmd,policy.cmd}`
  - `.octon/framework/engine/runtime/crates/kernel/src/main.rs`
- Proposal workflow runner tests:
  - `.octon/framework/assurance/runtime/_ops/tests/test-{validate-proposal-standard,create-design-proposal-workflow-runner,create-migration-proposal-workflow-runner,create-policy-proposal-workflow-runner,create-architecture-proposal-workflow-runner,audit-design-proposal-workflow-runner,audit-migration-proposal-workflow-runner,audit-policy-proposal-workflow-runner,audit-architecture-proposal-workflow-runner}.sh`
- Proposal and registry path references:
  - `.octon/generated/proposals/registry.yml`
  - `.octon/instance/cognition/decisions/{048-repo-instance-architecture-atomic-cutover.md,049-overlay-and-ingress-model-atomic-cutover.md,050-locality-and-scope-registry-atomic-cutover.md,051-state-evidence-continuity-atomic-cutover.md,index.yml}`
  - `.octon/instance/cognition/context/shared/migrations/index.yml`
  - `.octon/state/continuity/repo/{log.md,tasks.json}`
  - `.octon/state/evidence/migration/{2026-03-18-framework-core-architecture-cutover,2026-03-18-repo-instance-architecture-cutover,2026-03-19-overlay-and-ingress-model-cutover,2026-03-19-locality-and-scope-registry-cutover,2026-03-19-state-evidence-continuity-cutover}/**`
- Proposal packages and archived manifests:
  - `.octon/inputs/exploratory/proposals/architecture/**`
  - `.octon/inputs/exploratory/proposals/.archive/architecture/extensions-sidecar-pack-system/proposal.yml`

## Validation Side Effects

- `.octon/generated/effective/locality/{scopes.effective.yml,artifact-map.yml,generation.lock.yml}`
- `.octon/generated/effective/extensions/{catalog.effective.yml,artifact-map.yml,generation.lock.yml}`
- `.octon/state/control/extensions/{active.yml,quarantine.yml}`
- `.octon/state/control/locality/quarantine.yml`
