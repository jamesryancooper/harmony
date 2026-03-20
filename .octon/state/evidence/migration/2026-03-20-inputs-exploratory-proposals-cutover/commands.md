# Commands

## Rename And Path-Convergence Commands

```bash
git mv .octon/inputs/exploratory/proposals/architecture/1-super-root-semantics-and-taxonomy .octon/inputs/exploratory/proposals/architecture/super-root-semantics-and-taxonomy
git mv .octon/inputs/exploratory/proposals/architecture/2-root-manifest-profiles-and-export-semantics .octon/inputs/exploratory/proposals/architecture/root-manifest-profiles-and-export-semantics
git mv .octon/inputs/exploratory/proposals/architecture/3-framework-core-architecture .octon/inputs/exploratory/proposals/architecture/framework-core-architecture
git mv .octon/inputs/exploratory/proposals/architecture/4-repo-instance-architecture .octon/inputs/exploratory/proposals/architecture/repo-instance-architecture
git mv .octon/inputs/exploratory/proposals/architecture/5-overlay-and-ingress-model .octon/inputs/exploratory/proposals/architecture/overlay-and-ingress-model
git mv .octon/inputs/exploratory/proposals/architecture/6-locality-and-scope-registry .octon/inputs/exploratory/proposals/architecture/locality-and-scope-registry
git mv .octon/inputs/exploratory/proposals/architecture/7-state-evidence-continuity .octon/inputs/exploratory/proposals/architecture/state-evidence-continuity
git mv .octon/inputs/exploratory/proposals/architecture/8-inputs-additive-extensions .octon/inputs/exploratory/proposals/architecture/inputs-additive-extensions
git mv .octon/inputs/exploratory/proposals/architecture/9-inputs-exploratory-proposals .octon/inputs/exploratory/proposals/architecture/inputs-exploratory-proposals
git mv .octon/inputs/exploratory/proposals/architecture/10-generated-effective-cognition-registry .octon/inputs/exploratory/proposals/architecture/generated-effective-cognition-registry
git mv .octon/inputs/exploratory/proposals/architecture/11-memory-context-adrs-operational-decision-evidence .octon/inputs/exploratory/proposals/architecture/memory-context-adrs-operational-decision-evidence
git mv .octon/inputs/exploratory/proposals/architecture/12-capability-routing-host-integration .octon/inputs/exploratory/proposals/architecture/capability-routing-host-integration
git mv .octon/inputs/exploratory/proposals/architecture/13-portability-compatibility-trust-provenance .octon/inputs/exploratory/proposals/architecture/portability-compatibility-trust-provenance
git mv .octon/inputs/exploratory/proposals/architecture/14-validation-fail-closed-quarantine-staleness .octon/inputs/exploratory/proposals/architecture/validation-fail-closed-quarantine-staleness
git mv .octon/inputs/exploratory/proposals/architecture/15-migration-rollout .octon/inputs/exploratory/proposals/architecture/migration-rollout
```

## Validation Commands

```bash
bash .octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh --all-standard-proposals
bash .octon/framework/assurance/runtime/_ops/tests/test-validate-proposal-standard.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-create-design-proposal-workflow-runner.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-create-migration-proposal-workflow-runner.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-create-policy-proposal-workflow-runner.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-create-architecture-proposal-workflow-runner.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-audit-design-proposal-workflow-runner.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-audit-migration-proposal-workflow-runner.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-audit-policy-proposal-workflow-runner.sh
bash .octon/framework/assurance/runtime/_ops/tests/test-audit-architecture-proposal-workflow-runner.sh
bash .octon/framework/orchestration/runtime/_ops/scripts/validate-orchestration-live-independence.sh
bash .octon/framework/orchestration/runtime/queue/_ops/scripts/validate-queue.sh
bash .octon/framework/orchestration/runtime/_ops/scripts/publish-locality-state.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-locality-publication-state.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-framework-core-boundary.sh
bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness
```
