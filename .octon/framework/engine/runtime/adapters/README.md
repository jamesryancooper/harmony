# Engine Runtime Adapters

`runtime/adapters/` holds replaceable runtime adapter manifests.

- `host/` describes host-facing adapter surfaces such as shells or projection
  control planes
- `model/` describes live model-family adapter surfaces only

These manifests are non-authoritative runtime projections of the constitutional
adapter family. Support claims remain bounded by
`/.octon/instance/governance/support-targets.yml`.

Experimental or quarantined adapter manifests do not belong in
`runtime/adapters/**`; they must remain outside the live runtime adapter tree,
for example under `inputs/exploratory/**`, until explicitly admitted.
