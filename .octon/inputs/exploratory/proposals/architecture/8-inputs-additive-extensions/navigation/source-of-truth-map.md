# Source Of Truth Map

## Canonical Authority

| Concern | Source of truth | Notes |
| --- | --- | --- |
| Super-root class placement and raw-input dependency ban | `.octon/README.md` and `.octon/framework/cognition/_meta/architecture/specification.md` | `inputs/**` remains non-authoritative and raw pack paths never become direct runtime or policy dependencies |
| Root-manifest profile semantics for extension portability | `.octon/octon.yml` | Defines `repo_snapshot`, `pack_bundle`, fail-closed raw-input dependency policy, and the live extension API version key |
| Raw additive extension-pack payloads | `.octon/inputs/additive/extensions/<pack-id>/**` | Canonical raw pack placement for active additive inputs; pack payloads remain source inputs only |
| Desired extension selection, source policy, trust, and acknowledgements | `.octon/instance/extensions.yml` | Single repo-authored desired configuration surface with `selection`, `sources`, `trust`, and `acknowledgements` |
| Actual active extension publication state | `.octon/state/control/extensions/active.yml` | Mutable operational truth for the validated active set and published generation references |
| Extension quarantine and withdrawal state | `.octon/state/control/extensions/quarantine.yml` | Mutable operational truth for blocked packs, affected dependents, reason codes, and acknowledgements |
| Runtime-facing compiled extension view | `.octon/generated/effective/extensions/{catalog.effective.yml,artifact-map.yml,generation.lock.yml}` | Only runtime-facing extension surface; never source-of-truth |
| Unified pack manifest contract | `.octon/inputs/additive/extensions/<pack-id>/pack.yml` | One manifest contract for bundled and third-party packs, including required `origin_class` |
| Commit policy for extension effective outputs | `.octon/framework/cognition/_meta/architecture/specification.md` plus the ratified blueprint bundle in `resources/` | Effective outputs remain non-authoritative but committed by default |
| Legacy external sidecar baseline | `.octon/inputs/exploratory/proposals/.archive/architecture/extensions-sidecar-pack-system/**` | Historical archived proposal input only; superseded by this integrated `inputs/additive/extensions/**` model |

## Derived Or Enforced Projections

| Concern | Derived path or enforcement surface | Notes |
| --- | --- | --- |
| Extension publication freshness and source mapping | `.octon/generated/effective/extensions/{artifact-map.yml,generation.lock.yml}` | Carries compiled source mapping, freshness, and publication receipt metadata for the active generation |
| Fail-closed validation of pack shape, placement, and publication state | `.octon/framework/assurance/runtime/**` | Validators reject wrong-class placement, invalid pack manifests, disallowed content buckets, stale publication, and missing snapshot payloads |
| Export and snapshot behavior for enabled packs | `.octon/framework/orchestration/runtime/workflows/meta/export-harness/` | Export workflows must honor behaviorally complete `repo_snapshot` and `pack_bundle` dependency-closure semantics |
| Runtime and host integration | `.octon/generated/effective/extensions/**` and downstream capability-routing consumers | Later runtime and host adapters must consume generated effective views only, not raw pack paths |
| Proposal discovery for this temporary package | `.octon/generated/proposals/registry.yml` | Derived non-authoritative registry entry for proposal discovery while this package is active |

## Boundary Rules

- `instance/extensions.yml` is authored desired configuration only. It does
  not become actual publication truth.
- `state/control/extensions/{active,quarantine}.yml` is mutable operational
  truth only. It does not author durable repo policy.
- `generated/effective/extensions/**` is the only runtime-facing extension
  surface. Runtime and policy consumers must not read raw pack paths.
- `inputs/additive/extensions/**` is the only legal raw pack home. Pack
  payloads remain additive and subordinate to `framework/**` and `instance/**`
  authority.
- Repo trust overrides remain in `instance/extensions.yml`; pack provenance
  travels with `pack.yml`.
- `repo_snapshot` is behaviorally complete. Enabled packs and their transitive
  dependency closure are mandatory payload, not optional add-ons.
- The legacy `.octon.extensions/` sidecar proposal remains proposal-only
  material and must not be interpreted as an active authority or runtime
  model.
