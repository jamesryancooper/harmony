# Packet 8 — Inputs/Additive/Extensions

**Proposal design packet for ratifying, normalizing, and implementing additive extension packs inside Octon's five-class Super-Root architecture.**

## Status

- **Status:** Ratified design packet for proposal drafting
- **Proposal area:** Raw additive pack placement, desired-versus-actual extension state, trust and compatibility boundaries, pack publication, behaviorally complete repo snapshots, and fail-closed runtime consumption
- **Implementation order:** 8 of 15 in the ratified proposal sequence
- **Primary outcome:** Integrate extension packs into `inputs/additive/extensions/**` while preserving a single authoritative super-root, repo-controlled activation through `instance/extensions.yml`, and runtime consumption only through validated compiled outputs
- **Dependencies:** Hard dependencies: Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture; Packet 5 — Overlay and Ingress Model; Packet 6 — Locality and Scope Registry; Packet 7 — State, Evidence, and Continuity. Cross-packet contract sync: Packet 13 — Portability, Compatibility, Trust, and Provenance
- **Migration role:** Replace the earlier external sidecar-pack baseline with an internal additive-input model, establish the desired/actual/quarantine/compiled extension pipeline, and make `repo_snapshot` behaviorally complete whenever extension activation exists
- **Current repo delta:** The live repo already exposes the class-first super-root, `/.octon/instance/extensions.yml`, `/.octon/state/control/extensions/active.yml`, and `/.octon/generated/effective/extensions/catalog.effective.yml`, which means the desired/actual/compiled split has begun. However, the tracked repository still retains the earlier sidecar-pack target architecture under `/.proposals/architecture/extensions-sidecar-pack-system/**`, and the integrated raw additive pack surface under `/.octon/inputs/additive/extensions/**` is not yet materially populated in the tracked tree.

> **Packet intent:** define the final contract for additive extension inputs so Octon can support reusable specialization without creating a second authority surface, without letting raw pack paths leak into runtime or policy dependencies, and without making snapshots or upgrades behaviorally ambiguous.

## 1. Why this proposal exists

The ratified Super-Root architecture solves one hard problem by adding `inputs/**` as a distinct non-authoritative class root. Packet 8 exists because additive extension packs are the most demanding occupant of that class.

Extensions are not durable repo authority. They are not mutable operational state. They are not rebuildable outputs. They are raw, reusable, pack-shaped source inputs that may alter runtime-visible capability availability only after all of the following happen successfully:

- repo-owned desired configuration enables them
- compatibility checks pass
- trust checks pass
- dependency closure resolves
- compiled effective views publish successfully
- stale or quarantined generations are excluded

That means Packet 8 must answer questions that the broader blueprint intentionally leaves to domain packets:

- What exactly is the canonical raw pack layout inside `inputs/additive/extensions/**`?
- Where is desired activation state authored?
- What is the difference between desired configuration, actual active state, quarantine state, and published compiled views?
- How are enabled packs included in export and snapshot workflows?
- How do pack provenance and trust boundaries work without giving packs authority?
- How do pack payloads stay subordinate when they can still affect runtime-visible behavior?

The live repo already demonstrates why this packet is necessary. The class-first README now states that `inputs/**` is the canonical home for non-authoritative additive and exploratory inputs, the root manifest already declares `repo_snapshot` and `pack_bundle` profiles, and `instance/extensions.yml` plus `state/control/extensions/active.yml` already exist. At the same time, the older extension architecture still survives as proposal-only material in the legacy external sidecar shape. Packet 8 is the ratified contract that turns that transition into one final model.

## 2. Problem statement

Octon needs a final extension architecture that is:

- class-root aligned
- compatible with a single authoritative super-root
- explicit about desired versus actual versus published state
- explicit about trust and compatibility boundaries
- explicit about what is portable, what is repo-owned, and what is generated
- behaviorally reproducible under `repo_snapshot`
- safe under fail-closed validation and quarantine
- understandable to humans enabling, disabling, upgrading, exporting, and auditing packs

The current repository already shows the transition pressure.

The live root manifest declares a class-first topology and profile-driven portability. The live repo already has desired extension configuration under `instance/extensions.yml`, actual active extension state under `state/control/extensions/active.yml`, and generated extension catalogs under `generated/effective/extensions/**`. But the raw integrated additive input surface is not yet materially populated in the tracked tree, while the older proposal still describes an external `/.octon.extensions/` sidecar as the raw pack home.

