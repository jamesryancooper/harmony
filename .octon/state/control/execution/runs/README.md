# Run Control Roots

`state/control/execution/runs/` is the canonical mutable control root for
per-run objective binding.

Wave 1 defines the root and the objective contract family without changing the
current mission-backed runtime lifecycle. During the transitional coexistence
window:

- every consequential run should bind `run-contract.yml` under this root
- stage attempts belong under `stage-attempts/**` beneath the bound run root
- mission remains the continuity and long-horizon autonomy container
- Wave 3 will promote run-root lifecycle state to the primary execution-time
  source of truth

## Canonical Shape

```text
state/control/execution/runs/<run-id>/
  run-contract.yml
  stage-attempts/
```
