# Additive Extension Inputs

`inputs/additive/extensions/**` is the canonical raw-input surface for additive
extension packs.

## Placement Rules

- Raw packs live only under `inputs/additive/extensions/<pack-id>/`.
- Raw packs are non-authoritative source inputs only.
- Runtime and policy consumers must never read raw pack paths directly.
- Pack payloads remain additive and subordinate to `framework/**` and
  `instance/**`.

## Canonical Pack Layout

```text
inputs/additive/extensions/<pack-id>/
  pack.yml
  README.md
  skills/
  commands/
  templates/
  prompts/
  context/
  validation/
```

## Schema Contracts

- `schemas/extension-pack.schema.json`
