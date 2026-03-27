# Wave 4 Remediation Commands

- `bash -n .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh`
- `bash -n .octon/framework/lab/runtime/_ops/scripts/write-harness-card.sh`
- `bash -n .octon/framework/assurance/evaluators/runtime/_ops/scripts/write-evaluator-review.sh`
- `bash -n .octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`
- `bash .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh backfill-wave4 --run-id run-wave3-runtime-bridge-20260327`
- `bash .octon/framework/orchestration/runtime/_ops/scripts/write-decision.sh --decision-id dec-wave4-benchmark-evaluator-20260327 ...`
- `bash .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh create --run-id run-wave4-benchmark-evaluator-20260327 ... --risk-class high --support-tier release-and-boundary-sensitive`
- `bash .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh complete --run-id run-wave4-benchmark-evaluator-20260327 ...`
- `bash .octon/framework/assurance/evaluators/runtime/_ops/scripts/write-evaluator-review.sh --subject-ref .octon/state/evidence/lab/harness-cards/hc-wave4-benchmark-disclosure-20260327.yml ...`
- `bash .octon/framework/lab/runtime/_ops/scripts/write-harness-card.sh --card-id hc-wave4-benchmark-disclosure-20260327 ...`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`
- `bash .octon/framework/orchestration/runtime/runs/_ops/scripts/validate-runs.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-harness-structure.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness`
- `jq . .octon/state/continuity/repo/tasks.json`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-continuity-memory.sh`
- `git diff --check`
