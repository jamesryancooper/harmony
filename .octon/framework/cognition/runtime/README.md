# Cognition Runtime

Authoritative cognition artifacts that agents and humans consume during work.

## Canonical Index

- `index.yml` - machine-readable runtime discovery index for all runtime surfaces.

## Surfaces

- `context/reference/` - shared reference context for runtime vocabulary and compaction rules.

This runtime surface is intentionally narrow. Decision records, migrations,
validation evidence, and derived projections now live under their canonical
`instance/**`, `state/**`, or `generated/**` families rather than being
redeclared here.
