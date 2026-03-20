# Generated Outputs, Effective Views, and Commit Policy

This is a temporary, implementation-scoped architecture proposal for
`generated-effective-cognition-registry`.
It translates the ratified Packet 10 design packet and the ratified super-root
blueprint into the repository's proposal format.
It is not a canonical runtime, documentation, policy, or contract authority.

## Purpose

- proposal kind: `architecture`
- promotion scope: `octon-internal`
- summary: Consolidate all rebuildable outputs under `/.octon/generated/**`,
  normalize the final published families to `effective/**`, `cognition/**`,
  and `proposals/**`, preserve generated non-authority, ratify the default
  commit-versus-rebuild matrix, and rehome retained evidence out of migration-
  era generated buckets.

## Promotion Targets

- `.octon/README.md`
- `.octon/octon.yml`
- `.octon/instance/bootstrap/START.md`
- `.octon/framework/cognition/_meta/architecture/specification.md`
- `.octon/framework/cognition/_meta/architecture/shared-foundation.md`
- `.octon/framework/cognition/_meta/architecture/runtime-vs-ops-contract.md`
- `.octon/framework/cognition/_meta/architecture/generated/`
- `.octon/framework/capabilities/_meta/architecture/`
- `.octon/framework/assurance/runtime/`
- `.octon/framework/orchestration/runtime/workflows/`
- `.octon/framework/scaffolding/governance/patterns/`
- `.octon/framework/scaffolding/runtime/templates/octon/`

## Reading Order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `resources/octon_packet_10_generated_effective_cognition_registry.md`
4. `resources/octon_ratified_architectural_blueprint.md`
5. `navigation/source-of-truth-map.md`
6. `architecture/target-architecture.md`
7. `architecture/acceptance-criteria.md`
8. `architecture/implementation-plan.md`

## Supporting Resources

- `resources/octon_packet_10_generated_effective_cognition_registry.md`
  captures the ratified Packet 10 design packet used to draft this proposal.
- `resources/octon_ratified_architectural_blueprint.md` bundles the ratified
  blueprint sections that constrain generated-class placement, effective-view
  publication, cognition-derived outputs, proposal discovery, commit policy,
  and migration sequencing.

## Exit Path

Promote the normalized generated-class contract, effective publication
metadata rules, cognition-output placement rules, proposal-registry authority
boundary, commit-policy matrix, and generated-bucket migration guidance into
durable `.octon/` architecture, manifest, assurance, workflow, and scaffolding
surfaces, then archive this proposal once canonical generated-output behavior
no longer depends on proposal-local framing.
