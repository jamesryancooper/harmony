---
name: octon-pack-scaffolder-create-pack
description: >
  Scaffold a new additive extension pack root with the minimal commands,
  skills, context, and validation surfaces.
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

# Octon Pack Scaffolder Create Pack

Create a new raw extension pack root under
`/.octon/inputs/additive/extensions/<pack-id>/`.

## When To Use

- a new additive extension pack is needed
- the target pack root does not exist yet or is only partially initialized
- the work should stay entirely inside raw extension-pack inputs

## Core Workflow

1. Validate `pack_id`, `version`, and `origin_class`.
2. Create the pack root and required MVP buckets.
3. Materialize `pack.yml`, `README.md`, fragment files, and
   `validation/compatibility.yml` using `context/output-shapes.md`.
4. Create empty `templates/`, `prompts/`, `validation/scenarios/`, and
   `validation/tests/` directories for future pack-local content.
5. Fail closed on conflicting existing content and report the exact paths.

## Boundaries

- Additive only.
- Do not add the pack to `instance/extensions.yml`.
- Do not publish or validate the pack automatically.
- Do not create any governance, runtime, or generated artifacts.

## References

- `references/phases.md`
- `references/io-contract.md`
- `references/validation.md`
