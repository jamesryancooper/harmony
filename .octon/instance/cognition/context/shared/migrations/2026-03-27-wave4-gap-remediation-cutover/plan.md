---
title: Wave 4 Gap Remediation Cutover
description: Transitional remediation plan for the remaining Wave 4 assurance, lab, and disclosure gaps.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-27
- Version source(s): `/.octon/octon.yml`
- Current version before remediation: `0.6.6`
- Target version after remediation: `0.6.6`
- `release_state`: `pre-1.0`
- `change_profile`: `transitional`
- Selection facts:
  - downtime tolerance: repo-local harness work can absorb another staged
    Wave 4 pass, but structural/governance gates and the newly-added Wave 4
    validator must stay active throughout remediation
  - external consumer coordination ability: low external dependency pressure,
    but meaningful repo-local coordination across run writers, retained
    evidence, harness validators, and generated mission read models
  - data migration and backfill needs: medium; the existing Wave 3 sample run
    needs maintainability backfill, and Wave 4 needs a second real benchmark
    run plus evaluator-backed benchmark disclosure evidence
  - rollback mechanism: revert the Wave 4 remediation change set, remove the
    added maintainability plane and benchmark/evaluator artifacts, and restore
    the earlier Wave 4 state
  - blast radius and uncertainty: medium-high; remediation touches run
    contract defaults, run evidence generation, lab evidence families, and
    harness alignment
  - compliance and policy constraints: benchmark claims must stay bounded by
    the support-target matrix, evaluator review must remain explicit, and
    legacy evidence-only runs must not be silently rewritten into authoritative
    consequential runs
- Hard-gate outcomes:
  - maintainability must become a first-class proof plane rather than a
    narrative-only concern
  - benchmark disclosure must have a reusable writer path and an approved
    evaluator review path
  - run evidence backfill must be explicit and limited to runs that already
    have canonical run-control roots
  - older evidence-only run directories remain stage-only historical artifacts
    unless a human reconstructs missing authority
- Tie-break status: `transitional` selected because Wave 4 remediation extends
  the promoted model while preserving the earlier blocking gates and avoiding
  fabricated authority for legacy evidence-only runs
- `transitional_exception_note`:
  - rationale: finish the missing Wave 4 peers and reusable workflows without
    pretending that pre-run-contract evidence-only roots already have durable
    authority
  - risks:
    - benchmark disclosure could outrun the support matrix if evaluator and
      support-target refs drift
    - backfill could be misapplied to evidence-only directories if the run
      backfill path stops checking for canonical run contracts
    - maintainability proof could regress to prose if the retained proof plane
      is not required in RunCards
  - owner: `Octon governance`
  - target_removal_date: `2026-06-30`

## Implementation Summary

- Name: Wave 4 gap remediation cutover
- Owner: Octon maintainers
- Motivation: close the remaining Wave 4 gaps by adding the maintainability
  proof plane, reusable evaluator/HarnessCard tooling, benchmark-backed lab
  disclosure assets, and a generic backfill path for control-root-backed runs
- Scope:
  - add `framework/assurance/maintainability/**`
  - add evaluator routing and reusable evaluator-review tooling under
    `framework/assurance/evaluators/**`
  - add lab catalog and reusable HarnessCard tooling under `framework/lab/**`
  - extend RunCards and retained run evidence with maintainability proof
  - create a second normalized benchmark run plus benchmark/evaluator lab
    evidence
  - add a generic `write-run.sh backfill-wave4` path for canonical run roots

## Transitional Execution

1. Promote the missing maintainability proof plane under the existing Wave 4
   assurance family.
2. Add reusable evaluator and HarnessCard writers before depending on the new
   benchmark/evaluator evidence in validators.
3. Backfill only canonical run roots that already have bound run contracts.
4. Seed a second benchmark-focused consequential run and attach evaluator-backed
   benchmark disclosure evidence through retained lab artifacts.

## Impact Map

### Assurance and disclosure contracts

- `/.octon/framework/constitution/contracts/{assurance,disclosure}/**`
- `/.octon/framework/assurance/{README.md,maintainability/**,evaluators/**}`
- `/.octon/framework/lab/{README.md,governance/catalog.yml,runtime/_ops/scripts/write-harness-card.sh}`

### Run writers and retained evidence

- `/.octon/framework/orchestration/runtime/_ops/scripts/write-run.sh`
- `/.octon/framework/orchestration/runtime/runs/_ops/scripts/validate-runs.sh`
- `/.octon/state/control/execution/runs/run-wave3-runtime-bridge-20260327/**`
- `/.octon/state/control/execution/runs/run-wave4-benchmark-evaluator-20260327/**`
- `/.octon/state/evidence/runs/{run-wave3-runtime-bridge-20260327,run-wave4-benchmark-evaluator-20260327}/**`

### Lab benchmark and evaluator evidence

- `/.octon/state/evidence/lab/{benchmarks/**,evaluator-reviews/**,harness-cards/**,scenarios/**}`
- `/.octon/state/evidence/decisions/repo/dec-wave4-benchmark-evaluator-20260327/**`

### Validators and continuity

- `/.octon/framework/assurance/runtime/_ops/scripts/{validate-assurance-disclosure-expansion.sh,validate-harness-structure.sh,validate-architecture-conformance.sh}`
- `/.octon/instance/cognition/decisions/072-wave4-gap-remediation-cutover.md`
- `/.octon/state/evidence/migration/2026-03-27-wave4-gap-remediation-cutover/`

## Verification Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/072-wave4-gap-remediation-cutover.md`
- Evidence bundle:
  `/.octon/state/evidence/migration/2026-03-27-wave4-gap-remediation-cutover/`

## Rollback

- revert the Wave 4 remediation change set
- remove the benchmark/evaluator remediation artifacts if the branch is fully
  reverted
- keep legacy evidence-only runs historical; do not manufacture run authority
  during rollback or remediation
