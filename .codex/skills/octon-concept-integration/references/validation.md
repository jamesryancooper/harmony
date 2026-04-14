# Validation

Validate generated packets with:

- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh --package <packet-path>`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-proposal.sh --package <packet-path>`

If registry projection writes fail because of unrelated active proposal debt,
record that explicitly and continue validating the packet itself.
