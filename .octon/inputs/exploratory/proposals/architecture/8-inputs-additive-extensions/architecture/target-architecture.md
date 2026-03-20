# Target Architecture

## Decision

Ratify additive extension packs as integrated raw inputs under
`/.octon/inputs/additive/extensions/**` and make the extension activation model
explicitly four-layered:

- desired repo-authored configuration in `instance/extensions.yml`
- actual active operational truth in `state/control/extensions/active.yml`
- mutable quarantine and withdrawal truth in
  `state/control/extensions/quarantine.yml`
- runtime-facing compiled publication in `generated/effective/extensions/**`

The promoted Packet 8 contract requires:

- raw additive extension packs to live only under
  `inputs/additive/extensions/<pack-id>/**`
- all packs to use one `pack.yml` contract with explicit `origin_class`
- `instance/extensions.yml` to remain the single desired authored extension
  configuration file in v1
- `state/control/extensions/active.yml` to record the current validated
  published extension set and generated publication references
- `state/control/extensions/quarantine.yml` to record blocked packs, affected
  dependents, reason codes, and acknowledgements
- runtime and policy consumers to read only
  `generated/effective/extensions/{catalog.effective.yml,artifact-map.yml,generation.lock.yml}`
- `repo_snapshot` to include all enabled pack payloads and their transitive
  dependency closure by definition
- missing enabled pack payloads, incompatible packs, untrusted packs, stale
  generations, and raw-path runtime dependencies to fail closed
- extension packs to remain additive and subordinate rather than becoming a
  second governance, engine, agency, assurance, or state authority surface

This proposal replaces the older external-sidecar baseline with the integrated
super-root model already implied by the live repository.

## Status

- status: accepted proposal drafted from ratified Packet 8 inputs
- proposal area: raw additive pack placement, desired versus actual extension
  state, trust and compatibility boundaries, behaviorally complete snapshots,
  and fail-closed runtime consumption
- implementation order: 8 of 15 in the ratified proposal sequence
- dependencies:
  - `super-root-semantics-and-taxonomy`
  - `root-manifest-profiles-and-export-semantics`
  - `framework-core-architecture`
  - `repo-instance-architecture`
  - `overlay-and-ingress-model`
  - `locality-and-scope-registry`
  - `state-evidence-continuity`
- cross-packet contract sync:
  - `portability-compatibility-trust-and-provenance`
- migration role: replace the legacy `.octon.extensions/` sidecar target with
  internal additive inputs, ratify the desired/actual/quarantine/compiled
  split, and make `repo_snapshot` behaviorally complete whenever extension
  activation exists

## Why This Proposal Exists

Packets 1 through 7 already established the class-root topology, profile
model, repo-owned authority layer, overlay model, locality rules, and
state/evidence/control boundary. Packet 8 is the point where additive raw
input becomes the hardest case of that architecture.

Extension packs are not authored repo authority. They are not mutable
operational truth. They are not rebuildable generated outputs. They are raw,
reusable inputs that may influence runtime-visible capability availability
only after desired configuration resolves, trust and compatibility checks
pass, dependency closure is complete, and a fresh compiled generation
publishes successfully.

The live repository already exposes the beginning of that model:

- `.octon/instance/extensions.yml` already exists with the ratified v1
  sections: `selection`, `sources`, `trust`, and `acknowledgements`.
- `.octon/state/control/extensions/{active,quarantine}.yml` already exists as
  the operational extension control plane.
- `.octon/generated/effective/extensions/catalog.effective.yml` already exists
  as a compiled runtime-facing extension catalog.
- `.octon/octon.yml` already defines `repo_snapshot` to include
  `inputs/additive/extensions/<enabled-and-dependent>/**` and `pack_bundle` to
  include dependency closure.

What remains is ambiguity, because the tracked repository still retains the
older external sidecar proposal while the raw integrated pack surface is not
yet materially populated.

### Current Live Signals This Proposal Must Normalize

