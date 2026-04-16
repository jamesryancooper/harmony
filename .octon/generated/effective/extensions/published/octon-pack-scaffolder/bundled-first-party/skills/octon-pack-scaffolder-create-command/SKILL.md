---
name: octon-pack-scaffolder-create-command
description: >
  Scaffold a pack-local command markdown file and its manifest fragment entry.
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

# Octon Pack Scaffolder Create Command

Create a thin pack-local command surface under `commands/`.

## When To Use

- the target pack needs a stable slash-command entrypoint
- the command should stay thin and operator-facing
- the execution behavior should remain in a corresponding skill or prompt set

## Core Workflow

1. Validate `pack_id` and `command_id`.
2. Create `commands/<command-id>.md`.
3. Insert or create the matching entry in `commands/manifest.fragment.yml`.
4. Keep lexical ordering by command id.
5. Fail closed on conflicting existing content.

## Boundaries

- Additive only.
- Do not create repo-native commands.
- Do not embed governance or runtime authority into the command markdown.
- Do not overwrite divergent existing content.

## References

- `references/phases.md`
- `references/io-contract.md`
- `references/validation.md`
