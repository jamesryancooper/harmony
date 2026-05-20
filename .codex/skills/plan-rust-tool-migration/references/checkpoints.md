# Plan Rust Tool Migration Checkpoints

This skill is stateful for planning continuity, not source mutation.

## Required Checkpoints

- target checkpoint: `target_path`, Cargo shape, entrypoints, and tests
- target-decision checkpoint: requested and selected architecture target
- migration-stage checkpoint: ordered stages and build/test expectation
- file-map checkpoint: proposed moves and ownership boundaries
- validation checkpoint: commands, done gate, and rollback notes
- output checkpoint: plan path, summary JSON path, and run log path

## Resume Rules

If interrupted, re-read target files before reusing a prior stage plan. Do not
reuse a file movement map if Cargo structure changed.
