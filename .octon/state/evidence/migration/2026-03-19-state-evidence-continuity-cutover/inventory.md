# Inventory

## Added

- Packet 7 state architecture indexes and control-state schemas:
  - `.octon/framework/cognition/_meta/architecture/state/{README.md,evidence/README.md,control/README.md}`
  - `.octon/framework/cognition/_meta/architecture/state/control/schemas/{README.md,extension-active-state.schema.json,extension-quarantine-state.schema.json,locality-quarantine-state.schema.json}`
- Live Packet 7 state roots and scope continuity scaffold:
  - `.octon/state/{continuity/README.md,evidence/README.md,control/README.md}`
  - `.octon/state/continuity/scopes/octon-harness/{log.md,tasks.json,entities.json,next.md}`
  - `.octon/state/evidence/decisions/scopes/README.md`
- Packet 7 assurance drift guard:
  - `.octon/framework/assurance/runtime/_ops/scripts/validate-state-surface-alignment.sh`
- Packet 7 migration records:
  - `.octon/instance/cognition/decisions/051-state-evidence-continuity-atomic-cutover.md`
  - `.octon/instance/cognition/context/shared/migrations/2026-03-19-state-evidence-continuity-cutover/plan.md`
  - `.octon/state/evidence/migration/2026-03-19-state-evidence-continuity-cutover/{bundle.yml,evidence.md,commands.md,validation.md,inventory.md}`

## Modified

- Root, bootstrap, and memory-routing surfaces:
  - `.octon/README.md`
  - `.octon/octon.yml`
  - `.octon/instance/bootstrap/{START.md,catalog.md}`
  - `.octon/instance/ingress/AGENTS.md`
  - `.octon/instance/cognition/context/shared/{memory-map.md,continuity.md}`
  - `.octon/instance/cognition/context/scopes/README.md`
- Packet 7 continuity/evidence/control architecture docs:
  - `.octon/framework/cognition/_meta/architecture/{specification.md,shared-foundation.md,runtime-vs-ops-contract.md}`
  - `.octon/framework/cognition/_meta/architecture/state/continuity/{README.md,continuity-plane.md,three-planes-integration.md,progress.md,schemas/README.md}`
  - `.octon/framework/cognition/_meta/architecture/artifact-surface/{README.md,runtime-artifact-layer.md}`
  - `.octon/framework/cognition/governance/{pillars/continuity.md,principles/locality.md}`
- Runtime/operator/scaffolding guidance:
  - `.octon/framework/assurance/practices/{session-exit.md,complete.md}`
  - `.octon/framework/orchestration/practices/{run-linkage-standards.md,automation-operations.md}`
  - `.octon/framework/orchestration/runtime/runs/README.md`
  - `.octon/framework/orchestration/runtime/workflows/tasks/agent-led-happy-path/stages/01-inline.md`
  - `.octon/framework/scaffolding/runtime/templates/octon/{START.md,manifest.json,continuity/entities.json}`
  - `.octon/framework/scaffolding/runtime/templates/octon/assurance/practices/{session-exit.md,complete.md}`
- Validator, publication, and test surfaces:
  - `.octon/framework/orchestration/runtime/_ops/scripts/publish-locality-state.sh`
  - `.octon/framework/assurance/runtime/_ops/scripts/{alignment-check.sh,validate-framework-core-boundary.sh,validate-locality-registry.sh,validate-continuity-memory.sh,validate-context-overhead-budget.sh,validate-harness-structure.sh,validate-state-surface-alignment.sh}`
  - `.octon/framework/assurance/runtime/_ops/tests/{test-validate-locality-registry.sh,test-validate-continuity-memory.sh}`
- State and migration support docs:
  - `.octon/state/evidence/migration/README.md`
  - `.octon/state/evidence/decisions/repo/README.md`
  - `.octon/state/continuity/repo/next.md`
  - `.octon/framework/engine/runtime/spec/policy-interface-v1.md`
  - `.octon/instance/cognition/context/shared/migrations/2026-03-19-locality-and-scope-registry-cutover/plan.md`
  - `.octon/instance/cognition/decisions/050-locality-and-scope-registry-atomic-cutover.md`
- Discovery indexes:
  - `.octon/instance/cognition/context/index.yml`
  - `.octon/instance/cognition/decisions/index.yml`
  - `.octon/instance/cognition/context/shared/migrations/index.yml`
- Live capability metadata:
  - `.octon/framework/capabilities/runtime/skills/registry.yml`
  - `.octon/framework/capabilities/runtime/skills/audit/audit-{api-contract,security-compliance,test-quality,data-governance,release-readiness,operational-readiness}/references/io-contract.md`

## Validation Side Effects

- `.octon/generated/effective/extensions/{catalog.effective.yml,artifact-map.yml,generation.lock.yml}`
- `.octon/state/control/extensions/{active.yml,quarantine.yml}`
- `.octon/instance/cognition/context/shared/decisions.md`
