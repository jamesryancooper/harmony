# State, Evidence, and Continuity Class Root

This is a temporary, implementation-scoped architecture proposal for
`state-evidence-continuity`.
It translates the ratified Packet 7 design packet and the ratified super-root
blueprint into the repository's proposal format.
It is not a canonical runtime, documentation, policy, or contract authority.

## Purpose

- proposal kind: `architecture`
- promotion scope: `octon-internal`
- summary: Formalize `/.octon/state/**` as the class-rooted home for active
  continuity, retained operational evidence, and mutable control state,
  including the repo-before-scope continuity sequencing rule and the
  desired/actual/quarantine/compiled split for extension activation.

## Promotion Targets

- `.octon/README.md`
- `.octon/instance/bootstrap/START.md`
- `.octon/instance/cognition/context/shared/memory-map.md`
- `.octon/instance/cognition/context/shared/continuity.md`
- `.octon/instance/extensions.yml`
- `.octon/state/continuity/`
- `.octon/state/evidence/`
- `.octon/state/control/extensions/`
- `.octon/state/control/locality/`
- `.octon/generated/effective/extensions/`
- `.octon/generated/effective/locality/`
- `.octon/framework/cognition/_meta/architecture/specification.md`
- `.octon/framework/cognition/_meta/architecture/state/continuity/`
- `.octon/framework/cognition/_meta/architecture/runtime-vs-ops-contract.md`
- `.octon/framework/cognition/governance/pillars/continuity.md`
- `.octon/framework/assurance/runtime/`
- `.octon/framework/scaffolding/runtime/templates/octon/continuity/`
- `.octon/framework/orchestration/runtime/workflows/`

## Reading Order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `resources/octon_packet_7_state_evidence_continuity.md`
4. `resources/octon_ratified_architectural_blueprint.md`
5. `navigation/source-of-truth-map.md`
6. `architecture/target-architecture.md`
7. `architecture/acceptance-criteria.md`
8. `architecture/implementation-plan.md`

## Supporting Resources

- `resources/octon_packet_7_state_evidence_continuity.md` captures the
  ratified Packet 7 design packet used to draft this proposal.
- `resources/octon_ratified_architectural_blueprint.md` bundles the ratified
  blueprint sections that constrain state placement, evidence retention,
  desired versus actual control state, memory routing, and migration
  sequencing.

## Exit Path

Promote the state-class contract, continuity/evidence/control boundary rules,
memory-routing updates, retention/reset semantics, and fail-closed
validation/publication behavior into durable `.octon/` architecture, state,
generated, assurance, and workflow surfaces, then archive this proposal once
canonical state behavior no longer depends on transitional continuity-plane
wording or mixed legacy routing assumptions.
