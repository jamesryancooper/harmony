# Audit Rust Tool Architecture Checkpoints

This skill is stateful for audit repeatability, not for source mutation.

## Required Checkpoints

- scope checkpoint: target path, resolved Cargo package/workspace, exclusions
- evidence checkpoint: inspected files and skipped files with reasons
- classification checkpoint: current architecture and target recommendation
- findings checkpoint: stable finding IDs, severity, evidence, and acceptance
  criteria
- output checkpoint: report path, summary JSON path, bundle path, and run log

## Resume Rules

If interrupted, resume from the last complete checkpoint. Re-read changed target
files before reusing a prior classification or findings checkpoint.

## Determinism Receipt

Record commit or worktree identifier when available, seed policy, parameter
hash, coverage summary, and findings hash in the report or run log.