Without Packet 8, those facts are easy to misread in incompatible ways:

- as a half-implemented sidecar system that was never fully superseded
- as a model where `instance/extensions.yml` alone is enough to determine active behavior
- as a model where raw pack payloads are optional in snapshots even when enabled
- as a model where pack provenance and repo trust are the same thing
- as a model where active state and published effective outputs are interchangeable

Packet 8 resolves those ambiguities.

## 3. Final target-state decision summary

- Raw additive extension packs live only under `inputs/additive/extensions/**`.
- Pack payloads are non-authoritative source inputs.
- Desired repo-controlled extension configuration lives only in `instance/extensions.yml`.
- Actual active extension state lives only in `state/control/extensions/active.yml`.
- Blocked/quarantined extension state lives only in `state/control/extensions/quarantine.yml`.
- Runtime-facing extension views live only in `generated/effective/extensions/**`.
- Runtime and policy consumers may never depend on raw pack paths.
- Extension activation is published only when desired configuration, active state, quarantine state, and generated effective outputs are mutually consistent.
- `repo_snapshot` is behaviorally complete in v1 and includes all enabled packs plus transitive dependency closure.
- There is no v1 `repo_snapshot_minimal` profile.
- All packs use one `pack.yml` contract.
- `pack.yml` must carry `origin_class` with one of:
  - `first_party_bundled`
  - `first_party_external`
  - `third_party`
- Allowed v1 pack buckets are:
  - `skills/`
  - `commands/`
  - `templates/`
  - `prompts/`
  - `context/`
  - `validation/`
- Disallowed v1 pack buckets include governance, engine authority, agency authority, assurance authority, orchestration authority, services, mutable operational state, and compiled effective indexes.
- Extension effective outputs are committed by default under the ratified generated-output commit policy.

## 4. Scope

This packet does all of the following:

- defines the final placement of raw additive pack payloads
- defines the final desired/actual/quarantine/compiled extension pipeline
- defines the canonical pack manifest contract and origin marking
- defines allowed and disallowed pack content buckets
- defines the behavioral meaning of `repo_snapshot` and `pack_bundle` when packs are enabled
- defines the relationship between pack provenance, repo trust overrides, and generated effective views
- defines extension-specific validation, quarantine, and publication rules
- defines how extension content remains additive and subordinate
- defines migration from the earlier external-sidecar proposal baseline into the integrated super-root model

## 5. Non-goals

This packet does **not** do any of the following:

- re-litigate the five-class Super-Root
- re-litigate whether packs live inside `inputs/**`
- make raw packs authoritative
- make packs a second governance, runtime, or agency surface
- move desired extension configuration into raw pack space
- create a v1 external pack-registry protocol
- create a v1 minimal repo snapshot that can omit enabled pack payloads
- define final capability-routing ranking weights (Packet 12)
- define generalized provenance signing infrastructure beyond the v1 manifest fields and trust model

## 6. Canonical paths and artifact classes

**`inputs/additive/extensions/<pack-id>/pack.yml`**  
Class: Inputs/Additive  
Authority: Non-authoritative raw input  
Purpose: Pack identity, compatibility, dependencies, provenance, origin class, and content entrypoints

**`inputs/additive/extensions/<pack-id>/skills/**`**  
Class: Inputs/Additive  
Authority: Non-authoritative raw input  
Purpose: Additive specialized skills

**`inputs/additive/extensions/<pack-id>/commands/**`**  
Class: Inputs/Additive  
Authority: Non-authoritative raw input  
Purpose: Additive command wrappers

**`inputs/additive/extensions/<pack-id>/templates/**`**  
Class: Inputs/Additive  
Authority: Non-authoritative raw input  
Purpose: Pack-local scaffolding assets

**`inputs/additive/extensions/<pack-id>/prompts/**`**  
Class: Inputs/Additive  
Authority: Non-authoritative raw input  
Purpose: Pack-local prompt assets

**`inputs/additive/extensions/<pack-id>/context/**`**  
Class: Inputs/Additive  
Authority: Non-authoritative raw input  
Purpose: Pack-local reference and guidance

