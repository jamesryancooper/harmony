# Octon Concept Integration Validation

Validate this pack and its publication path with:

```bash
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-pack-contract.sh
bash .octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-publication-state.sh
bash .octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh
bash .octon/framework/capabilities/_ops/scripts/publish-host-projections.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-host-projections.sh
```

The extension publication validator now also checks:

- the authored prompt-set manifest
- effective prompt bundle metadata
- retained prompt alignment receipts
- prompt asset projection paths and digests
- required prompt anchor inputs in the generation lock

The deterministic prompt-bundle freshness resolver lives at:

`/.octon/framework/orchestration/runtime/_ops/scripts/resolve-extension-prompt-bundle.sh`

Use it to evaluate:

- fresh published bundle -> allow
- stale bundle in `auto` mode -> block
- stale bundle in `skip` mode -> degraded allow

For generated proposal packets emitted by the capability, also run:

```bash
bash .octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh --package <packet-path>
bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-proposal.sh --package <packet-path>
```
