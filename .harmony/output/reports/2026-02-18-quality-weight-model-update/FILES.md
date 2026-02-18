# FILES.md

## Canonical Inputs

- `/Users/jamesryancooper/Projects/harmony/.harmony/quality/weights/weights.yml`
  - Contract: policy only, versioned, change-controlled.
  - Required: metadata, canonical attributes, layered weights (`global`, `run_mode`, `subsystem`, `maturity`, `repo`), changelog with ADR links, profile sprawl guardrails.

- `/Users/jamesryancooper/Projects/harmony/.harmony/quality/scores/scores.yml`
  - Contract: measurement only, frequently updated.
  - Required: subsystem→attribute scores (1–5), acceptance criteria, evidence pointers.
  - Optional: owner, notes, last_updated, target_score.

- `/Users/jamesryancooper/Projects/harmony/.harmony/quality/weights/inputs/context.yml`
  - Contract: resolver context defaults (profile/run-mode/maturity/repo and optional baseline pointer).

## Resolver + Gate

- `/Users/jamesryancooper/Projects/harmony/.harmony/quality/_ops/scripts/compute-quality-score.sh`
  - Shell entrypoint for resolver.

- `/Users/jamesryancooper/Projects/harmony/.harmony/quality/_ops/scripts/quality-gate.sh`
  - Shell entrypoint for gate checks.

- `/Users/jamesryancooper/Projects/harmony/.harmony/runtime/crates/quality_tools/src/main.rs`
  - Rust implementation for resolver and gate logic.

## Generated Outputs

- `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/effective/<context>.md`
  - Effective weights matrix for the active context.

- `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/results/<context>.md`
  - Weighted totals + top backlog drivers for the active context.

- `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/scorecards/<date>/<run-id>/scorecard.yml`
  - Resolver-to-gate machine artifact.

## State Locks

- `/Users/jamesryancooper/Projects/harmony/.harmony/quality/_ops/state/active-weight-context.lock.yml`
- `/Users/jamesryancooper/Projects/harmony/.harmony/quality/_ops/state/effective-weights.lock.yml`

## Strict Schema

- Resolver accepts only:
  - policy schema from `/Users/jamesryancooper/Projects/harmony/.harmony/quality/weights/weights.yml`
  - score schema from `/Users/jamesryancooper/Projects/harmony/.harmony/quality/scores/scores.yml`
- Legacy score input shapes are not supported.
