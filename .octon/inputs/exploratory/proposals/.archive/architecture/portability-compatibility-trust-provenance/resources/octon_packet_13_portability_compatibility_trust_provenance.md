# Packet 13 — Portability, Compatibility, Trust, and Provenance

**Proposal design packet for ratifying, normalizing, and implementing profile-driven portability, behaviorally complete export semantics, compatibility contracts, trust policy, and pack provenance inside Octon's five-class Super-Root architecture.**

## Status

- **Status:** Ratified design packet for proposal drafting
- **Proposal area:** Root portability contracts, install/export/update profiles, enabled-pack snapshot completeness, compatibility/versioning rules, trust policy, provenance, and pack origin classification
- **Implementation order:** 13 of 15 in the ratified proposal sequence
- **Primary outcome:** Deliver one explicit portability and trust contract so Octon can bootstrap, export, snapshot, update, and audit repositories without raw whole-tree copy, while preserving behaviorally complete repo snapshots whenever extension activation exists
- **Dependencies:** Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture; Packet 8 — Inputs/Additive/Extensions
- **Migration role:** Turn the current class-first manifest skeleton and extension-state surfaces into a fully normative portability and trust contract, including complete snapshot semantics, provenance requirements, and fail-closed export behavior
- **Current repo delta:** The live repo already reflects much of the ratified direction. `/.octon/octon.yml` already declares the five class roots, `versioning.harness.release_version`, `extensions.api_version`, and profile-driven portability. `/.octon/README.md` already describes `repo_snapshot` as exporting enabled-pack dependency closure. `/.octon/instance/extensions.yml` already exists as a single desired-configuration file with `selection`, `sources`, `trust`, and `acknowledgements`. `/.octon/generated/effective/extensions/catalog.effective.yml` already exists as a generated effective extension view. Packet 13 exists to make those surfaces normative, close the remaining semantic gaps, and keep future implementations from drifting back toward ambiguous export or trust behavior.

> **Packet intent:** Define the final contract for what is portable, what is repo-specific, what is exported under each profile, how compatibility is checked, how pack provenance is represented, how repo trust decisions are authored, and how Octon fails closed when a supposedly reproducible export is missing required enabled-pack payloads.

## 1. Why this proposal exists

The ratified Super-Root architecture solves the structural problem of class mixing by separating:

- portable authored core in `framework/**`
- repo-specific durable authority in `instance/**`
- raw additive and exploratory inputs in `inputs/**`
- mutable operational truth in `state/**`
- rebuildable derived outputs in `generated/**`

Packet 13 exists because that class split only becomes operationally safe when Octon also answers these questions precisely:

- What is the correct portable unit?
- What is the correct repo snapshot unit?
- When enabled extension packs exist, what must travel with a snapshot?
- Which metadata is pack-authored versus repo-authored?
- How does Octon distinguish provenance from trust?
- Which manifest keys are compatibility gates, not just documentation?
- What does it mean for a snapshot or export to be behaviorally complete?

The current repository already shows why this packet is necessary. The live root manifest includes class roots and profile names, the live README already describes profile-driven portability, and the live instance extensions file already separates desired configuration into selection, source, trust, and acknowledgement sections. But without a final packet ratifying those behaviors, the architecture still risks falling into old habits:

- treating `repo_snapshot` as a partial copy instead of a behaviorally complete export
- allowing enabled packs to be omitted without an explicit resolution mechanism
- treating pack provenance and repo trust policy as the same thing
- assuming generated extension views are enough even when raw enabled-pack payloads are absent
- slipping back toward ad hoc whole-tree copy or path-allowlist portability

Packet 13 closes those gaps.

## 2. Problem statement

Octon needs a final contract for portability, compatibility, trust, and provenance that is:

- class-root aligned
- profile-driven rather than copy-driven
- explicit about the difference between portable framework, repo-owned authority, raw pack inputs, mutable state, and generated outputs
- explicit about what makes a snapshot reproducible
- explicit about compatibility gates between the harness and extension packs
- explicit about the difference between pack-authored provenance and repo-authored trust decisions
- fail-closed when export or publication cannot reproduce enabled behavior

In the current repo baseline, many of the right pieces already exist, but they need ratification as one coherent contract. The root manifest already exposes the five-class topology and the key version fields. The README already describes profile-driven portability and behaviorally complete repo snapshots. The desired extension configuration file already uses the final one-file shape. The generated extension catalog already records a generation id and source digests. Packet 13 is the proposal that makes those surfaces normative, consistent, and validator-enforced instead of merely suggestive.

## 3. Final target-state decision summary