| Current live signal | Current live source | Ratified implication |
| --- | --- | --- |
| Desired configuration already exists as one authored file with the Packet 8 section split | `.octon/instance/extensions.yml` | The proposal must preserve one desired-config file in v1 rather than splitting selection and trust into multiple authored files |
| Actual active extension state already exists independently from desired configuration | `.octon/state/control/extensions/active.yml` | Desired and actual state are already distinct and must stay distinct |
| Quarantine already exists as mutable extension control truth | `.octon/state/control/extensions/quarantine.yml` | Quarantine belongs in state, not in raw pack space or desired config |
| Runtime-facing extension publication already exists as a generated catalog | `.octon/generated/effective/extensions/catalog.effective.yml` | Runtime and policy surfaces should consume generated effective outputs only |
| The root manifest already treats enabled packs as snapshot payload | `.octon/octon.yml` | `repo_snapshot` completeness is already implied and must be ratified explicitly |
| The repo keeps the older `.octon.extensions/` design only as archived historical proposal material | `.octon/inputs/exploratory/proposals/.archive/architecture/extensions-sidecar-pack-system/**` | Packet 8 supersedes the external-sidecar baseline and removes it from the active architecture set |
| The integrated raw input surface exists structurally but not materially | `.octon/inputs/additive/extensions/` | Internalized pack placement is the canonical target even before pack population is complete |

## Problem Statement

Octon needs a final extension architecture that is:

- class-root aligned
- compatible with one authoritative super-root
- explicit about desired versus actual versus quarantine versus compiled state
- explicit about trust, compatibility, and provenance boundaries
- explicit about what is portable, what is repo-owned, and what is generated
- behaviorally reproducible under `repo_snapshot`
- safe under fail-closed validation, quarantine, and stale-generation refusal
- understandable to operators enabling, disabling, upgrading, exporting, and
  auditing extension packs

Without Packet 8, the repository invites incompatible readings:

- that the legacy sidecar model is still the intended runtime architecture
- that `instance/extensions.yml` alone determines active extension behavior
- that enabled pack payloads may be omitted from `repo_snapshot`
- that pack provenance and repo trust overrides are the same thing
- that raw pack layout is a runtime lookup surface instead of a raw input
  source

## Scope

- define the canonical raw additive extension-pack placement
- define the desired/actual/quarantine/compiled extension publication model
- define the unified `pack.yml` contract and required `origin_class`
- define allowed and disallowed pack content buckets
- define behaviorally complete `repo_snapshot` and dependency-closed
  `pack_bundle` semantics when packs are enabled
- define the trust, compatibility, provenance, and publication boundaries for
  packs
- define extension-specific validation, quarantine, and fail-closed behavior
- define migration from the legacy sidecar proposal into the integrated
  super-root model

## Non-Goals

- re-litigating the five-class super-root
- re-litigating whether packs live inside `inputs/**`
- turning raw packs into authored governance, runtime, or policy authority
- moving desired configuration into raw pack space
- creating a v1 external registry protocol for acquiring packs
- creating a v1 `repo_snapshot_minimal` profile
- defining final capability-routing ranking weights
- defining generalized signature infrastructure beyond the v1 provenance and
  trust contract

## Canonical Additive Extension Model

### Raw Additive Pack Placement

Active pack payloads live only at:

```text
inputs/additive/extensions/
  <pack-id>/
    pack.yml
    README.md
    skills/
    commands/
    templates/
    prompts/
    context/
    validation/
  .archive/
```

`inputs/additive/extensions/<pack-id>/**` is raw input only. It is not a
runtime-facing resolution surface and it does not become an authority layer.

### Desired Configuration

Desired authored configuration lives only at:

```text
instance/extensions.yml
```

Required top-level sections in v1 are:

- `selection`
- `sources`
- `trust`
- `acknowledgements`

Responsibilities remain:

- `selection` for enabled ids, pins, and disable directives
- `sources` for source-root policy and classification
- `trust` for repo-controlled trust tiers or overrides
- `acknowledgements` for quarantine or operator acknowledgement records where
  policy allows them

### Actual Active State

Actual active publication truth lives only at:

```text
state/control/extensions/active.yml
```

It must record at least:

- desired configuration revision reference
- resolved active pack set
- dependency closure
- generation id
- published effective catalog path
- published artifact-map path
- published generation-lock path
- validation timestamp
- publication status

This file is operational truth. It is not the desired configuration surface.

### Quarantine And Withdrawal State

Quarantine and withdrawal truth lives only at:

```text
state/control/extensions/quarantine.yml
```

It must record at least:

- blocked pack ids
- affected dependents
- reason codes
- timestamps
- acknowledgements or override markers where policy allows them

### Compiled Runtime-Facing View

Runtime and policy consumers may read only:

```text
generated/effective/extensions/
  catalog.effective.yml
  artifact-map.yml
  generation.lock.yml
```

These outputs are rebuildable, non-authoritative, and committed by default
under the ratified generated-output commit policy.

### Desired Versus Actual Versus Quarantine Versus Compiled Consistency

Extension behavior may be treated as published only when all of the following
hold:

1. `instance/extensions.yml` resolves successfully.
2. `state/control/extensions/active.yml` references a valid published
   generation.
3. `generated/effective/extensions/**` for that generation is fresh.
4. `state/control/extensions/quarantine.yml` does not block the published set.

If those conditions do not hold, Octon must fail closed or withdraw extension
contributions and fall back to framework-plus-instance native behavior as
appropriate.

## Pack Contract And Content Boundaries

### Unified `pack.yml` Contract

Every pack uses the same manifest contract at:

```text
inputs/additive/extensions/<pack-id>/pack.yml
```

Required fields are:

- `pack_id`
- `version`
- `compatibility`
- `dependencies`
- `provenance`
- `origin_class`
- `trust_hints`
- `content_entrypoints`

Allowed v1 `origin_class` values are:

- `first_party_bundled`
- `first_party_external`
- `third_party`

The repository must not split manifest shape by pack origin. Bundled and
third-party packs share one validator-enforced contract.

### Allowed V1 Buckets

Allowed additive content buckets are:

- `skills/`
- `commands/`
- `templates/`
- `prompts/`
- `context/`
- `validation/`

### Disallowed V1 Buckets

Disallowed pack content includes:

- governance contracts
- practices guidance
- methodology surfaces
- `agency/` authority
- `orchestration/` authority
- `engine/` authority
- assurance authority
- services and runtime service contracts
- mutable operational state
- compiled effective indexes

Packs remain additive and subordinate. They may extend runtime-visible
capability availability only through compiled generated views, never by
shadowing root authority or injecting raw stateful side surfaces.

## Snapshot, Export, And Portability Semantics

### Behaviorally Complete `repo_snapshot`

`repo_snapshot` is complete by definition. It includes:

- `octon.yml`
- `framework/**`
- `instance/**`
- all enabled pack payloads
- transitive dependency closure of enabled packs

It excludes:

- `inputs/exploratory/**`
- `state/**`
- `generated/**`

If any enabled pack payload or dependency is missing, snapshot generation must
fail closed.

There is no v1 `repo_snapshot_minimal` profile.

### `pack_bundle`

`pack_bundle` includes:

- selected extension pack payloads
- transitive dependency closure of selected packs

It excludes framework, instance, exploratory proposal inputs, state, and
generated outputs.

### Portability, Compatibility, Trust, And Provenance

- raw packs under `inputs/additive/extensions/**` are optionally portable
- `instance/extensions.yml` is repo-specific by default
- `state/control/extensions/**` is never bootstrap-portable
- `generated/effective/extensions/**` is rebuildable but committed by default
- pack provenance travels with `pack.yml`
- repo trust overrides do not travel automatically with packs
- compatibility checks bind against the root-manifest release and extension API
  version contract, with the live repository currently expressing that as
  `versioning.harness.release_version` and
  `versioning.extensions.api_version` in `.octon/octon.yml`

