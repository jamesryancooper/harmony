---
name: audit-rust-tool-architecture
description: >
  Bounded evidence-backed architecture audit for Rust scripts, crates, CLI
  utilities, automation tools, and repo-local Rust scopes. Produces findings,
  severity, migration recommendations, validation criteria, and retained
  evidence without authorizing mutation.
license: MIT
compatibility: Designed for Claude Code and similar AI coding assistants.
metadata:
  author: Octon Framework
  created: "2026-05-19"
  updated: "2026-05-19"
skill_sets: [executor, guardian]
capabilities: [domain-specialized]
allowed-tools: Read Glob Grep Write(/.octon/state/evidence/validation/analysis/*) Write(/.octon/state/evidence/validation/audits/*) Write(/.octon/state/evidence/runs/skills/*)
---

# Audit Rust Tool Architecture

Audit a Rust script, crate, CLI utility, automation tool, or repo-local Rust
scope as an implementation artifact. Produce a bounded, evidence-backed report
with concrete findings, tradeoffs, migration guidance, and validation criteria.

## When to Use

Use this skill when:

- a Rust tool has grown beyond a simple `main.rs`
- CLI behavior, testability, config, effects, or error handling need review
- workspace splitting or a `bin` plus `lib` split is being considered
- post-remediation verification needs a strict done gate

## Core Workflow

1. **Scope** - Lock `target_path`, mode, evidence depth, threshold, and
   post-remediation controls.
2. **Inspect** - Read Cargo structure, entrypoints, tests, CLI behavior,
   config, errors, filesystem/process effects, and concurrency choices.
3. **Classify** - Identify the current architecture and whether it is
   sufficient for the tool's maturity.
4. **Evaluate** - Apply Rust-specific boundary, safety, testing, and migration
   criteria.
5. **Recommend** - Produce findings with severity, evidence, correction, and
   overengineering boundary.
6. **Validate** - Emit report, summary JSON, bounded audit bundle, and run log
   only to registry-declared outputs.

## Required Finding Format

Each finding must include: ID, severity, evidence, why it matters,
recommended correction, minimum sufficient fix, overengineering boundary, and
validation step.

## Boundaries

- Read source files and write only declared audit outputs.
- Do not edit the audited Rust target.
- Do not claim the report authorizes implementation.
- Do not recommend workspaces without concrete package-boundary evidence.
- Treat generated reports as evidence and planning material, not architecture
  authority.

## References

- [Phases](references/phases.md)
- [Decisions](references/decisions.md)
- [Checkpoints](references/checkpoints.md)
- [Safety](references/safety.md)
- [Validation](references/validation.md)
- [Glossary](references/glossary.md)
- [I/O contract](references/io-contract.md)
- [Rubric](references/rubric.md)
- [Output schema](references/output-schema.yml)
- Parent Rust guidance: [Rust large scripts architecture guide](../references/rust-large-scripts-architecture-guide.md)
