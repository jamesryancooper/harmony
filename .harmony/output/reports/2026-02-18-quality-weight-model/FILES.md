# Proposed `.harmony/` File Layout for Weighted Quality Governance

## Authoritative Weight Sources
- `.harmony/quality/weights/weights.yml`
  - Machine-readable source of truth for profiles, overrides, and deprecation.
- `.harmony/quality/weights/weights.md`
  - Human-readable rationale and governance contract.

## Weight Governance and Decisions
- `.harmony/cognition/decisions/ADR-0xxx-weighted-quality-governance.md`
  - Records major weighting strategy shifts.
- `.harmony/cognition/decisions/ADR-0xxx-5v5-conflict-<topic>.md`
  - Required for unresolved `5 vs 5` attribute trade-offs.

## Inputs for Scoring Runs
- `.harmony/quality/weights/inputs/subsystem-scores.yml`
  - Subsystem-by-attribute measured scores and evidence pointers.
- `.harmony/quality/weights/inputs/context.yml`
  - Active context (`repo`, `maturity`, `run_mode`, selected profile).

## Runtime State for Gates
- `.harmony/quality/_ops/state/active-weight-context.lock.yml`
  - Resolved context used by current run.
- `.harmony/quality/_ops/state/effective-weights.lock.yml`
  - Effective weights snapshot after overrides.

## Scripts / Services Consuming Weights
- `.harmony/quality/_ops/scripts/compute-quality-score.sh`
  - Deterministic score computation and delta generation.
- `.harmony/quality/_ops/scripts/quality-gate.sh`
  - Hard-fail/soft-warn enforcement.
- `.harmony/runtime/crates/*` or equivalent WASM service
  - Optional runtime implementation of same algorithm.

## Published Outputs
- `.harmony/output/quality/scorecards/<YYYY-MM-DD>/<run-id>/scorecard.md`
- `.harmony/output/quality/scorecards/<YYYY-MM-DD>/<run-id>/scorecard.yml`
- `.harmony/output/quality/scorecards/<YYYY-MM-DD>/<run-id>/effective-weights.yml`
- `.harmony/output/quality/scorecards/<YYYY-MM-DD>/<run-id>/regressions.md`

## CI/Local Integration Points
- CI workflow step calls `compute-quality-score.sh` then `quality-gate.sh`.
- Local command mirrors CI behavior for deterministic preflight checks.
- Both must read `weights.yml` and never hardcode weights in scripts.
