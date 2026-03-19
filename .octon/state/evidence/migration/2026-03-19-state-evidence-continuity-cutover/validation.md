# Validation

## Gate Results

- `test-validate-locality-registry.sh`: PASS (`Passed: 9`, `Failed: 0`)
- `test-validate-continuity-memory.sh`: PASS (`Passed: 8`, `Failed: 0`)
- `validate-state-surface-alignment.sh`: PASS
- `validate-locality-registry.sh`: PASS (`errors=0`)
- `validate-continuity-memory.sh`: PASS (`errors=0`, `warnings=6` for empty
  retained run directories only)
- `validate-locality-publication-state.sh`: PASS (`errors=0`)
- `validate-extension-publication-state.sh`: PASS (`errors=0`)
- `validate-context-overhead-budget.sh`: PASS (`checked=52`, `warnings=0`)
- `validate-harness-structure.sh`: PASS (`errors=0 warnings=0`)
- `validate-framework-core-boundary.sh`: PASS (`errors=0`)
- `alignment-check.sh --profile harness`: PASS (`errors=0`)

## Contract Assertions Verified

- Declared scope continuity is now legal and enforced under
  `state/continuity/scopes/<scope-id>/**`.
- Undeclared scope continuity directories fail validation.
- Quarantined scopes may not carry live continuity.
- Retained decision and run evidence remain under `state/evidence/**` and are
  no longer described as continuity child surfaces in active docs.
- `state/control/extensions/{active,quarantine}.yml` and
  `state/control/locality/quarantine.yml` remain the canonical Packet 7
  control-state records.
- Packet 7 state-surface drift is now checked directly by the harness
  alignment profile.
- Context-overhead validation now reads live Packet 7 run receipts from
  `state/evidence/runs/**` instead of silently skipping a non-existent legacy
  path.
- Canonical `ops_mutation_policy.allow_write_roots` now includes
  `state/continuity/**` rather than the repo-only continuity path.
- Active skill metadata no longer advertises the legacy
  `continuity/runs/**/evidence/**` surface as a source of run evidence.
