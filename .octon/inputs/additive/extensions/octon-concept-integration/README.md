# Octon Concept Integration Extension Pack

This bundled additive pack internalizes the concept-integration prompt set as a
reusable Octon capability.

It is designed to:

- accept a source artifact
- extract implementable concepts
- verify them against the live repository
- materialize a manifest-governed architecture proposal packet
- generate a packet-specific executable implementation prompt

## Buckets

- `skills/` - composite skill contract and pack-local metadata
- `commands/` - thin command wrapper for stable operator invocation
- `prompts/` - pack-local copy of the concept-integration prompt set
- `context/` - pack-local overview and usage guidance
- `validation/` - validation and publication guidance

## Boundary

This pack is additive only.

It must not become a direct runtime or policy authority surface.
Runtime-facing consumption must flow through generated effective extension and
capability publication outputs, not through raw pack paths.
