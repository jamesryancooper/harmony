# Octon Frontier Governance Target-State Architecture Proposal

## Packet path

`/.octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state/`

## Purpose

This packet converts the repository-grounded **Octon frontier-governance architecture review** into a manifest-governed, promotion-aware architecture proposal for taking Octon to its target state:

> A minimum sufficient governance harness for frontier-model engineering: one accountable orchestrator, deterministic context packs, engine-owned authorization, deny-by-default capability gates, retained evidence, replay, rollback, intervention, support-proof dossiers, and automated assurance.

This packet is not canonical authority. It is an exploratory proposal package. Durable outcomes must be promoted into the `promotion_targets` declared by `proposal.yml`, and those promoted targets must stand alone after this packet is archived.

## Executive determination

Octon should not become a thin wrapper around frontier models. The repo's strongest surfaces are exactly the surfaces that become more important as frontier models become more capable: constitutional authority, engine-owned authorization, deny-by-default capability gates, run roots, retained evidence, support-target honesty, replay, rollback, intervention, and assurance.

Octon should, however, delete or demote surfaces whose primary value was compensating for older model limitations: token-era context-routing logic, workflow catalogs that merely choreograph reasoning, cognition/read-model surfaces that drift toward memory or authority, support claims not tied to proof, and multi-actor terminology that implies agent swarms instead of accountable execution roles.

## Proposal authority posture

The packet follows Octon's active proposal convention:

1. `proposal.yml` is the shared lifecycle authority for this proposal packet.
2. `architecture-proposal.yml` is the architecture subtype manifest.
3. `navigation/source-of-truth-map.md` records canonical authorities, proposal-local authorities, derived projections, retained evidence, and boundary rules.
4. Architecture and resource files are working artifacts.
5. `navigation/artifact-catalog.md` and `PACKET_MANIFEST.md` enumerate packet contents.
6. `SHA256SUMS.txt` provides archive integrity.

## Required upstream source

The full prior review is included verbatim in:

`resources/frontier-governance-architecture-review.md`

The packet's traceability from that review to adopted, adapted, deferred, rejected, and split implementation motions is captured in:

- `resources/coverage-traceability-matrix.md`
- `architecture/concept-coverage-matrix.md`
- `architecture/deletion-collapse-retention-matrix.md`

## Reading order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `navigation/source-of-truth-map.md`
4. `resources/frontier-governance-architecture-review.md`
5. `resources/repository-baseline-audit.md`
6. `architecture/target-architecture.md`
7. `architecture/current-state-gap-map.md`
8. `architecture/deletion-collapse-retention-matrix.md`
9. `architecture/file-change-map.md`
10. `architecture/implementation-plan.md`
11. `architecture/migration-cutover-plan.md`
12. `architecture/validation-plan.md`
13. `architecture/acceptance-criteria.md`
14. `architecture/closure-certification-plan.md`

## Non-authority notice

This packet lives under `inputs/exploratory/proposals/**`. It is excluded from runtime resolution, policy resolution, bootstrap export, and repo snapshot authority. It must never become a second control plane. Promotion outputs must point to durable `.octon/**` surfaces outside the proposal tree.