- Portability is **profile-driven**, not raw whole-tree copy.
- `octon.yml` is the root portability and compatibility contract.
- `framework/**` is portable by default as the core install/export unit.
- `instance/**` is repo-specific by default and only exported intentionally.
- `inputs/additive/extensions/**` is optionally portable as pack payloads.
- `inputs/exploratory/**` is non-portable by default and excluded from bootstrap and repo snapshots.
- `state/**` is never part of clean bootstrap or repo snapshot.
- `generated/**` is never the primary portability unit.
- `repo_snapshot` is **behaviorally complete** in v1 and includes:
  - `octon.yml`
  - `framework/**`
  - `instance/**`
  - all enabled extension pack payloads
  - full transitive dependency closure for enabled packs
- There is no v1 `repo_snapshot_minimal` profile.
- `pack_bundle` exports selected packs plus transitive dependency closure only.
- `instance/extensions.yml` remains a **single v1 control file** with distinct sections for selection, sources, trust, and acknowledgements.
- Compatibility is enforced through:
  - `octon.yml`
  - `framework/manifest.yml`
  - `instance/manifest.yml`
  - `inputs/additive/extensions/<pack-id>/pack.yml`
- Pack provenance travels with the pack.
- Repo trust decisions remain repo-authored and live in `instance/extensions.yml`.
- All packs use one `pack.yml` contract.
- `pack.yml` must carry `origin_class`, with allowed v1 values:
  - `first_party_bundled`
  - `first_party_external`
  - `third_party`
- Missing enabled pack payloads or unresolved dependencies cause `repo_snapshot` export failure.
- Incompatible or untrusted packs do not publish effective outputs.

## 4. Scope

This packet does all of the following:

- defines the portability classes for the five-class Super-Root
- defines the canonical install/export/update profiles
- defines behaviorally complete `repo_snapshot` semantics
- defines the compatibility model across root, framework, instance, and pack manifests
- defines the trust and provenance split between repo-authored policy and pack-authored metadata
- defines the `origin_class` model for packs
- defines export and publication failure behavior when enabled pack closure cannot be reproduced
- defines how portability and trust interact with extension publication and migration

## 5. Non-goals

This packet does **not** do any of the following:

- re-litigate the five-class Super-Root
- move raw packs out of `inputs/additive/extensions/**`
- create a separate trust-policy file in v1
- introduce an external pack registry protocol in v1
- define capability-routing ranking weights
- define generated-output commit policy outside the ratified matrix
- make proposals portable harness content
- make state or generated outputs part of clean bootstrap

## 6. Canonical paths and artifact classes

| Artifact family | Canonical path | Class root | Authority status | Notes |
|---|---|---|---|---|
| Root portability and compatibility contract | `octon.yml` | root | authoritative authored | Defines class roots, versions, profiles, and export policy |
| Framework manifest | `framework/manifest.yml` | framework | authoritative authored | Declares framework identity, supported instance schema range, bundled subsystems |
| Instance manifest | `instance/manifest.yml` | instance | authoritative authored | Declares repo-instance schema version, overlay enablement, locality binding, feature toggles |
| Desired extension configuration | `instance/extensions.yml` | instance | authoritative authored | Repo-controlled desired state |
| Pack manifest | `inputs/additive/extensions/<pack-id>/pack.yml` | inputs/additive | non-authoritative raw input | Pack identity, compatibility, provenance, origin class |
| Raw pack payloads | `inputs/additive/extensions/<pack-id>/**` | inputs/additive | non-authoritative raw input | Optional portable bundle content |
| Actual active extension state | `state/control/extensions/active.yml` | state | operational truth | Actual published extension state |
| Extension quarantine state | `state/control/extensions/quarantine.yml` | state | operational truth | Blocked packs, dependents, reasons |
| Generated extension effective outputs | `generated/effective/extensions/**` | generated | non-authoritative rebuildable | Runtime-facing published extension view |
| Proposal raw inputs | `inputs/exploratory/proposals/**` | inputs/exploratory | non-authoritative raw input | Excluded from bootstrap and repo snapshot |
| Generated proposal registry | `generated/proposals/registry.yml` | generated | non-authoritative rebuildable | Discovery aid only |

## 7. Current repo baseline and implementation delta

The live repository already reflects much of the target state that earlier packets only described aspirationally:

- `/.octon/octon.yml` already declares the five class roots, `versioning.harness.release_version`, `extensions.api_version`, and the named profiles `bootstrap_core`, `repo_snapshot`, `pack_bundle`, and `full_fidelity`.
- `/.octon/README.md` already says the top level is class-first, not domain-first, and already describes `repo_snapshot` as exporting enabled-pack dependency closure.
- `/.octon/instance/extensions.yml` already exists with the single-file v1 layout.
- `/.octon/generated/effective/extensions/catalog.effective.yml` already exists and carries generation and source-digest material.

This packet therefore does **not** invent a new direction from scratch. It ratifies and normalizes the direction the repo has already partially adopted, then makes it safe enough for implementation, export tooling, validation, and proposal ratification.

