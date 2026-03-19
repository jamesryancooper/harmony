# Inventory

## Added

- `.octon/framework/assurance/runtime/_ops/tests/test-validate-overlay-points.sh`
- `.octon/framework/assurance/runtime/_ops/tests/test-validate-bootstrap-ingress.sh`
- `.octon/instance/cognition/decisions/049-overlay-and-ingress-model-atomic-cutover.md`
- `.octon/instance/cognition/context/shared/migrations/2026-03-19-overlay-and-ingress-model-cutover/plan.md`
- `.octon/state/evidence/migration/2026-03-19-overlay-and-ingress-model-cutover/{bundle.yml,evidence.md,commands.md,validation.md,inventory.md}`

## Modified

- Packet 5 control-plane docs and ingress surfaces:
  - `.octon/README.md`
  - `.octon/AGENTS.md`
  - `AGENTS.md`
  - `CLAUDE.md`
  - `.octon/instance/bootstrap/START.md`
  - `.octon/framework/cognition/_meta/architecture/{README.md,specification.md,shared-foundation.md}`
- Packet 5 validators and agency/ingress enforcement:
  - `.octon/framework/assurance/runtime/_ops/scripts/{validate-overlay-points.sh,validate-repo-instance-boundary.sh,validate-bootstrap-ingress.sh}`
  - `.octon/framework/agency/_ops/scripts/validate/validate-agency.sh`
- Supporting runtime artifact fix:
  - `.octon/framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh`
  - `.octon/generated/cognition/projections/definitions/cognition-runtime-surface-map.yml`
- Packet 5 workflow and bootstrap/scaffolding guidance:
  - `.octon/framework/orchestration/runtime/workflows/meta/update-harness/{README.md,workflow.yml}`
  - `.octon/framework/orchestration/runtime/workflows/meta/update-harness/stages/{02-identify-gaps.md,05-execute.md}`
  - `.octon/framework/orchestration/runtime/workflows/meta/migrate-harness/stages/{03-content-migration.md,04-validation.md}`
  - `.octon/framework/capabilities/runtime/commands/init.md`
  - `.octon/framework/scaffolding/runtime/bootstrap/{AGENTS.md,README.md,manifest.yml}`
  - `.octon/framework/scaffolding/runtime/templates/octon/{START.md,manifest.json}`
  - `.octon/framework/scaffolding/runtime/templates/octon/framework/scaffolding/runtime/bootstrap/{AGENTS.md,README.md,manifest.yml}`
  - `.octon/framework/scaffolding/runtime/templates/octon/scaffolding/runtime/bootstrap/{AGENTS.md,README.md,manifest.yml}`
- Packet 5 indexes and generated decision discovery:
  - `.octon/instance/cognition/decisions/index.yml`
  - `.octon/instance/cognition/context/shared/migrations/index.yml`
  - `.octon/instance/cognition/context/shared/decisions.md`
  - `.octon/instance/cognition/context/shared/evidence/index.yml`
  - `.octon/instance/cognition/context/shared/knowledge/sources/ingestion-receipts.yml`
  - `.octon/generated/cognition/projections/materialized/cognition-runtime-surface-map.latest.yml`
  - `.octon/generated/cognition/graph/{nodes.yml,edges.yml}`
- Validation side effects from the harness gate:
  - `.octon/state/control/extensions/{active.yml,quarantine.yml}`
  - `.octon/generated/effective/extensions/{catalog.effective.yml,artifact-map.yml,generation.lock.yml}`
