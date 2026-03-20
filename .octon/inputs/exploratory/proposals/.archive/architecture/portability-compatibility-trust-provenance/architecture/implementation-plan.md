# Implementation Plan

This proposal is a contract-tightening phase for the already ratified
super-root architecture. The remaining work is to make the live manifests,
pack contracts, publication pipeline, validators, and operator guidance agree
on one portability and trust model.

## Workstream 1: Finalize The Root And Companion Manifest Contract

- Treat `.octon/octon.yml` as the authoritative portability and compatibility
  contract for profile semantics, harness release compatibility, supported
  schema versions, and the extension API version.
- Keep `framework/manifest.yml` and `instance/manifest.yml` as required
  companion manifests for framework-scoped and repo-scoped compatibility
  checks.
- Remove any remaining transitional language that treats profile keys as
  informational rather than validator-enforced.

## Workstream 2: Normalize Desired Trust Policy And Pack Provenance

- Keep `instance/extensions.yml` as the single desired-control surface in v1.
- Ensure the `selection`, `sources`, `trust`, and `acknowledgements` sections
  remain schema-valid and sufficient for repo-authored trust decisions.
- Normalize `pack.yml` so every pack exposes the required identity,
  `origin_class`, compatibility, dependency, provenance, and content-entrypoint
  fields.
- Preserve one shared `pack.yml` contract across bundled and external packs.

## Workstream 3: Enforce Behaviorally Complete Export Semantics

- Tighten `repo_snapshot` so enabled packs and full dependency closure are
  exported by selection rather than implied by broad path copy.
- Tighten `pack_bundle` so it exports only selected packs plus dependency
  closure.
- Keep `bootstrap_core` minimal and free of raw inputs, state, and generated
  outputs.
- Keep `full_fidelity` advisory only and route exact reproduction to Git clone
  semantics.

## Workstream 4: Tighten Compatibility, Trust, And Publication Gates

- Enforce the ratified compatibility evaluation order from root manifest
  sanity through dependency-closure compatibility.
- Enforce the trust-versus-provenance split so repo trust policy never becomes
  pack-authored and pack provenance never becomes runtime policy by itself.
- Block incompatible or untrusted packs from entering the active published
  generation.
- Require fresh compiled extension outputs and coherent active/quarantine state
  before runtime or policy consumers may treat the publication as valid.

## Workstream 5: Align Docs, Governance, And Architecture Surfaces

- Update `.octon/README.md` and `.octon/instance/bootstrap/START.md` so
  portability guidance stays aligned with the ratified profile contract.
- Update architecture references such as
  `framework/cognition/_meta/architecture/specification.md`,
  `shared-foundation.md`, and
  `framework/engine/governance/extensions/trust-and-compatibility.md` so they
  describe the same portability, trust, and provenance boundaries.
- Remove or archive any lingering documentation that implies optional enabled
  pack omission, whole-tree portability, or merged trust/provenance authority.

## Workstream 6: Add Validator And Workflow Cutover Gates

- Extend validator surfaces under `.octon/framework/assurance/runtime/**` to
  reject incomplete repo snapshots, missing pack provenance, invalid trust
  policy, incompatible packs, and raw-input dependency violations.
- Extend export and publication workflows under
  `.octon/framework/orchestration/runtime/workflows/**` to enforce the
  behaviorally complete `repo_snapshot` and dependency-closed `pack_bundle`
  contract.
- Ensure migration and rollout workflows treat snapshot completeness and trust
  enforcement as hard cutover gates rather than operator suggestions.

## Downstream Dependency Impact

This proposal constrains downstream work in:

- validation and quarantine semantics
- migration rollout
- extension publication tooling
- export tooling
- capability-routing consumption of compiled extension outputs

Downstream proposals may extend the implementation detail, but they may not
weaken behavioral completeness, trust separation, or the fail-closed
compatibility contract.

## Exit Condition

This proposal is complete only when the canonical manifests, pack contracts,
validators, workflows, and operator docs all agree on the same
profile-driven portability model, the same compatibility gates, and the same
trust-versus-provenance split.