## 8. Ratified portability model

### 8.1 Portability classes

**Portable by default**

- `framework/**`
- root manifest schema and profile definitions

**Repo-specific by default**

- `instance/**`
- `state/**`
- `inputs/exploratory/**`

**Optionally portable**

- selected pack payloads under `inputs/additive/extensions/**`

**Never primary copy unit**

- `generated/**`

### 8.2 Profile semantics

| Profile | Include | Exclude | Required completeness rule |
|---|---|---|---|
| `bootstrap_core` | `octon.yml`, `framework/**`, `instance/manifest.yml` | all `inputs/**`, all `state/**`, all `generated/**` | must be sufficient to initialize a clean repo instance scaffold |
| `repo_snapshot` | `octon.yml`, `framework/**`, `instance/**`, enabled pack payloads, enabled-pack dependency closure | `inputs/exploratory/**`, `state/**`, `generated/**` | must be behaviorally complete |
| `pack_bundle` | selected packs plus dependency closure | `framework/**`, `instance/**`, `inputs/exploratory/**`, `state/**`, `generated/**` | must preserve pack dependency closure |
| `full_fidelity` | advisory only; use normal Git clone | n/a | exact repo reproduction |

### 8.3 Behaviorally complete repo snapshot

`repo_snapshot` is **complete by definition**.

That means:

1. every pack enabled in `instance/extensions.yml#selection.enabled` is included
2. every transitive dependency required by those packs is included
3. the snapshot includes the manifests needed to evaluate compatibility and trust
4. export fails closed if any required pack payload or dependency is missing

There is no v1 profile that claims to be a repo snapshot while omitting enabled pack closure.

### 8.4 What is not portable by default

The following are excluded from clean bootstrap and repo snapshots:

- `state/**`
- `generated/**`
- `inputs/exploratory/**`

Those exclusions are intentional. `state/**` is mutable operational truth, `generated/**` is rebuildable output, and exploratory proposal material is non-canonical workspace content.

## 9. Ratified compatibility model

### 9.1 Compatibility anchors

Compatibility is enforced across four layers:

1. `octon.yml`
2. `framework/manifest.yml`
3. `instance/manifest.yml`
4. `pack.yml`

### 9.2 Required root keys

`octon.yml` must include:

- `versioning.harness.release_version`
- `versioning.harness.supported_schema_versions`
- `extensions.api_version`

### 9.3 Required pack manifest compatibility fields

`pack.yml` must include a `compatibility` section that is sufficient to check at least:

- compatible harness release range
- compatible extensions API range
- any required generated-output or validator contract revisions, where the pack depends on them

### 9.4 Compatibility evaluation order

Octon must evaluate compatibility in this order:

1. root manifest sanity
2. framework and instance manifest schema compatibility
3. pack manifest schema compatibility
4. pack compatibility against harness release
5. pack compatibility against extension API version
6. dependency closure compatibility

If any step fails, publication fails and the pack cannot enter the active generation.

## 10. Ratified trust and provenance model

### 10.1 One-file desired control surface in v1

`instance/extensions.yml` remains a **single file** in v1.

Required top-level sections:

- `selection`
- `sources`
- `trust`
- `acknowledgements`

This keeps desired configuration cohesive and avoids unnecessary multi-file coupling.

### 10.2 Pack provenance

Pack-side provenance stays with the pack in `pack.yml`.

Required provenance-related fields include:

- origin information
- source identity
- version
- package digest fields or references, where available
- `origin_class`

### 10.3 Repo trust policy

Repo trust remains repo-authored. It is expressed in `instance/extensions.yml#trust`.

Trust policy may:

- allow a pack
- deny a pack
- constrain a source root
- acknowledge a quarantined or exceptional situation where policy allows that acknowledgement

Trust policy may **not** elevate a pack into governance/runtime/agency authority.

### 10.4 Pack origin classification

Every pack uses the same `pack.yml` contract.

Required `origin_class` values in v1:

- `first_party_bundled`
- `first_party_external`
- `third_party`

This avoids parallel manifest contracts while preserving provenance clarity.

## 11. Export, install, and update semantics

### 11.1 Clean bootstrap

`bootstrap_core` is the installation contract for a clean repo adoption. It installs portable framework plus the minimum instance manifest needed to initialize repo-local authority.

It must **not** carry:

- mutable state
- generated outputs
- exploratory proposal inputs
- additive packs unless separately requested

### 11.2 Repo snapshot

`repo_snapshot` is the export contract for reproducible repo-owned behavior without operational state or generated artifacts.

It must preserve:

- framework core
- repo instance authority
- enabled extension closure

It must exclude:

- exploratory proposals
- mutable state
- generated outputs

### 11.3 Pack bundle

