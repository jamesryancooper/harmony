# Runtime Resolution v1

Runtime resolution is delegated out of `/.octon/octon.yml` into an authored
selector and resolver-verified generated/effective handles.

## Canonical surfaces

- `/.octon/instance/governance/runtime-resolution.yml`
- `/.octon/generated/effective/runtime/route-bundle.yml`
- `/.octon/generated/effective/runtime/route-bundle.lock.yml`
- `/.octon/generated/effective/capabilities/pack-routes.effective.yml`
- `/.octon/generated/effective/capabilities/pack-routes.lock.yml`
- `/.octon/generated/effective/governance/support-target-matrix.yml`
- `/.octon/generated/effective/extensions/catalog.effective.yml`
- `/.octon/generated/effective/extensions/generation.lock.yml`
- `/.octon/framework/engine/runtime/spec/runtime-effective-artifact-handle-v1.md`

## Target-state rules

1. The root manifest owns only runtime-resolution anchors and spec references.
2. The instance selector owns the authoritative references to runtime-facing
   generated/effective artifacts.
3. Runtime trust resolves only through resolver-verified handles, never by raw
   string path.
4. Handle verification is fail-closed on missing or drifted source digests,
   missing or stale publication receipts, invalid non-authority
   classification, or forbidden consumer class.
5. Freshness is explicit. Accepted `freshness.mode` values are:
   `digest_bound`, `ttl_bound`, and `receipt_bound`.
6. Legacy `fresh_until` fields may be retained for compatibility only when
   ignored by v2 enforcement. They do not satisfy freshness by themselves.
7. Generated operator read models, proposal discovery, and raw inputs are
   never valid runtime authority sources.

## Required route-bundle join

The runtime route bundle joins at minimum:

- support-target matrix claim state
- compiled pack routes
- extension publication and quarantine state
- run and mission effective roots
- material side-effect inventory coverage

## Handle verification minimum

Every runtime-facing generated/effective artifact that may influence grant or
runtime routing decisions must retain:

- artifact kind
- output ref
- lock ref when the family has one
- publication receipt ref and digest
- generation id
- source refs and digests
- invalidation conditions
- freshness mode
- allowed consumers
- forbidden consumers
- `non_authority_classification: derived-runtime-handle`

## Failure rule

Grant emission fails closed when the route bundle, pack routes, support
matrix, extension catalog, or their required locks or receipts drift or are
opened outside the resolver-verified handle path.

## Canonical validators

- `/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-resolution.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-route-bundle.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-artifact-handles.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-no-raw-generated-effective-runtime-reads.sh`
