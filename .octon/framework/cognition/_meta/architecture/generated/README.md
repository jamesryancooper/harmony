# Generated Output Architecture

`generated/**` is Octon's class root for rebuildable output only.

## Canonical Families

- `generated/effective/**` for runtime-facing published views
- `generated/cognition/**` for derived cognition summaries, graph datasets,
  and projections
- `generated/proposals/**` for proposal discovery only
- `generated/.tmp/**` for ephemeral rebuild intermediates only

## Boundary

- Generated outputs are rebuildable and non-authoritative.
- Runtime-facing publication must live only under `generated/effective/**`.
- Retained validation and assurance receipts belong under `state/evidence/**`.
- `generated/artifacts/**`, `generated/assurance/**`, and
  `generated/effective/assurance/**` are not canonical Packet 10 families.
