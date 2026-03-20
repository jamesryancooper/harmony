# Target Architecture

## Decision

Ratify one portability, compatibility, trust, and provenance contract across
the super-root control plane where:

- portability is profile-driven rather than raw whole-tree copy
- `/.octon/octon.yml` is the authoritative portability and compatibility
  contract
- `framework/**` is the default portable authored core
- `instance/**` is repo-specific by default and exports only under explicit
  profiles
- `inputs/additive/extensions/**` is optionally portable as raw pack payload
  under the ratified profile model
- `inputs/exploratory/**`, `state/**`, and `generated/**` do not participate
  in clean bootstrap or `repo_snapshot`
- `repo_snapshot` is behaviorally complete and includes enabled-pack payloads
  plus full transitive dependency closure
- there is no v1 `repo_snapshot_minimal`
- `pack_bundle` exports only selected packs plus dependency closure
- compatibility is enforced across `octon.yml`, `framework/manifest.yml`,
  `instance/manifest.yml`, and `pack.yml`
- pack provenance travels with `pack.yml`
- repo trust decisions remain in `instance/extensions.yml`
- every pack uses one `pack.yml` contract with required `origin_class`
- export and publication fail closed when required payloads, compatibility,
  trust, freshness, or provenance requirements are not met

This proposal turns the partially implemented live direction into a normative
contract so bootstrap, export, update, publication, and audit behavior remain
reproducible and machine-enforceable.

## Status

- status: accepted proposal drafted from ratified Packet 13 inputs
- proposal area: portability profiles, behaviorally complete snapshots,
  manifest compatibility, trust policy, provenance, and pack origin
  classification
- implementation order: 13 of 15 in the ratified proposal sequence
- dependencies:
  - `root-manifest-profiles-and-export-semantics`
  - `framework-core-architecture`
  - `repo-instance-architecture`
  - `inputs-additive-extensions`
- cross-packet contract sync:
  - `capability-routing-host-integration`
  - `validation-fail-closed-quarantine-staleness`
  - `migration-rollout`
- migration role: turn the live class-root manifest skeleton and extension
  control surfaces into the final normative portability and trust contract,
  including complete snapshot semantics, provenance requirements, and
  fail-closed export behavior

## Why This Proposal Exists

Packet 2 established profile-driven install and export semantics. Packet 8
established the desired/actual/quarantine/compiled extension split and the raw
placement of additive packs. Packet 13 closes the remaining architectural gap:
the system still needs one explicit contract for what is portable, what is
repo-specific, how enabled behavior is exported, which manifest fields are
hard compatibility gates, and how provenance differs from trust.

Without this contract, the repository can drift back toward the behaviors the
ratified blueprint rejected:

- treating `repo_snapshot` as best-effort rather than behaviorally complete
- omitting enabled pack payloads while still claiming reproducible export
- collapsing pack-authored provenance into repo-authored trust policy
- treating generated extension views as sufficient when raw enabled payloads
  are absent
- letting portability semantics regress into ad hoc path allowlists or
  whole-tree copy guidance

The live repository already reflects much of the target state. Packet 13 is
not inventing a new direction from scratch; it is normalizing and tightening a
direction the repo has already partially adopted.

### Current Live Signals This Proposal Must Normalize

