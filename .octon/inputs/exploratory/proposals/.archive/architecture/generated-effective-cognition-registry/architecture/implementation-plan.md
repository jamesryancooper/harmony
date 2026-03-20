# Implementation Plan

Packet 10 does not invent the generated class root from scratch. The live
repository already contains generated proposal discovery, generated cognition
outputs, runtime-facing locality and extension publications, and multiple
migration-era generated buckets. The remaining work is to normalize those
surfaces into one final contract and remove ambiguity about what is rebuildable
versus retained.

## Workstream 1: Lock The Generated Class Boundary

- Ratify `generated/**` as the only class root for rebuildable outputs.
- Align `.octon/README.md`, `.octon/octon.yml`,
  `.octon/instance/bootstrap/START.md`, and the umbrella architecture spec so
  they describe the same generated-versus-state boundary.
- Keep `generated/**` explicitly non-authoritative across every canonical doc
  and validation surface.

## Workstream 2: Finalize Runtime-Facing Effective Publication Families

- Preserve `generated/effective/locality/**` as the canonical compiled
  locality publication family.
- Preserve `generated/effective/extensions/**` as the canonical compiled
  extension publication family.
- Normalize `generated/effective/capabilities/**` to the final
  `routing.effective.yml` plus `artifact-map.yml` and `generation.lock.yml`
  contract in sync with Packet 12.
- Ensure every runtime-facing effective family carries one shared minimum
  generation-metadata contract.

## Workstream 3: Publish Shared Artifact-Map And Generation-Lock Contracts

- Define or update the schema family for effective `artifact-map.yml` and
  `generation.lock.yml` artifacts.
- Keep source digests, generator version, schema version, generation
  timestamp, and freshness metadata mandatory for effective publication.
- Make publication lineage inspectable enough for review, stale detection, and
  offline reproducibility without turning generated output into authority.

## Workstream 4: Normalize Cognition-Derived Output Families

- Ratify `generated/cognition/graph/**`,
  `generated/cognition/projections/definitions/**`,
  `generated/cognition/projections/materialized/**`, and
  `generated/cognition/summaries/**` as the only cognition-derived families.
- Keep graphs, projections, and summaries visibly derived from canonical
  authored and state inputs.
- Apply the ratified commit-versus-rebuild policy so summaries and projection
  definitions remain reviewable while bulkier graph and materialized outputs
  rebuild locally by default.

## Workstream 5: Preserve Proposal Discovery As A Projection Only

- Keep `generated/proposals/registry.yml` as the sole generated
  proposal-discovery surface.
- Keep the registry committed by default for discoverability and review.
- Ensure registry builders continue deriving strictly from proposal manifests
  and archive metadata rather than inventing parallel lifecycle authority.

## Workstream 6: Reclassify Migration-Era Generated Drift

- Rehome rebuildable publication-support files from `generated/artifacts/**`
  into the effective families they support or remove them when obsolete.
- Move retained validation and assurance evidence from `generated/assurance/**`
  into `state/evidence/validation/**`.
- Reclassify or retire the current `generated/effective/assurance/**` surface
  before final cutover so it no longer reads as an unexplained permanent
  effective family.
- Remove or explicitly replace any remaining free-form generated bucket that
  lacks a ratified contract.

## Workstream 7: Harden Validation And Fail-Closed Behavior

- Extend validators so every runtime-facing effective family must ship the
  publication triple and current metadata set.
- Preserve stale-generation refusal for runtime-facing effective outputs.
- Keep generated cognition outputs non-blocking for runtime unless a later
  packet declares a runtime dependency explicitly.
- Make validation receipts and retained evidence land under
  `state/evidence/**`, not `generated/**`.

## Workstream 8: Align Workflows, Scaffolds, And Review Surfaces

- Update scaffolding and architecture docs so newly generated surfaces follow
  the Packet 10 contract by default.
- Keep proposal-creation and migration workflows aligned to the ratified
  commit policy and generated boundary rules.
- Ensure review guidance explains which generated outputs are intentionally
  committed versus intentionally rebuilt.

## Workstream 9: Sync Downstream Packets

- Feed Packet 11 the final rule that summaries, graphs, and projections remain
  derived cognition outputs only.
- Feed Packet 12 the final rule that capability routing publishes only through
  `generated/effective/capabilities/**`.
- Feed Packet 14 the final rule that stale effective outputs fail closed and
  migration-era generated buckets must not persist silently.
- Feed Packet 15 the final migration inventory for rehoming or deleting
  current generated drift.

## Downstream Dependency Impact

This proposal is a prerequisite for:

- final capability-routing publication
- final memory-summary and graph/projection routing
- unified stale-generation validation
- final migration removal of extra generated buckets

## Exit Condition

This proposal is complete only when durable architecture docs, manifest
policy, validators, scaffolds, and workflow surfaces all agree that
`generated/**` is the sole rebuildable-output class root, runtime-facing
generated publication lives only under `generated/effective/**`, cognition
outputs remain derived under `generated/cognition/**`, proposal discovery lives
only under `generated/proposals/registry.yml`, and retained evidence no longer
survives inside `generated/**`.
