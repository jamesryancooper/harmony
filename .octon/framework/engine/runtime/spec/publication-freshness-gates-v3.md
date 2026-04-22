# Publication Freshness Gates v3

Runtime-facing generated/effective outputs are valid only through
resolver-verified handles with explicit freshness semantics.

## Required checks

1. output exists,
2. lock exists when the publication family has a lock,
3. publication receipt exists and matches generation id, result, and published
   path,
4. current source digests match the digests declared by the handle or lock,
5. `freshness.mode` is explicit and valid,
6. invalidation conditions are retained and evaluated,
7. allowed-consumer and forbidden-consumer posture is explicit,
8. `non_authority_classification` remains `derived-runtime-handle`,
9. generated cognition, generated proposals, raw inputs, and compatibility
   projections are rejected as runtime authority sources,
10. support, pack, and extension state do not widen beyond canonical sources.

## Accepted freshness modes

- `digest_bound`
  Trust is valid only while all declared source digests remain equal.
- `ttl_bound`
  Trust is valid only while the explicit TTL window remains open.
- `receipt_bound`
  Trust is valid only while the referenced publication receipt remains current
  for the published generation.

Legacy `fresh_until` timestamps may be retained for compatibility readers, but
they do not satisfy v3 freshness without an explicit `freshness.mode`.

## Minimum covered outputs

At minimum, v3 applies to:

- `/.octon/generated/effective/runtime/route-bundle.yml`
- `/.octon/generated/effective/capabilities/pack-routes.effective.yml`
- `/.octon/generated/effective/extensions/catalog.effective.yml`
- `/.octon/generated/effective/governance/support-target-matrix.yml`
- `/.octon/generated/effective/capabilities/routing.effective.yml`

## Runtime behavior

- stale or missing runtime-effective handle: deny
- missing or drifted publication receipt: deny
- root-manifest or selector digest drift: deny
- raw path bypass of runtime-facing generated/effective output: deny
- fake far-future freshness used as trust: deny
- quarantined or unpublished extension state in a runtime route: deny
- pack widening beyond admitted tuple: deny

## Canonical validators

- `/.octon/framework/assurance/runtime/_ops/scripts/validate-publication-freshness-gates.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-generated-effective-freshness.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-artifact-handles.sh`