| Current live signal | Current live source | Ratified implication |
| --- | --- | --- |
| The root manifest already uses the v2 super-root topology and profile model with `versioning.harness.release_version`, `supported_schema_versions`, and `versioning.extensions.api_version` | `.octon/octon.yml` | These fields must be treated as normative portability and compatibility gates rather than suggestive metadata |
| The repo already documents `repo_snapshot` as exporting enabled-pack dependency closure | `.octon/README.md` and `.octon/instance/bootstrap/START.md` | Behavioral completeness must remain the contract, not just operator guidance |
| Desired extension control already lives in one file with `selection`, `sources`, `trust`, and `acknowledgements` | `.octon/instance/extensions.yml` | The v1 one-file desired-control model is already live and must remain authoritative |
| Pack manifests already carry `origin_class`, compatibility, provenance, and trust hints | `.octon/inputs/additive/extensions/<pack-id>/pack.yml` | The unified `pack.yml` contract is already in motion and must become the only pack portability and provenance surface |
| Actual active and quarantine state already live outside desired configuration | `.octon/state/control/extensions/{active.yml,quarantine.yml}` | Publication truth must remain operational state, not be collapsed back into authored config |
| Runtime-facing extension output already publishes as a generated effective catalog with source digests and generation id | `.octon/generated/effective/extensions/catalog.effective.yml` | Trust and compatibility decisions must gate compiled publication rather than letting runtime inspect raw pack paths |
| The current repo has seeded packs but no active enabled set | `.octon/instance/extensions.yml` plus `.octon/inputs/additive/extensions/**` | Portability and completeness rules must be explicit even when the live active set is empty today |

## Problem Statement

Octon needs one final contract for portability, compatibility, trust, and
provenance that is:

- aligned to the five-class super-root
- profile-driven rather than copy-driven
- explicit about portable authored core versus repo-owned authority versus raw
  pack input versus mutable state versus rebuildable output
- explicit about what makes a snapshot or export behaviorally complete
- explicit about which manifest keys are compatibility gates
- explicit about the difference between pack-authored provenance and
  repo-authored trust policy
- explicit about how export and publication fail closed when reproducibility or
  safety cannot be proven

Without that contract, install, export, update, publication, and audit paths
remain vulnerable to ambiguous behavior and future drift.

## Scope

- define portability classes for the five-class super-root
- define the canonical install, export, and update profiles relevant to
  portability and trust
- define behaviorally complete `repo_snapshot` semantics
- define the compatibility model across root, framework, instance, and pack
  manifests
- define the trust and provenance split between repo-authored policy and
  pack-authored metadata
- define the required `origin_class` model for packs
- define export and publication failure behavior when enabled-pack closure
  cannot be reproduced or published safely
- define how portability and trust interact with the desired/actual/quarantine
  /compiled extension pipeline

## Non-Goals

- re-litigating the five-class super-root
- moving raw packs out of `inputs/additive/extensions/**`
- splitting `instance/extensions.yml` into multiple authored files in v1
- introducing an external pack registry protocol in v1
- defining capability-routing ranking weights
- making proposals portable harness content
- making state or generated outputs part of clean bootstrap
- weakening fail-closed export or publication behavior to accommodate partial
  snapshots

## Canonical Portability Contract

### Portability Classes

| Artifact family | Canonical surface | Portability status | Notes |
| --- | --- | --- | --- |
| Portable authored core | `framework/**` | Portable by default | Core install and export unit for Octon framework behavior |
| Root portability and compatibility contract | `octon.yml` | Portable by profile | Always included where profile semantics require control metadata |
| Repo-owned durable authority | `instance/**` | Repo-specific by default | Travels only when a profile explicitly includes repo-instance authority |
| Raw additive pack payloads | `inputs/additive/extensions/**` | Optionally portable | Exported only through `repo_snapshot` or `pack_bundle` under dependency-closure rules |
| Raw exploratory proposal material | `inputs/exploratory/**` | Non-portable by default | Excluded from bootstrap and repo snapshots |
| Mutable operational truth and retained evidence | `state/**` | Never bootstrap-portable | Excluded from clean bootstrap and repo snapshots |
| Rebuildable generated outputs | `generated/**` | Never primary portability unit | Committed per policy matrix, but not the canonical export basis |

### Ratified Profile Contract

| Profile | Includes | Excludes | Required behavior |
| --- | --- | --- | --- |
| `bootstrap_core` | `octon.yml`, `framework/**`, `instance/manifest.yml` | All `inputs/**`, all `state/**`, all `generated/**` | Must be sufficient to initialize a clean repo-instance scaffold without importing raw packs, proposals, or mutable runtime state |
| `repo_snapshot` | `octon.yml`, `framework/**`, `instance/**`, enabled pack payloads, enabled-pack dependency closure | `inputs/exploratory/**`, `state/**`, `generated/**` | Must be behaviorally complete and fail closed when payload closure is incomplete |
| `pack_bundle` | Selected packs plus dependency closure | `framework/**`, `instance/**`, `inputs/exploratory/**`, `state/**`, `generated/**` | Must preserve dependency-complete additive payload transfer without claiming repo snapshot semantics |
| `full_fidelity` | Advisory only | n/a | Exact repo reproduction uses a normal Git clone rather than a synthetic export payload |

