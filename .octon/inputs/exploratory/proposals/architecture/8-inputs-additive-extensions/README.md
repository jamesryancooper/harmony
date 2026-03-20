# Internal Extension-Pack Inputs and Desired/Actual/Compiled Pipeline

This is a temporary, implementation-scoped architecture proposal for
`inputs-additive-extensions`.
It translates the ratified Packet 8 design packet and the ratified super-root
blueprint into the repository's proposal format.
It is not a canonical runtime, documentation, policy, or contract authority.

## Purpose

- proposal kind: `architecture`
- promotion scope: `octon-internal`
- summary: Formalize additive extension packs under
  `/.octon/inputs/additive/extensions/**`, preserve
  `instance/extensions.yml` as the single desired configuration surface, and
  ratify the fail-closed desired/actual/quarantine/compiled publication
  pipeline plus behaviorally complete snapshot semantics for enabled packs.

## Promotion Targets

- `.octon/README.md`
- `.octon/octon.yml`
- `.octon/instance/extensions.yml`
- `.octon/inputs/additive/extensions/`
- `.octon/state/control/extensions/`
- `.octon/generated/effective/extensions/`
- `.octon/framework/cognition/_meta/architecture/specification.md`
- `.octon/framework/cognition/_meta/architecture/shared-foundation.md`
- `.octon/framework/engine/governance/extensions/`
- `.octon/framework/capabilities/_meta/architecture/`
- `.octon/framework/assurance/runtime/`
- `.octon/framework/orchestration/runtime/workflows/`
- `.octon/framework/scaffolding/runtime/templates/octon/`

## Reading Order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `resources/octon_packet_8_inputs_additive_extensions.md`
4. `resources/octon_ratified_architectural_blueprint.md`
5. `navigation/source-of-truth-map.md`
6. `architecture/target-architecture.md`
7. `architecture/acceptance-criteria.md`
8. `architecture/implementation-plan.md`

## Supporting Resources

- `resources/octon_packet_8_inputs_additive_extensions.md` captures the
  ratified Packet 8 design packet used to draft this proposal.
- `resources/octon_ratified_architectural_blueprint.md` bundles the ratified
  blueprint sections that constrain additive extension placement, desired
  versus actual versus quarantine state, behaviorally complete snapshot
  semantics, trust and compatibility boundaries, and generated-output commit
  policy.

## Exit Path

Promote the additive extension-pack placement rules, unified `pack.yml`
contract, desired/actual/quarantine/compiled publication split, snapshot and
export semantics, fail-closed validation rules, and legacy-sidecar retirement
guidance into durable `.octon/` architecture, input, instance, state,
generated, assurance, and workflow surfaces, then archive this proposal once
canonical extension behavior no longer depends on proposal-local framing.
