# Wave 4 Commands

- `bash -n .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh`
- `bash -n .octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`
- `yq -e '.' .octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/disclosure/run-card.yml`
- `yq -e '.' .octon/state/evidence/lab/harness-cards/hc-wave4-assurance-disclosure-20260327.yml`
- `yq -e '.' .octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/replay-pointers.yml`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`
- `bash .octon/framework/orchestration/runtime/runs/_ops/scripts/validate-runs.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-harness-structure.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-framework-core-boundary.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness`
- `jq . .octon/state/continuity/repo/tasks.json`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-continuity-memory.sh`
- `git diff --check`
