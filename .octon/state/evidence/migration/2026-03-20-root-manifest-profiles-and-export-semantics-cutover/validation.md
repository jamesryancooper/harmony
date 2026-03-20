# Validation

## Gate Results

- `validate-proposal-standard.sh --all-standard-proposals`: PASS
- `alignment-check.sh --profile harness`: PASS (`errors=0`)

## Contract Assertions Verified

- The root-manifest proposal package is archived with an `implemented`
  disposition.
- The live root-manifest/profile contract remains in durable `.octon/`
  surfaces rather than the archived proposal.
