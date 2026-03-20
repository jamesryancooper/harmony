# Desired Extension Configuration

`instance/extensions.yml` is the authoritative repo-owned desired
configuration surface for additive extension activation.

## Rules

- This file is desired configuration only.
- Actual active state belongs under `state/control/extensions/active.yml`.
- Quarantine and withdrawal truth belongs under
  `state/control/extensions/quarantine.yml`.
- Runtime and policy consumers use `generated/effective/extensions/**` only.

## Schema Contracts

- `schemas/instance-extensions.schema.json`
