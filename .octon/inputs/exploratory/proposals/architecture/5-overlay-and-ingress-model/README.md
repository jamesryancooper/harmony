# Repo-Instance Overlay and Ingress Model

This is a temporary, implementation-scoped architecture proposal for
`overlay-and-ingress-model`.
It translates the ratified Packet 5 design packet and the ratified super-root
blueprint into the repository's proposal format.
The proposal has been implemented in the repository and remains here as a
temporary non-canonical planning artifact until archival.
It is not a canonical runtime, documentation, policy, or contract authority.

## Purpose

- proposal kind: `architecture`
- promotion scope: `octon-internal`
- summary: Formalize `/.octon/framework/overlay-points/registry.yml` as the
  canonical overlay registry, ratify
  `/.octon/instance/manifest.yml#enabled_overlay_points` and
  `/.octon/instance/ingress/AGENTS.md`, define the legal overlay-capable
  repo-instance surfaces, and define thin repo-root ingress adapter rules plus
  fail-closed overlay validation and precedence semantics.

## Promotion Targets

- `.octon/framework/manifest.yml`
- `.octon/framework/overlay-points/registry.yml`
- `.octon/instance/manifest.yml`
- `.octon/instance/ingress/AGENTS.md`
- `.octon/instance/governance/`
- `.octon/instance/agency/runtime/`
- `.octon/instance/assurance/runtime/`
- `.octon/README.md`
- `.octon/octon.yml`
- `.octon/AGENTS.md`
- `AGENTS.md`
- `CLAUDE.md`
- `.octon/framework/cognition/_meta/architecture/specification.md`
- `.octon/framework/cognition/_meta/architecture/shared-foundation.md`
- `.octon/framework/assurance/runtime/`
- `.octon/framework/orchestration/runtime/workflows/`

## Reading Order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `resources/octon_packet_5_overlay_and_ingress_model.md`
4. `resources/octon_ratified_architectural_blueprint.md`
5. `navigation/source-of-truth-map.md`
6. `architecture/target-architecture.md`
7. `architecture/acceptance-criteria.md`
8. `architecture/implementation-plan.md`

## Supporting Resources

- `resources/octon_packet_5_overlay_and_ingress_model.md` captures the
  ratified Packet 5 design packet used to draft this proposal.
- `resources/octon_ratified_architectural_blueprint.md` bundles the ratified
  blueprint sections that constrain overlay-capable instance placement,
  enablement, canonical internal ingress, thin-adapter rules, and fail-closed
  validation.

## Exit Path

Promote the overlay registry contract, repo-side enablement semantics,
canonical internal ingress placement, thin adapter rules, and validator-driven
overlay enforcement into durable `.octon/` architecture, ingress, assurance,
and workflow surfaces, then archive this proposal once canonical overlay and
ingress behavior no longer depends on temporary proposal framing.
