# Portability, Compatibility, Trust, and Provenance Contract

This is a temporary, implementation-scoped architecture proposal for
`portability-compatibility-trust-provenance`.
It translates the ratified Packet 13 design packet and the ratified super-root
blueprint into the repository's proposal format.
It is not a canonical runtime, documentation, policy, or contract authority.

## Purpose

- proposal kind: `architecture`
- promotion scope: `octon-internal`
- summary: Ratify Octon's profile-driven portability model, behaviorally
  complete `repo_snapshot` semantics, manifest compatibility gates,
  repo-authored trust policy, and pack-authored provenance so bootstrap,
  export, publication, and audit behavior remain reproducible and fail closed.

## Promotion Targets

- `.octon/octon.yml`
- `.octon/framework/manifest.yml`
- `.octon/instance/manifest.yml`
- `.octon/instance/extensions.yml`
- `.octon/inputs/additive/extensions/`
- `.octon/state/control/extensions/`
- `.octon/generated/effective/extensions/`
- `.octon/README.md`
- `.octon/instance/bootstrap/START.md`
- `.octon/framework/cognition/_meta/architecture/specification.md`
- `.octon/framework/cognition/_meta/architecture/shared-foundation.md`
- `.octon/framework/engine/governance/extensions/`
- `.octon/framework/assurance/runtime/`
- `.octon/framework/orchestration/runtime/workflows/`

## Reading Order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `resources/octon_packet_13_portability_compatibility_trust_provenance.md`
4. `resources/octon_ratified_architectural_blueprint.md`
5. `navigation/source-of-truth-map.md`
6. `architecture/target-architecture.md`
7. `architecture/acceptance-criteria.md`
8. `architecture/implementation-plan.md`

## Supporting Resources

- `resources/octon_packet_13_portability_compatibility_trust_provenance.md`
  captures the ratified Packet 13 design packet used to draft this proposal.
- `resources/octon_ratified_architectural_blueprint.md` bundles the ratified
  blueprint sections that constrain the portability, compatibility, trust, and
  provenance contract.

## Exit Path

Promote the portability profile model, compatibility contract, trust and
provenance split, and fail-closed export and publication behavior into durable
`.octon/` manifests, extension-pack contracts, validator logic, workflows, and
operator guidance, then archive this proposal once the canonical harness no
longer depends on transitional trust or snapshot semantics.