**`inputs/additive/extensions/<pack-id>/validation/**`**  
Class: Inputs/Additive  
Authority: Non-authoritative raw input  
Purpose: Pack-local schemas, fixtures, and checks

**`instance/extensions.yml`**  
Class: Instance  
Authority: Authoritative authored  
Purpose: Desired repo-controlled extension configuration

**`state/control/extensions/active.yml`**  
Class: State  
Authority: Operational truth  
Purpose: Actual active extension publication state

**`state/control/extensions/quarantine.yml`**  
Class: State  
Authority: Operational truth  
Purpose: Blocked packs, affected dependents, reasons, and acknowledgements

**`generated/effective/extensions/catalog.effective.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Published runtime-facing extension catalog

**`generated/effective/extensions/artifact-map.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Effective-id to concrete-source mapping

**`generated/effective/extensions/generation.lock.yml`**  
Class: Generated  
Authority: Non-authoritative rebuildable output  
Purpose: Freshness and publication receipt

## 7. Authority and boundary implications

- `framework/**` remains the base authored authority.
- `instance/**` remains the authoritative repo-owned layer.
- `instance/extensions.yml` is the authoritative desired configuration surface for extension activation.
- Raw pack payloads in `inputs/additive/**` are never authoritative.
- `state/control/extensions/**` records mutable operational truth about what is active or quarantined, not authored desired policy.
- `generated/effective/extensions/**` contains published compiled outputs, never source-of-truth.
- Trust boundaries stay in the control plane: pack provenance travels with packs, but trust overrides and enablement remain repo-controlled.
- Pack content is additive and subordinate only. No pack may redefine root policy, runtime authority, or global routing defaults.

## 8. Ratified extension input and publication model

### 8.1 Raw additive input model

Canonical raw pack placement:

```text
inputs/additive/extensions/<pack-id>/
  pack.yml
  README.md
  skills/
  commands/
  templates/
  prompts/
  context/
  validation/
```

Raw packs are source inputs only. They are not runtime-facing resolution surfaces.

### 8.2 Desired configuration model

Canonical placement:

```text
instance/extensions.yml
```

This file is the **desired authored configuration** for extension behavior.

Required top-level sections in v1:

- `selection`
- `sources`
- `trust`
- `acknowledgements`

Illustrative responsibilities by section:

- `selection`: enabled pack ids, pins, disable directives
- `sources`: source-root policy and source classification
- `trust`: repo-controlled trust overrides or tiers
- `acknowledgements`: explicit acknowledgements for quarantines or operator overrides where separately permitted

This file is the only authored repo-level extension activation surface.

### 8.3 Actual active state model

Canonical placement:

```text
state/control/extensions/active.yml
```

This file records the **actual published operational state** after validation and successful publication.

It must record at least:

- desired config revision reference
- resolved active pack set
- dependency closure
- generation id
- published effective catalog path
- published artifact-map path
- published generation-lock path
- validation timestamp
- status

This file is **not** the desired configuration. It is the operational truth of what is currently active.

### 8.4 Quarantine and withdrawal model

Canonical placement:

```text
state/control/extensions/quarantine.yml
```

This file records blocked or withdrawn packs, including:

- blocked pack ids
- affected dependents
- reason codes
- timestamps
- acknowledgements or override markers where policy allows them

Quarantine exists in state because it is mutable operational control truth, not durable authored configuration.

### 8.5 Compiled runtime-facing view model

Canonical placement:

```text
generated/effective/extensions/**
```

This directory contains the published compiled view consumed by runtime and policy surfaces.

Required outputs:

- `catalog.effective.yml`
- `artifact-map.yml`
- `generation.lock.yml`

Runtime or policy consumers may read **only** these outputs, never raw pack paths.

### 8.6 Desired / actual / quarantine / compiled consistency rule

Extension behavior may be treated as published only when all of the following are true:

1. `instance/extensions.yml` resolves successfully
2. `state/control/extensions/active.yml` references a valid published generation
3. `generated/effective/extensions/**` for that generation is fresh
4. `state/control/extensions/quarantine.yml` does not block the published set

If those conditions do not hold, Octon must fail closed or fall back to framework+instance native behavior as appropriate.

### 8.7 Allowed and disallowed pack buckets

#### Allowed v1 buckets

- `skills/`
- `commands/`
- `templates/`
- `prompts/`
- `context/`
- `validation/`

