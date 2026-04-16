---
name: octon-pack-scaffolder-create-validation-fixture
description: >
  Scaffold a pack-local validation scenario fixture describing expected
  additive outputs for one scaffold target.
license: MIT
compatibility: Designed for Octon additive extension-pack authoring.
metadata:
  author: Octon Framework
  created: "2026-04-15"
  updated: "2026-04-15"
skill_sets: [executor, specialist]
capabilities: [self-validating, idempotent]
allowed-tools: Read Glob Grep Write(/.octon/inputs/additive/extensions/*)
---

# Octon Pack Scaffolder Create Validation Fixture

Create a validation scenario fixture under `validation/scenarios/`.

## When To Use

- the target pack needs a new scenario fixture for additive validation
- the fixture should describe preconditions, invocation, and expected outputs
- the fixture should stay pack-local and non-authoritative

## Core Workflow

1. Validate `pack_id`, `fixture_id`, and `target_kind`.
2. Create `validation/scenarios/<fixture-id>.md`.
3. Materialize the scenario using the fixture shape in
   `context/output-shapes.md`.
4. Keep publication, compatibility receipts, and quarantine behavior out of the
   fixture itself.
5. Fail closed on conflicting existing content.

## Boundaries

- Additive only.
- Do not write runtime state or generated receipts.
- Do not move validation into framework-owned assurance surfaces.
- Do not overwrite divergent existing content.

## References

- `references/phases.md`
- `references/io-contract.md`
- `references/validation.md`
