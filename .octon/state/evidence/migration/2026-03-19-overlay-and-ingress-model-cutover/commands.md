# Commands

## Validation Commands

```bash
bash .octon/framework/assurance/runtime/_ops/tests/test-validate-overlay-points.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-validate-bootstrap-ingress.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-validate-repo-instance-boundary.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-overlay-points.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-bootstrap-ingress.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-repo-instance-boundary.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-companion-manifests.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-bootstrap-projections.sh
bash .octon/framework/agency/_ops/scripts/validate/validate-agency.sh
bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness
bash .octon/framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh --target projections --target evidence --target evaluations --target knowledge --target decisions
bash .octon/framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh --check --target projections --target evidence --target evaluations --target knowledge --target decisions
```

## Auxiliary Generation

```bash
bash .octon/framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh --target projections --target evidence --target evaluations --target knowledge --target decisions
```
