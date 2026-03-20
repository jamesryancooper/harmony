# Source Of Truth Map

## Canonical Authority

| Concern | Source of truth | Notes |
| --- | --- | --- |
| Root portability profiles, harness release compatibility, supported schema versions, extension API version, raw-input dependency policy, and generated-staleness policy | `.octon/octon.yml` | Authoritative super-root manifest for portability and compatibility gates |
| Framework identity, bundled policy sets, generator set, overlay registry binding, and supported instance schema range | `.octon/framework/manifest.yml` | Required framework-scoped companion manifest for compatibility evaluation |
| Repo-instance identity, enabled overlay points, locality binding, and feature toggles | `.octon/instance/manifest.yml` | Required instance-scoped companion manifest for repo-specific bindings and schema compatibility |
| Desired extension selection, source policy, trust policy, and acknowledgements | `.octon/instance/extensions.yml` | Single repo-authored desired-control surface in v1 |
| Pack identity, origin classification, compatibility, dependencies, provenance, and content entrypoints | `.octon/inputs/additive/extensions/<pack-id>/pack.yml` | Unified raw pack manifest contract for bundled and external packs |
| Human-readable portability guidance | `.octon/README.md` and `.octon/instance/bootstrap/START.md` | Must describe profile-driven portability and behaviorally complete snapshots rather than whole-tree copy |
| Root architecture and extension portability rules | `.octon/framework/cognition/_meta/architecture/specification.md`, `.octon/framework/cognition/_meta/architecture/shared-foundation.md`, and `.octon/framework/engine/governance/extensions/trust-and-compatibility.md` | Canonical architecture and governance surfaces after promotion; proposal content remains temporary |

## Derived Or Enforced Projections

| Concern | Derived path or enforcement surface | Notes |
| --- | --- | --- |
| Actual active extension publication state | `.octon/state/control/extensions/active.yml` | Mutable operational truth for the currently published pack set and generation references |
| Extension quarantine and withdrawal state | `.octon/state/control/extensions/quarantine.yml` | Mutable operational truth for blocked packs, affected dependents, reasons, and acknowledgements |
| Runtime-facing compiled extension publication | `.octon/generated/effective/extensions/{catalog.effective.yml,artifact-map.yml,generation.lock.yml}` | Runtime and policy consumers read only the compiled validated publication family |
| Export completeness and profile validation | `.octon/framework/orchestration/runtime/workflows/**` and `.octon/framework/assurance/runtime/**` | Export and validator surfaces must enforce behaviorally complete `repo_snapshot`, dependency-closed `pack_bundle`, and fail-closed boundary rules |
| Proposal discovery for this temporary package | `.octon/generated/proposals/registry.yml` | Derived non-authoritative registry entry for proposal discovery while this package is active |

## Boundary Rules

- `framework/**` and `instance/**` remain the only authored authority
  surfaces.
- `state/**` remains authoritative only as operational truth and retained
  evidence.
- `generated/**` remains rebuildable and non-authoritative even when committed.
- Portability is profile-driven. There is no default whole-tree copy model.
- `repo_snapshot` is behaviorally complete by definition and must include the
  enabled pack dependency closure whenever extension activation exists.
- `pack_bundle` may move raw pack payloads, but only as selected packs plus
  dependency closure.
- `inputs/exploratory/**`, `state/**`, and `generated/**` remain excluded from
  `bootstrap_core` and `repo_snapshot`.
- Pack provenance travels with `pack.yml`; repo trust decisions remain in
  `instance/extensions.yml`.
- Raw `inputs/**` paths may be exported under the ratified profiles, but they
  must never become direct runtime or policy dependencies.
- Untrusted, incompatible, stale, or malformed pack publications do not become
  active runtime-facing extension behavior.