#### Disallowed v1 buckets

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

### 8.8 Pack manifest contract

Every pack uses the same `pack.yml` contract.

Required fields:

- `pack_id`
- `version`
- `compatibility`
- `dependencies`
- `provenance`
- `origin_class`
- `trust_hints`
- `content_entrypoints`

#### `origin_class`

Allowed v1 values:

- `first_party_bundled`
- `first_party_external`
- `third_party`

This keeps one pack contract while making origin explicit.

### 8.9 Behaviorally complete repo snapshot rule

`repo_snapshot` is **complete by definition**.

That means it includes:

- `octon.yml`
- `framework/**`
- `instance/**`
- all enabled pack payloads
- transitive dependency closure of enabled packs

It excludes:

- `inputs/exploratory/**`
- `state/**`
- `generated/**`

If enabled pack payloads or dependencies are missing, snapshot generation fails closed.

There is no v1 `repo_snapshot_minimal` profile.

### 8.10 Explicitly rejected extension models

The following are rejected:

- treating raw pack payloads as authoritative
- placing raw packs under `framework/**`
- placing raw packs under `instance/**`
- reading pack-relative paths directly at runtime
- making desired config and active state the same file
- treating `generated/effective/extensions/**` as source-of-truth
- allowing enabled packs to be omitted from `repo_snapshot`
- using divergent manifest contracts for first-party versus third-party packs

## 9. Schema, manifest, and contract changes required

### Required manifest and schema families

- `instance/extensions.yml` schema with sections:
  - `selection`
  - `sources`
  - `trust`
  - `acknowledgements`
- `state/control/extensions/active.yml` schema
- `state/control/extensions/quarantine.yml` schema
- `generated/effective/extensions/catalog.effective.yml` schema
- `generated/effective/extensions/artifact-map.yml` schema
- `generated/effective/extensions/generation.lock.yml` schema
- unified `pack.yml` schema with `origin_class`

### Related contracts that must be updated

- `octon.yml` profile model so `repo_snapshot` includes enabled-pack dependency closure and `pack_bundle` includes dependency closure
- framework extension governance contracts under `framework/engine/governance/extensions/**`
- generated-output commit policy so extension effective outputs are committed by default
- capability-routing contract so extension routing consumes generated effective views only
- migration contracts so legacy external sidecar guidance cannot remain normative after cutover

## 10. Validation, assurance, and fail-closed implications

Validation must enforce all of the following:

- raw pack payloads live only under `inputs/additive/extensions/**`
- no raw pack path is used as a runtime or policy dependency
- pack manifests satisfy `pack.yml` schema requirements
- pack content uses only allowed buckets
- pack content does not introduce disallowed authority/state surfaces
- dependency closure resolves for all enabled packs
- compatibility checks pass against the root manifest
- trust policy passes for all enabled packs
- `state/control/extensions/active.yml` matches a fresh published generation
- `state/control/extensions/quarantine.yml` is visible and consulted during publication
- `repo_snapshot` export fails if any enabled pack or dependency is missing

### Fail-closed behavior

- invalid desired configuration blocks extension publication
- invalid pack compilation quarantines the failed pack and any dependents
- if a coherent surviving effective set exists, Octon publishes that surviving set and records the quarantine
- if no coherent surviving set exists, Octon withdraws extension contributions and falls back to framework+instance native behavior
- stale generated extension outputs fail closed
- missing enabled-pack payloads during snapshot export fail closed

## 11. Portability, compatibility, and trust implications

- `inputs/additive/extensions/**` is optionally portable.
- `instance/extensions.yml` is repo-specific by default.
- `state/control/extensions/**` is never bootstrap-portable.
- `generated/effective/extensions/**` is rebuildable, but committed by default under the ratified commit policy.
- Pack provenance travels with the pack in `pack.yml`.
- Repo trust overrides do **not** travel automatically with packs; they remain in `instance/extensions.yml`.
- Compatibility is checked against root manifest values such as:
  - `versioning.harness.release_version`
  - `extensions.api_version`

## 12. Migration and rollout implications

### Migration work authorized by this packet