`pack_bundle` exports only selected packs plus dependency closure. It is the correct reusable transfer unit for additive extension content.

### 11.4 Update semantics

Framework/core updates may change:

- `framework/**`
- root manifest schema/version bindings
- migration tooling and compatibility contracts

Core updates must **not** directly rewrite:

- repo continuity
- repo-local context
- proposal workspaces
- desired extension configuration

Pack updates may change:

- selected raw pack payloads
- compatibility data in `pack.yml`
- generated effective outputs after re-publication

## 12. Validation, assurance, and fail-closed implications

Validators must enforce all of the following:

- `repo_snapshot` includes enabled pack dependency closure
- missing enabled pack payloads fail export
- pack manifests expose required provenance and compatibility fields
- root manifest version keys exist and are machine-checkable
- trust policy in `instance/extensions.yml` is schema-valid
- incompatible packs do not publish effective outputs
- untrusted packs do not publish effective outputs
- generated extension effective outputs are fresh before runtime consumption

### Fail-closed rules

- export fails if a supposedly complete `repo_snapshot` is missing any enabled pack or dependency
- extension publication fails if compatibility evaluation fails
- extension publication fails if trust evaluation fails
- stale generated effective outputs fail closed for runtime and policy use
- missing provenance or malformed provenance fields block pack publication if the manifest contract requires them

## 13. Schema, manifest, and contract changes required

This packet requires updates to:

- `octon.yml`
- `framework/manifest.yml`
- `instance/manifest.yml`
- `instance/extensions.yml`
- `pack.yml`
- export tooling contracts for `bootstrap_core`, `repo_snapshot`, and `pack_bundle`
- validator contracts for enabled-pack closure and trust/compatibility checks
- any legacy documentation that still implies raw whole-tree copy or optional omission of enabled packs from repo snapshots

## 14. Migration and rollout implications

### Migration work authorized by this packet

- ratify the root manifest profile model already emerging in the repo
- make `repo_snapshot` completeness validator-enforced
- ratify `instance/extensions.yml` as the single desired-control file in v1
- add or normalize required provenance and `origin_class` fields in pack manifests
- align export tooling with the class-root architecture and the extension desired/actual/compiled split

### Sequencing

Packet 13 must land after:

- Packet 2 — Root Manifest, Profiles, and Export Semantics
- Packet 3 — Framework/Core Architecture
- Packet 4 — Repo-Instance Architecture
- Packet 8 — Inputs/Additive/Extensions

Packet 13 must land before:

- Packet 14 — Validation, Fail-Closed, Quarantine, and Staleness
- Packet 15 — Migration and Rollout

## 15. Dependencies and suggested implementation order

- **Dependencies:** Packet 2 — Root Manifest, Profiles, and Export Semantics; Packet 3 — Framework/Core Architecture; Packet 4 — Repo-Instance Architecture; Packet 8 — Inputs/Additive/Extensions
- **Suggested implementation order:** 13
- **Blocks:** final validator enforcement for extension publication, export behavior, and migration cutover

## 16. Acceptance criteria

- `octon.yml` carries ratified release/API version keys and profile semantics.
- `repo_snapshot` is defined and implemented as behaviorally complete.
- Snapshot export fails if any enabled pack or transitive dependency is missing.
- `instance/extensions.yml` remains the single desired-control file in v1.
- `pack.yml` includes `origin_class` and required provenance/compatibility fields.
- Trust and provenance are explicitly separated between repo-authored policy and pack-authored metadata.
- `bootstrap_core`, `repo_snapshot`, and `pack_bundle` are all validator-enforced.
- The repo can explain, for any artifact class, whether it is portable, repo-specific, mutable, rebuildable, or optionally portable.

## 17. Supporting evidence to reference

- `/.octon/octon.yml`
- `/.octon/README.md`
- `/.octon/instance/extensions.yml`
- `/.octon/generated/effective/extensions/catalog.effective.yml`
- `/.proposals/architecture/extensions-sidecar-pack-system/architecture/target-architecture.md` as the older sidecar baseline this packet supersedes
- Ratified Super-Root blueprint sections on manifest/profile semantics, extension architecture, portability, and validation

## 18. Settled decisions that must not be re-litigated

- The five-class Super-Root remains the final topology.
- Raw extension packs remain under `inputs/additive/extensions/**`.
- `instance/extensions.yml` remains one file in v1.
- `repo_snapshot` is behaviorally complete and includes enabled-pack dependency closure.
- There is no v1 `repo_snapshot_minimal` profile.
- Pack provenance travels with packs; repo trust stays repo-authored.
- All packs share one `pack.yml` contract.
- `origin_class` is required.
- Raw `inputs/**` paths never become runtime or policy dependencies.

## 19. Remaining narrow open questions

None. This packet is ratified for proposal drafting and ready to move into formal architecture proposal authoring.
