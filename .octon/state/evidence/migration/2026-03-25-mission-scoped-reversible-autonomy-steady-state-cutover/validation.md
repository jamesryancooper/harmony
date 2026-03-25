# Validation

- [x] `validate-version-parity.sh` passes at `0.6.1`.
- [x] `validate-mission-control-state.sh` passes with the final control-file family.
- [x] `validate-mission-effective-routes.sh` passes with slice-linked,
      non-idle material routing.
- [x] `validate-mission-generated-summaries.sh` passes with
      `mission-view.yml`.
- [x] `validate-mission-control-evidence.sh` passes with explicit mutation-class
      coverage receipts.
- [x] `validate-mission-source-of-truth.sh` passes with no legacy `.json`
      mission projection remaining.
- [x] `validate-mission-runtime-contracts.sh` passes.
- [x] `test-mission-autonomy-scenarios.sh` passes.
- [x] `validate-architecture-conformance.sh` passes.
- [x] `validate-runtime-effective-state.sh` passes after republishing
      extension/locality/capability effective outputs for the `0.6.1`
      manifest change.
- [x] `test-mission-autonomy-helpers.sh` passes.
- [x] `test-validate-runtime-effective-state.sh` passes.

## Notes

- `alignment-check.sh --profile harness,mission-autonomy` still reports one
  unrelated continuity-memory run-directory retention error under the broader
  `harness` profile. The mission-autonomy surfaces audited here pass.
