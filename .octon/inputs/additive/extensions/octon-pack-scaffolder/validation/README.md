# Octon Pack Scaffolder Validation

Validate this additive pack with:

```bash
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-pack-contract.sh
bash .octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-publication-state.sh
bash .octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh
bash .octon/framework/capabilities/_ops/scripts/publish-host-projections.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-host-projections.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-local-tests.sh
bash .octon/inputs/additive/extensions/octon-pack-scaffolder/validation/tests/test-scaffold-shapes.sh
bash .octon/inputs/additive/extensions/octon-pack-scaffolder/validation/tests/test-generated-pack-contracts.sh
# publication-only; skips unless the pack is already active and published
bash .octon/inputs/additive/extensions/octon-pack-scaffolder/validation/tests/test-published-routing-and-projections.sh
```

## Coverage

- pack contract and manifest fragment shape
- command, skill, context, and validation asset presence
- documented scaffold defaults and refusal rules
- sample generated pack outputs checked with the existing extension and
  capability publication validators in a temporary repo
- published route dispatcher metadata and host projections for the live repo
  when the pack is already admitted and published

## Ownership Rule

Apply the canonical extension ownership model from:

- `/.octon/framework/engine/governance/extensions/README.md`

Extension-local implication:

- scenarios and tests in `validation/**` validate only this pack's additive
  authoring contract
- publication, compatibility evaluation, and quarantine remain core concerns
