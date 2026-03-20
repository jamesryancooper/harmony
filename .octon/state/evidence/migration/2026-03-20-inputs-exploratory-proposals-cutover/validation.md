# Validation

## Gate Results

- `validate-proposal-standard.sh --all-standard-proposals`: PASS
- Proposal subtype validators across all manifest-governed proposals: PASS
- `test-validate-proposal-standard.sh`: PASS
- `test-create-design-proposal-workflow-runner.sh`: PASS
- `test-create-migration-proposal-workflow-runner.sh`: PASS
- `test-create-policy-proposal-workflow-runner.sh`: PASS
- `test-create-architecture-proposal-workflow-runner.sh`: PASS
- `test-audit-design-proposal-workflow-runner.sh`: PASS
- `test-audit-migration-proposal-workflow-runner.sh`: PASS
- `test-audit-policy-proposal-workflow-runner.sh`: PASS
- `test-audit-architecture-proposal-workflow-runner.sh`: PASS
- `validate-orchestration-live-independence.sh`: PASS (`errors=0`)
- `validate-queue.sh`: PASS (`errors=0 warnings=0`)
- `publish-locality-state.sh`: completed successfully
- `validate-locality-publication-state.sh`: PASS (`errors=0`)
- `validate-framework-core-boundary.sh`: PASS (`errors=0`)
- `alignment-check.sh --profile harness`: PASS (`errors=0`)

## Contract Assertions Verified

- No repo-authored numbered architecture proposal paths remain outside bundled
  source packet resources.
- `generated/proposals/registry.yml` paths resolve to on-disk proposal package
  roots.
- Proposal validators now treat repo-root-relative and absolute `--package`
  arguments consistently.
- Proposal standards, templates, and Packet 9 promoted docs all describe the
  same unnumbered `<kind>/<proposal_id>/` path model.
- The archived extension sidecar proposal now carries final archive metadata
  and a `superseded` disposition.
- Engine source-build cache output no longer recreates
  `framework/engine/_ops/state/**`.
