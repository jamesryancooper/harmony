# Harmony CI Optimization Proposal Package

This directory contains a ready-to-run plan to cut GitHub Actions usage while preserving required governance and merge safety checks.

## Contents

- `execution-plan.md`
  - Full implementation plan with mandatory governance receipts and exact edit map per target workflow.
- `implementation-checklist.md`
  - Operator checklist mapped 1:1 to optimization tasks and done criteria.
- `baseline-and-verification.md`
  - Baseline capture and post-change verification procedure (1-week and 30-day).
- `scripts/collect-actions-baseline.sh`
  - Generates workflow cost/performance baseline artifacts from GitHub Actions run metadata.
- `scripts/compare-actions-baseline.sh`
  - Compares two baseline captures and emits reduction deltas.
- `codification/ci-efficiency-guard.yml`
  - Proposed future guard workflow for CI efficiency policy enforcement.
- `codification/ci-efficiency-guard.sh`
  - Proposed lint script used by the guard workflow.
- `patches/exact-edits.patch`
  - Ready-to-apply unified diff blueprint with exact workflow and runbook edits.

## Apply Order

1. Capture baseline (`scripts/collect-actions-baseline.sh`).
2. Apply `patches/exact-edits.patch` in a dedicated PR branch.
3. Validate required checks and merge behavior on real PR traffic for 7 days.
4. Compare baseline vs post-change using `scripts/compare-actions-baseline.sh`.
5. Roll out codification guard to prevent optimization regressions.
