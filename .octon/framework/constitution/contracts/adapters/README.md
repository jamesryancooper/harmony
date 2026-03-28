# Constitutional Adapter Contracts

`/.octon/framework/constitution/contracts/adapters/**` defines the
constitutional contract family for host adapters and model adapters.

## Wave 5 Status

Wave 5 hardens adapters as explicit, replaceable boundaries.

- host adapters project interaction and host signals into the runtime, but
  they do not mint authority
- model adapters shape model-family integration, but they do not widen support
  beyond declared support targets
- adapter conformance remains subordinate to
  `/.octon/instance/governance/support-targets.yml`

## Canonical Files

- `family.yml`
- `host-adapter-v1.schema.json`
- `model-adapter-v1.schema.json`
- `adapter-conformance-v1.schema.json`

## Runtime Projection Roots

- host adapter manifests:
  `/.octon/framework/engine/runtime/adapters/host/**`
- model adapter manifests:
  `/.octon/framework/engine/runtime/adapters/model/**`
