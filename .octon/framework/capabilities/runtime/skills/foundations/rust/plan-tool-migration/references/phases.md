# Plan Rust Tool Migration Phases

## Phase 1: Inspect Current Target

Read `target_path`, Cargo files, entrypoints, modules, tests, config, CLI
parsing, error handling, and effect boundaries.

## Phase 2: Resolve Desired Target

Evaluate `desired_target`: `auto`, `main-modules`, `bin-lib-split`,
`multiple-binaries`, `workspace`, or `internal-crates`. If the selected target
is not justified, state the correction and rationale.

## Phase 3: Stage Migration

Design stages that keep the tool buildable and testable where possible. Prefer
this sequence:

1. add characterization tests around current behavior
2. extract pure logic before changing behavior
3. introduce `src/lib.rs` before multiple binaries or workspaces
4. move effects behind adapters
5. add validation and smoke tests

## Phase 4: Define File And API Changes

Include a file/module movement map, public/internal API boundary changes,
config/error/logging updates, tests, and validation commands.

## Phase 5: Emit Advisory Outputs

Write the migration plan, summary JSON, run log, and indexes to the
registry-declared outputs. Do not modify source files.
