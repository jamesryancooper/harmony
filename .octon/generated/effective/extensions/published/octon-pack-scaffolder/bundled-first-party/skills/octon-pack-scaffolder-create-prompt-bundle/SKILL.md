---
name: octon-pack-scaffolder-create-prompt-bundle
description: >
  Scaffold a minimal manifest-governed prompt bundle inside an additive
  extension pack.
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

# Octon Pack Scaffolder Create Prompt Bundle

Create a minimal prompt bundle under
`/.octon/inputs/additive/extensions/<pack-id>/prompts/<bundle-id>/`.

## When To Use

- the target pack needs a first pack-local prompt bundle
- a bundle should stay leaf-sized with one stage in MVP
- no routing contract or prompt freshness machinery is required yet

## Core Workflow

1. Validate `pack_id`, `bundle_id`, and `stage_id`.
2. Rebind `pack.yml` `content_entrypoints.prompts` to `prompts/` when it is
   still `null`.
3. Create the bundle root plus `stages/`, `companions/`, and `references/`.
4. Materialize `README.md`, `manifest.yml`,
   `companions/01-align-bundle.md`, `stages/01-<stage-id>.md`, and
   `references/bundle-contract.md`.
5. Keep the manifest limited to one stage, one minimal companion, and no
   shared refs.
6. Fail closed on conflicting existing content.

## Boundaries

- Additive only.
- Do not add `context/routing.contract.yml`.
- Do not add prompt-alignment receipts or publication metadata.
- Do not depend on raw prompt paths becoming runtime authority.

## References

- `references/phases.md`
- `references/io-contract.md`
- `references/validation.md`