## Boundary Rules And Rejected Models

### Boundary Rules

| Surface | Authority status | What it may own | What it may not own |
| --- | --- | --- | --- |
| `framework/**` | Authored authority | Base runtime, governance, and overlay declarations | Repo-local pack selection, pack trust overrides, raw pack payloads |
| `instance/**` | Authored authority | Desired extension configuration and repo-controlled trust policy | Actual active state, quarantine truth, rebuildable publication |
| `inputs/additive/extensions/**` | Non-authoritative raw input | Pack payloads, manifests, provenance, and pack-local assets | Direct runtime resolution, authored root policy, mutable control state |
| `state/control/extensions/**` | Operational truth | Active publication truth and quarantine truth | Desired authored policy or raw pack payload ownership |
| `generated/effective/extensions/**` | Rebuildable output | Compiled runtime-facing extension view and source mapping | Source-of-truth or mutable control truth |

### Explicitly Rejected Models

Rejected models include:

- raw pack payloads as authoritative policy or runtime surfaces
- raw pack placement under `framework/**` or `instance/**`
- direct runtime or policy reads from pack-relative raw paths
- treating desired configuration and active state as the same file
- treating generated effective outputs as source-of-truth
- omitting enabled pack payloads from `repo_snapshot`
- using divergent manifest contracts for bundled versus third-party packs
- continuing to treat the legacy `.octon.extensions/` sidecar as the intended
  runtime architecture after Packet 8 promotion

## Validation And Fail-Closed Behavior

Validation must enforce all of the following:

- raw pack payloads live only under `inputs/additive/extensions/**`
- pack manifests satisfy the unified `pack.yml` schema
- `origin_class` is present and valid
- pack content uses only allowed buckets
- disallowed authority, service, state, or compiled-output surfaces do not
  appear inside raw pack payloads
- dependency closure resolves for all enabled packs
- compatibility checks pass against the root manifest
- trust checks pass for all enabled packs
- `state/control/extensions/active.yml` matches a fresh published generation
- `state/control/extensions/quarantine.yml` is visible during publication
- runtime and policy consumers do not read raw pack paths
- `repo_snapshot` export fails if an enabled pack or required dependency is
  missing

Fail-closed behavior is:

- invalid desired configuration blocks publication
- invalid pack compilation quarantines the failed pack and any dependents
- when a coherent surviving extension set exists, Octon may publish that
  surviving set and record the quarantine
- when no coherent surviving set exists, Octon withdraws extension
  contributions and falls back to framework-plus-instance native behavior
- stale generated extension outputs are refused
- missing enabled pack payloads during snapshot export block export

## Migration And Rollout Sequence

Packet 8 promotion is authorized to:

- internalize the raw extension input model under
  `inputs/additive/extensions/**`
- ratify `instance/extensions.yml` as desired config
- ratify `state/control/extensions/{active,quarantine}.yml` as actual and
  quarantine truth
- ratify `generated/effective/extensions/**` as the only runtime-facing
  extension surface
- update export semantics so `repo_snapshot` is complete by definition
- replace the legacy sidecar-pack normative guidance with the integrated
  super-root model

The sequencing rules remain binding:

1. land Packets 1 through 7 first
2. keep the raw-input dependency ban fail-closed
3. make the desired/actual/quarantine/compiled split schema-backed
4. ratify and implement behaviorally complete snapshot semantics
5. only then materially populate `inputs/additive/extensions/**`
6. cut downstream routing and host integrations over to generated effective
   extension views
7. retire legacy sidecar guidance once durable architecture, validators, and
   workflows no longer depend on it

The live repository is already partway through that migration. The remaining
work is contract hardening, raw pack internalization, validator alignment, and
retirement of the superseded sidecar baseline.
