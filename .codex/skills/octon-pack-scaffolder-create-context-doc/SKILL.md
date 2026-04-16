---
name: octon-pack-scaffolder-create-context-doc
description: >
  Scaffold a pack-local context document for examples, usage guidance, or
  output-shape documentation.
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

# Octon Pack Scaffolder Create Context Doc

Create a descriptive context document under `context/`.

## When To Use

- the target pack needs examples, usage notes, or output-shape guidance
- the content should remain informative rather than authoritative
- the document belongs to the pack and not to core methodology surfaces

## Core Workflow

1. Validate `pack_id` and `doc_id`.
2. Create `context/<doc-id>.md` with a title, summary, and usage-oriented body.
3. Keep the document descriptive and additive.
4. Fail closed on conflicting existing content.

## Boundaries

- Additive only.
- Do not create governance or runtime contracts in `context/`.
- Do not treat the document as direct runtime authority.
- Do not overwrite divergent existing content.

## References

- `references/phases.md`
- `references/io-contract.md`
- `references/validation.md`
