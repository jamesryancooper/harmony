# Wave 4 Validation

- `bash -n .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh`: PASS
- `bash -n .octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`: PASS
- `yq -e '.' .octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/disclosure/run-card.yml`: PASS
- `yq -e '.' .octon/state/evidence/lab/harness-cards/hc-wave4-assurance-disclosure-20260327.yml`: PASS
- `yq -e '.' .octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/replay-pointers.yml`: PASS
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`: PASS
- `bash .octon/framework/orchestration/runtime/runs/_ops/scripts/validate-runs.sh`: PASS
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-harness-structure.sh`: PASS
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh`: PASS
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-framework-core-boundary.sh`: PASS
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness`: PASS
- `jq . .octon/state/continuity/repo/tasks.json`: PASS
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-continuity-memory.sh`: PASS with warnings
- `git diff --check`: PASS

Harness alignment warnings observed during the passing run:

- `validate-continuity-memory.sh` reported pre-existing warnings for empty
  retained run directories such as `audit-run-test`, `audit-run-test2`,
  `audit-run-test3`, `runtime-acp-budget-6891-54675`, and
  `runtime-acp-receipt-26629-54675`
- `validate-framing-alignment.sh` reported two allowlisted historical framing
  warnings in append-only ADR history
- the final standalone `validate-continuity-memory.sh` rerun reported the same
  pre-existing empty-run-directory warnings and no new errors
