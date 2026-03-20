# Extension Governance

This surface governs Packet 8 additive extension-pack boundaries.

## Canonical Rules

- Raw extension packs live only under `inputs/additive/extensions/**`.
- Desired repo-owned activation lives only in `instance/extensions.yml`.
- Actual active state and quarantine truth live only under
  `state/control/extensions/**`.
- Runtime-facing extension consumption reads only
  `generated/effective/extensions/**`.
- Raw pack paths must never become direct runtime or policy dependencies.

## Subcontracts

- `boundary-contract.md`
- `trust-and-compatibility.md`
