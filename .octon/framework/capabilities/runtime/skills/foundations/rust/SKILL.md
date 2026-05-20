---
name: rust
description: >
  Foundation skill set for Rust CLI tools, repo-local automation, and growing
  Rust scripts. Provides shared Rust tool architecture context, routing
  guidance, and sequencing for audit and migration planning skills.
skill_sets: [specialist]
capabilities: []
allowed-tools: Read Grep Glob
---

# Rust Foundation

Background context for Rust CLI tools, repo-local automation, and growing Rust
scripts. This skill is not invoked directly; use it to route and sequence the
Rust child skills.

## Stack Assumptions

These skills apply when the target is primarily Rust and uses Cargo as the
project boundary. They are strongest for:

- CLI utilities and repo-maintenance tools
- `xtask` automation and internal developer tools
- single-package crates that are growing beyond one file
- Rust scopes with `Cargo.toml`, `src/main.rs`, `src/lib.rs`, `src/bin/**`,
  `crates/**`, or `tests/**`

They are not general Rust language tutorials and should not be used to justify
mutation. Reports and plans are advisory unless a separate governed execution
path authorizes implementation.

## Child Skills

| Skill | Purpose |
| --- | --- |
| `/audit-rust-tool-architecture` | Evidence-backed audit of Rust tool structure, boundaries, testing, and safety. |
| `/plan-rust-tool-migration` | Staged migration plan for a Rust script or tool architecture. |

## Recommended Sequencing

1. Run `/audit-rust-tool-architecture` when the current structure, risks, or
   target architecture are unclear.
2. Run `/plan-rust-tool-migration` when the desired direction is clear enough
   to produce file moves, stages, validation commands, and rollback notes.
3. Route any implementation through a separate governed change. These skills
   do not authorize mutation by themselves.

## Architecture Posture

Prefer one Cargo package with a thin executable edge and a testable library
core unless evidence supports a larger split. Do not recommend a workspace just
because a tool has many files. Recommend workspace or internal crates only when
there are genuine package boundaries, independent dependency sets, or reusable
internal APIs.

## References

- [Rust large scripts architecture guide](references/rust-large-scripts-architecture-guide.md)
- [Architecture decision matrix](references/architecture-decision-matrix.md)
- [Migration stages](references/migration-stages.md)
- [Anti-patterns](references/anti-patterns.md)
- [Crate recommendations](references/crate-recommendations.md)
- [Safety and authority notes](references/safety-and-authority-notes.md)
- [Glossary](references/glossary.md)
