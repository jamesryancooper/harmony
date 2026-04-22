# Runtime Effective Artifact Handle v1

This contract defines the resolver-verified handle model for runtime-facing
generated/effective artifacts.

## Purpose

Generated/effective outputs remain derived non-authority. Runtime may consume
them only through a handle that proves provenance, freshness, and allowed
consumer class.

## Supported artifact kinds

- `runtime_route_bundle`
- `pack_routes`
- `support_matrix`
- `extension_catalog`
- `capability_routing`

## Required handle fields

- `schema_version`
- `artifact_kind`
- `generation_id`
- `output_ref`
- `output_sha256`
- `lock_ref` when the family has a lock
- `lock_sha256` when the family has a lock
- `publication_receipt_ref`
- `publication_receipt_sha256`
- `source_refs`
- `source_digests`
- `freshness.mode`
- `freshness.invalidation_conditions`
- `allowed_consumers`
- `forbidden_consumers`
- `non_authority_classification`

## Freshness modes

- `digest_bound`
  The handle is current only while the declared source digests remain equal to
  the live source digests.
- `ttl_bound`
  The handle is current only while the declared TTL window remains open.
- `receipt_bound`
  The handle is current only while the linked publication receipt remains the
  current receipt for the referenced generation.

`fresh_until` alone is insufficient. Legacy timestamp fields may exist for
compatibility readers, but v1 handle enforcement requires an explicit
`freshness.mode`.

## Consumer rules

- Runtime may consume `generated/effective/**` only through this handle model.
- Validators may use the handle model to prove freshness and provenance.
- Operators may inspect handle metadata, but that inspection remains
  non-authoritative.
- Generated cognition read models, proposal packets, and raw inputs are never
  valid handle consumers for runtime authority.

## Failure rules

Reject the handle when any of the following is true:

- source digests drift
- output or lock digest drifts
- publication receipt is missing, digest-drifted, or reports a different
  generation
- `non_authority_classification` is not `derived-runtime-handle`
- the caller is not in `allowed_consumers`
- the caller is in `forbidden_consumers`
- freshness-mode validation fails

## Related contracts

- `/.octon/framework/engine/runtime/spec/runtime-resolution-v1.md`
- `/.octon/framework/engine/runtime/spec/runtime-effective-route-bundle-lock-v2.schema.json`
- `/.octon/framework/engine/runtime/spec/publication-freshness-gates-v3.md`
