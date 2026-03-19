# Validation

## Gate Results

- `test-validate-overlay-points.sh`: PASS (`Passed: 5`, `Failed: 0`)
- `test-validate-bootstrap-ingress.sh`: PASS (`Passed: 3`, `Failed: 0`)
- `test-validate-repo-instance-boundary.sh`: PASS (`Passed: 4`, `Failed: 0`)
- `validate-overlay-points.sh`: PASS (`errors=0`)
- `validate-bootstrap-ingress.sh`: PASS (`errors=0`)
- `validate-repo-instance-boundary.sh`: PASS (`errors=0`)
- `validate-companion-manifests.sh`: PASS (`errors=0`)
- `validate-bootstrap-projections.sh`: PASS (`errors=0`)
- `validate-agency.sh`: PASS (`errors=0 warnings=0`)
- `sync-runtime-artifacts.sh --check --target projections --target evidence --target evaluations --target knowledge --target decisions`: PASS
- `alignment-check.sh --profile harness`: PASS (`errors=0`)

## Contract Assertions Verified

- The live repo now fails closed on disabled overlay roots with real content.
- The live repo now fails closed on ad hoc overlay-like paths outside the four
  ratified overlay roots.
- Root `AGENTS.md` and `CLAUDE.md` are validated as symlink/parity-copy
  adapters rather than permissive string-matching shells.
- Bootstrap/scaffolding projections now enforce both projected bootstrap
  directories through the canonical bootstrap manifest.
- The cognition runtime-artifact generator now resolves the live
  `instance/**` and `generated/**` cognition surfaces rather than the retired
  `framework/cognition/runtime/**` path set.
- Packet 5 control-plane docs explicitly enumerate instance-native and
  overlay-capable surfaces, the four ratified overlay points, merge modes,
  precedence, and adapter rules.
- ADR 049 is published in the generated decisions summary at
  `/.octon/instance/cognition/context/shared/decisions.md`.
