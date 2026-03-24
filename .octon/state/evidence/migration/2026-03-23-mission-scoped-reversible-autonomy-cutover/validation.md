# Validation

Executed validation for the Mission-Scoped Reversible Autonomy cutover:

- `validate-mission-proposal-package.sh` — passed
- `validate-mission-authority.sh` — passed
- `validate-mission-runtime-contracts.sh` — passed
- `validate-mission-control-state.sh` — passed
- `validate-mission-control-evidence.sh` — passed
- `validate-mission-generated-summaries.sh` — passed
- `validate-mission-source-of-truth.sh` — passed
- `test-mission-autonomy-scenarios.sh` — passed
- `alignment-check.sh --profile mission-autonomy` — passed
- `validate-runtime-effective-state.sh` — passed after refreshing extension and
  capability publication state for the `0.6.0` manifest change
- `alignment-check.sh --profile harness,mission-autonomy` — passed

Additional operational notes:

- `publish-host-projections.sh` required one elevated rerun to refresh
  `.codex/**`, `.cursor/**`, and `.claude/**` in the local environment.
- Extension publication and capability routing were republished after the root
  manifest and extension pack compatibility bumps so downstream publication
  hashes matched the new `0.6.0` state.