- internalize the extension raw input model under `inputs/additive/extensions/**`
- ratify `instance/extensions.yml` as desired config
- ratify `state/control/extensions/{active,quarantine}.yml` as actual and quarantined control state
- ratify `generated/effective/extensions/**` as the only runtime-facing extension surface
- update export semantics so `repo_snapshot` is complete by definition
- replace legacy sidecar-pack normative guidance with the integrated super-root model

### Important sequencing rules

Packet 8 must land after:

- Packet 1 — Super-Root Semantics and Taxonomy
- Packet 2 — Root Manifest, Profiles, and Export Semantics
- Packet 3 — Framework/Core Architecture
- Packet 4 — Repo-Instance Architecture
- Packet 5 — Overlay and Ingress Model
- Packet 6 — Locality and Scope Registry
- Packet 7 — State, Evidence, and Continuity

Packet 8 must land before:

- Packet 10 — Generated / Effective / Cognition / Registry
- Packet 12 — Capability Routing and Host Integration
- Packet 13 — Portability, Compatibility, Trust, and Provenance
- Packet 14 — Validation, Fail-Closed, Quarantine, and Staleness
- Packet 15 — Migration and Rollout

### Explicit migration rule

Do not ship internalized packs into `inputs/additive/extensions/**` until:

- the raw-input dependency ban is enforced
- the desired/actual/quarantine/compiled split is schema-backed
- `repo_snapshot` completeness behavior is ratified and implemented

## 13. Dependencies and suggested implementation order

- **Dependencies:** Packet 1 — Super-Root Semantics and Taxonomy; Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture; Packet 5 — Overlay and Ingress Model; Packet 6 — Locality and Scope Registry; Packet 7 — State, Evidence, and Continuity; cross-packet contract sync with Packet 13 — Portability, Compatibility, Trust, and Provenance
- **Suggested implementation order:** 8
- **Blocks:** generated effective extension publication, capability-routing cutover, portability/trust ratification, validation cutover, and final migration completion

## 14. Acceptance criteria

- Raw additive extension packs live only under `inputs/additive/extensions/**`.
- `instance/extensions.yml` is explicitly ratified as desired authored configuration.
- `state/control/extensions/active.yml` is explicitly ratified as actual active extension state.
- `state/control/extensions/quarantine.yml` is explicitly ratified as blocked/quarantined extension state.
- Runtime and policy consumers read only `generated/effective/extensions/**`.
- `repo_snapshot` includes enabled pack dependency closure by default.
- Missing enabled packs or dependencies cause snapshot export failure.
- The same `pack.yml` contract is used for first-party and third-party packs.
- `origin_class` is present and validator-enforced.
- Enabled extension behavior can be explained using one coherent desired/actual/quarantine/compiled model.
- Teams no longer need to infer whether pack selection, trust, runtime activation, or generated publication belong to the same surface.

## 15. Supporting evidence to reference

- Current `/.octon/README.md` — class-first super-root statement and profile-driven portability baseline
- Current `/.octon/octon.yml` — live root manifest, profile skeleton, release/API version keys, and raw-input dependency policy
- Current `/.octon/instance/extensions.yml` — live desired extension configuration surface
- Current `/.octon/state/control/extensions/active.yml` — live actual active-state surface
- Current `/.octon/generated/effective/extensions/catalog.effective.yml` — live generated extension catalog surface
- Current `/.proposals/architecture/extensions-sidecar-pack-system/architecture/target-architecture.md` — legacy sidecar-pack baseline that this packet supersedes
- Ratified Super-Root blueprint — sections on extension architecture, profile completeness, desired/actual/quarantine split, portability, validation, and commit policy

## 16. Settled decisions that must not be re-litigated

- Raw extension packs live under `inputs/additive/extensions/**`.
- `instance/extensions.yml` remains the single desired-config file in v1.
- `state/control/extensions/active.yml` is actual active state, not desired configuration.
- `state/control/extensions/quarantine.yml` is mutable quarantine state.
- `generated/effective/extensions/**` is the only runtime-facing extension surface.
- Raw pack paths never become direct runtime or policy dependencies.
- `repo_snapshot` is behaviorally complete in v1.
- There is no v1 `repo_snapshot_minimal`.
- All packs share one `pack.yml` contract.
- `origin_class` is explicit and required.
- Extension packs remain additive and subordinate only.

## 17. Remaining narrow open questions

None. This packet is ratified for proposal drafting and ready to move into formal architecture proposal authoring.
