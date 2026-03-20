# Implementation Plan

Packet 8 does not introduce a second extension authority surface. The live
repository already contains the core desired, active, quarantine, and
generated extension surfaces. The remaining work is to harden the integrated
input contract, populate the raw pack surface safely, and retire the
superseded sidecar baseline.

## Workstream 1: Lock The Canonical Extension Surfaces

- Ratify `inputs/additive/extensions/**` as the only legal raw extension-pack
  placement.
- Align `.octon/README.md`, `.octon/instance/bootstrap/START.md`, and the
  umbrella architecture spec so they describe the same desired/actual/
  quarantine/compiled split.
- Preserve `instance/extensions.yml` as the single desired authored extension
  configuration file in v1.

## Workstream 2: Finalize The Unified Pack Contract

- Define and publish the unified `pack.yml` schema, including required
  `origin_class`.
- Encode allowed bucket entrypoints and disallowed content classes into
  validator-enforced contracts.
- Preserve one manifest contract for bundled, external first-party, and
  third-party packs so origin is explicit without fragmenting schema shape.

## Workstream 3: Internalize Raw Additive Packs Safely

- Populate `inputs/additive/extensions/**` only after the raw-input
  dependency ban, schema-backed split, and snapshot completeness rules are
  enforced.
- Re-express any reusable extension material from the legacy sidecar proposal
  inside the ratified additive buckets.
- Keep raw pack payloads free of services, authority surfaces, mutable state,
  and compiled effective indexes.

## Workstream 4: Harden Publication And Runtime Consumption

- Keep `state/control/extensions/active.yml` and
  `generated/effective/extensions/**` in an atomic publication relationship.
- Ensure runtime and policy consumers read generated effective extension views
  only.
- Publish artifact maps and generation locks that make effective-to-source
  mapping, freshness, and generation lineage inspectable.

## Workstream 5: Align Snapshot, Export, And Trust Semantics

- Update root-manifest and export workflows so `repo_snapshot` remains
  behaviorally complete whenever packs are enabled.
- Keep `pack_bundle` dependency-closed for selected packs.
- Preserve the split where pack provenance travels with `pack.yml` while repo
  trust overrides remain in `instance/extensions.yml`.
- Align compatibility checks with the root-manifest release and extension API
  version contract used by the live repository.

## Workstream 6: Enforce Validation, Quarantine, And Fail-Closed Behavior

- Reject wrong-class placement, raw-path runtime dependencies, invalid
  manifests, disallowed content, stale publication, and incomplete snapshot
  payloads.
- Quarantine failed packs and affected dependents under
  `state/control/extensions/quarantine.yml`.
- Permit publication of a surviving set only when it remains dependency-closed
  and trust-valid.
- Withdraw extension contributions entirely when no coherent surviving set
  exists.

## Workstream 7: Retire The Legacy Sidecar Baseline

- Keep the old `.octon.extensions/` proposal as historical input only while
  Packet 8 promotion is incomplete.
- Remove normative references that still describe the sidecar as the intended
  runtime-pack home.
- Cut downstream routing, validation, and host integration surfaces over to
  the integrated `inputs/additive/extensions/**` model before archival.

## Downstream Dependency Impact

This proposal is a prerequisite for:

- generated effective extension publication and artifact-map hardening
- capability-routing cutover to generated extension views only
- portability, compatibility, trust, and provenance ratification for packs
- unified validation, quarantine, and stale-generation refusal
- final migration and rollout removal of the superseded sidecar path

## Exit Condition

This proposal is complete only when durable architecture docs, pack schemas,
validators, export workflows, runtime consumers, and extension input
population all converge on one integrated additive extension model and the
legacy sidecar proposal no longer reads as an alternate active architecture.