### Behaviorally Complete `repo_snapshot`

`repo_snapshot` is complete by definition.
It is not a best-effort export and it is not a partial copy profile.

The export contract requires:

1. `octon.yml` to travel with the snapshot.
2. All of `framework/**` to travel with the snapshot.
3. All of `instance/**` to travel with the snapshot.
4. Every enabled pack referenced by `instance/extensions.yml#selection.enabled`
   to travel with the snapshot.
5. The full transitive dependency closure of those enabled packs to travel
   with the snapshot.
6. The manifests needed to evaluate trust, compatibility, and dependency
   closure to travel with the snapshot.

Export fails closed when:

- an enabled pack payload is missing
- a required transitive dependency is missing
- the manifest set needed to evaluate the enabled-pack closure is malformed or
  incomplete

Future support for externally resolvable pack sources may add a different
profile later, but it does not change the meaning of `repo_snapshot` in v1.

## Canonical Compatibility Contract

### Compatibility Anchors

Compatibility is enforced across four layers:

1. `octon.yml`
2. `framework/manifest.yml`
3. `instance/manifest.yml`
4. `inputs/additive/extensions/<pack-id>/pack.yml`

No other surface may act as a parallel compatibility authority in v1.

### Required Root Compatibility Keys

`octon.yml` must carry at least:

- `versioning.harness.release_version`
- `versioning.harness.supported_schema_versions`
- `versioning.extensions.api_version`

The live v2 root manifest already exposes these fields.
This proposal makes them normative gates for validators, publishers, and
export workflows.

### Required Pack Compatibility Fields

Each `pack.yml` must expose a compatibility block sufficient to evaluate at
least:

- harness release compatibility
- extensions API compatibility
- any required validator or generated-output contract revisions when the pack
  depends on them

The exact field names may remain schema-versioned in Octon's manifest style.
The live `compatibility.octon_version` and
`compatibility.extensions_api_version` fields are semantically within this
contract.

### Compatibility Evaluation Order

Octon must evaluate compatibility in this order:

1. Root manifest sanity.
2. Framework and instance manifest schema compatibility.
3. Pack manifest schema compatibility.
4. Pack compatibility against the harness release.
5. Pack compatibility against the extensions API version.
6. Dependency-closure compatibility.

If any step fails, the failing pack does not enter the published active
generation.
A coherent surviving set may still publish only if quarantine and active-state
rules permit it.

## Canonical Trust And Provenance Contract

### One Desired-Control Surface In V1

`instance/extensions.yml` remains the single desired authored control surface
in v1.

Its required top-level sections are:

- `selection`
- `sources`
- `trust`
- `acknowledgements`

This keeps desired configuration cohesive and avoids unnecessary multi-file
coordination.

### Pack-Authored Provenance

Pack-side provenance stays with the pack in `pack.yml`.

Required provenance-related semantics include:

- source identity
- pack version
- origin metadata
- digest, import, or attestation references where available
- `origin_class`

The pack may suggest trust hints, but it does not author repo trust policy.

### Repo-Authored Trust

Repo trust policy remains repo-authored and lives in
`instance/extensions.yml#trust`.

Trust policy may:

- allow a pack or origin class
- deny a pack or origin class
- constrain a source root or source identifier
- record acknowledgements where policy requires them

Trust policy may not:

- elevate a pack into framework or instance authority
- bypass compatibility checks
- turn raw pack paths into runtime or policy authority

### Required `origin_class`

All packs use the same `pack.yml` contract.
`origin_class` is required and allowed v1 values are:

- `first_party_bundled`
- `first_party_external`
- `third_party`

This preserves one uniform pack contract while keeping provenance explicit and
machine-checkable.

### Trust Versus Provenance Split

| Concern | Pack-authored | Repo-authored | Operationally derived |
| --- | --- | --- | --- |
| Identity and version | `pack.yml` | no | published into effective views |
| Origin classification and provenance | `pack.yml` | no | surfaced through artifact maps and generation locks |
| Desired enablement and source policy | no | `instance/extensions.yml` | resolved into active state |
| Trust allow/deny/acknowledgement policy | no | `instance/extensions.yml` | enforced into active or quarantine state |
| Active publication truth | no | no | `state/control/extensions/{active,quarantine}.yml` |
| Runtime-facing extension behavior | no | no | `generated/effective/extensions/**` |

## Export, Install, And Update Semantics

### Clean Bootstrap

`bootstrap_core` is the clean adoption contract.
It carries the portable authored framework plus the minimal instance manifest
needed to initialize repo-local authority.

It must not carry:

- mutable state
- generated outputs
- exploratory proposal inputs
- additive packs unless separately requested through another profile

### Repo Snapshot

`repo_snapshot` is the behaviorally complete export contract for reproducible
repo-owned behavior without mutable state or generated artifacts.

It preserves:

- framework core
- repo-instance authority
- enabled-pack payload closure

It excludes:

- exploratory proposals
- mutable state
- generated outputs

### Pack Bundle

`pack_bundle` is the reusable transport unit for additive content.
It exports only selected packs plus dependency closure.
It does not claim to be a full repo portability profile.

### Update Semantics

Framework and control-plane updates may change:

- `framework/**`
- root manifest version bindings
- companion manifest contracts
- validators, export workflows, and migration contracts

Framework and control-plane updates must not directly rewrite:

- repo continuity
- repo-local context
- proposal workspaces
- desired extension configuration

Pack updates may change:

- raw pack payloads
- `pack.yml` compatibility and provenance metadata
- compiled effective outputs after re-publication

## Validation, Publication, And Fail-Closed Implications

Validators and publishers must enforce all of the following:

- `repo_snapshot` includes enabled-pack dependency closure
- missing enabled pack payloads fail export
- pack manifests expose required compatibility and provenance fields
- root manifest version keys exist and are machine-checkable
- trust policy in `instance/extensions.yml` is schema-valid
- incompatible packs do not publish effective outputs
- untrusted packs do not publish effective outputs
- stale generated effective outputs fail closed for runtime and policy use
- missing or malformed required provenance blocks pack publication when the
  manifest contract requires it

Publication consistency rules remain:

1. Desired state resolves from `instance/extensions.yml`.
2. Actual published truth records in `state/control/extensions/active.yml`.
3. Blocked or withdrawn sets record in `state/control/extensions/quarantine.yml`.
4. Runtime-facing behavior reads only
   `generated/effective/extensions/**`.

Publication of `active.yml` and `generated/effective/extensions/**` must remain
atomic so exported repo behavior and runtime-visible behavior resolve against
the same validated generation.

## Migration And Downstream Impact

This proposal is tightening work, not a topology rewrite.
The repo already reflects much of the ratified direction, so the remaining
work is mainly to remove ambiguity and make validator behavior match the live
docs and manifests.

Downstream impact:

- Packet 14 must inherit the fail-closed rules defined here for portability,
  trust, provenance, freshness, and quarantine.
- Packet 15 must treat behaviorally complete snapshot export as a hard cutover
  gate.
- Capability-routing and host-integration work must continue to consume only
  compiled extension publications rather than raw pack payloads.
- Future pack-acquisition work may add new source-resolution mechanisms, but
  it may not weaken the meaning of `repo_snapshot` in v1.

## Exit Condition

This proposal is complete only when the durable manifests, pack contracts,
validators, export workflows, and operator guidance all agree on the same
profile-driven portability model, the same trust-versus-provenance split, and
the same fail-closed rules for snapshot completeness and extension
publication.
