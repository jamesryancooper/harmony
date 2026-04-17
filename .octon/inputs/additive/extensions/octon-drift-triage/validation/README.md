# Octon Drift Triage Validation

Validate the pack and its publication path with:

```bash
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-pack-contract.sh
bash .octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-publication-state.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-local-tests.sh
bash .octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh
bash .octon/framework/capabilities/_ops/scripts/publish-host-projections.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-host-projections.sh
bash .octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-state.sh
```

## Pack-Local Coverage

- `validation/tests/test-routing-matrix.sh`
  validates representative changed-path scenarios against
  `context/check-routing.yml`
- `validation/tests/test-packet-contract.sh`
  validates sample select-mode and run-mode packet fixtures against the
  extension-owned packet contract

Fixtures live under `validation/fixtures/`.

Representative scenario coverage is summarized in:

- `validation/bundle-matrix.md`

The tests are read-only and intentionally validate additive pack behavior
without publishing outputs or touching `state/control/**`.
