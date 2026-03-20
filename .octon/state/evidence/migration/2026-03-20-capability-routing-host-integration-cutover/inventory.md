# Change Inventory

## Contract Surfaces

- capability routing schemas upgraded to `v2`
- extension effective schemas upgraded to `v3`
- locality scope schema upgraded to `v2`
- framework capability manifests/registries gained `routing` and
  `host_adapters`
- repo-native command and skill manifests introduced

## Runtime And Publication

- capability routing publisher rewritten to consume locality and extension
  generations plus compiled extension `routing_exports`
- host projection publisher introduced
- host projection validator introduced
- harness alignment profile updated to publish and validate host projections

## Generated And Host Outputs

- regenerated `generated/effective/extensions/**`
- regenerated `generated/effective/capabilities/**`
- regenerated `.claude/skills/**`, `.cursor/skills/**`, `.codex/skills/**`
- regenerated `.claude/commands/**`, `.cursor/commands/**`,
  `.codex/commands/**`

## Docs And Templates

- capability architecture and creation docs updated to the projection model
- skills README and create-skill references updated
- scaffold templates updated to Packet 12 schema versions and repo-native
  manifests
