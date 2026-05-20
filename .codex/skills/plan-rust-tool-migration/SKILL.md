---
name: plan-rust-tool-migration
description: >
  Staged Rust tool migration planning for Rust scripts, crates, CLI utilities,
  automation tools, and repo-local Rust scopes. Produces an advisory migration
  plan, file movement map, validation criteria, rollback notes, and retained
  planning evidence without authorizing mutation.
license: MIT
compatibility: Designed for Claude Code and similar AI coding assistants.
metadata:
  author: Octon Framework
  created: "2026-05-19"
  updated: "2026-05-19"
skill_sets: [executor, guardian]
capabilities: [domain-specialized]
allowed-tools: Read Glob Grep Write(/.octon/inputs/exploratory/plans/*) Write(/.octon/state/evidence/validation/analysis/*) Write(/.octon/state/evidence/runs/skills/*)
---

# Plan Rust Tool Migration

Create a staged, reviewable migration plan that moves a Rust script, crate, CLI
utility, automation tool, or repo-local Rust scope to the smallest sufficient
clean architecture.

## When to Use

Use this skill when:

- the target Rust architecture direction is known or has already been audited
- a file/module movement map is needed before implementation
- the CLI contract should be preserved while internals are reorganized
- implementation needs validation commands, rollback notes, and a done gate

## Core Workflow

1. **Inspect** - Read current Cargo structure, entrypoints, CLI behavior,
   modules, tests, and effect boundaries.
2. **Select Target** - Resolve `desired_target`, correcting it when evidence
   shows a smaller or larger architecture is necessary.
3. **Stage Migration** - Plan behavior-preserving, buildable stages with file
   moves, API boundaries, tests, validation commands, and rollback notes.
4. **Guard Scope** - Preserve CLI behavior by default and mark any intentional
   breaking change.
5. **Emit Outputs** - Write the plan, summary JSON, run log, and indexes only
   to registry-declared outputs.

## Plan Sections

Every migration plan must include target summary, current constraints, desired
target shape, non-goals, migration stages, file/module movement map, API
boundary changes, error/config/logging changes, testing additions,
filesystem/process safety corrections, validation commands, rollback notes, and
done gate.

## Boundaries

- Read target files and write only declared planning outputs.
- Do not edit source files.
- Do not claim the plan authorizes implementation.
- Preserve the current CLI contract unless the user explicitly requested a
  breaking migration.
- Do not recommend a workspace without concrete package-boundary evidence.

## References

- [Phases](references/phases.md)
- [Decisions](references/decisions.md)
- [Checkpoints](references/checkpoints.md)
- [Safety](references/safety.md)
- [Validation](references/validation.md)
- [Glossary](references/glossary.md)
- [I/O contract](references/io-contract.md)
- [Output schema](references/output-schema.yml)
- Parent Rust guidance: [Migration stages](../references/migration-stages.md)
