---
title: Mission-Scoped Reversible Autonomy Atomic Cutover
description: Atomic clean-break migration plan for upgrading Octon to mission-scoped reversible autonomy with mission authority, control truth, retained control evidence, and derived operator views.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-23
- Version source(s): `/.octon/octon.yml`
- Current version: `0.5.5`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - downtime tolerance: one-step cutover is acceptable because all affected
    surfaces are repo-local runtime, governance, mission authority, evidence,
    and generated summaries
  - external consumer coordination ability: not required; consumers are local
    runtime code, docs, validators, and CI
  - data migration/backfill needs: low; active mission registry is currently
    empty, but any active mission created before merge must be migrated in the
    cutover branch
  - rollback mechanism: full revert of the cutover change set plus regeneration
    of affected generated outputs
  - blast radius and uncertainty: high; mission authority, runtime request and
    receipt contracts, control truth, cognition generation, validators, and CI
    all change together
  - compliance/policy constraints: no dual live operating model, no
    mission-less autonomous fallback, no second control plane, and no rewrite
    of historical run evidence
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no staged coexistence requirement
  - no historical receipt rewrite requirement
- Tie-break status: `atomic` selected without exception

## Implementation Plan

- Name: Mission-Scoped Reversible Autonomy atomic cutover
- Owner: `architect`
- Motivation: Promote the accepted mission-scoped-reversible-autonomy proposal
  into durable runtime, governance, validation, and generated cognition
  surfaces.
- Scope: root manifest bindings, mission authority v2, mission autonomy policy,
  ownership registry, runtime v2 request/receipt contracts, mission-scoped
  control roots, retained control receipts, cognition mission summaries,
  validators, CI, ADR, evidence, and proposal lifecycle closeout.

### Atomic Profile Execution

- Clean-break approach:
  - land root manifest, architecture contracts, principle text, runtime
    request/receipt contracts, mission authority v2, mission control roots,
    generated mission summaries, validators, and closeout evidence together
  - reject autonomous execution without mission autonomy context after cutover
  - retain existing run evidence as historical truth without rewriting it
  - keep global execution budgets and exception leases authoritative while
    adding separate per-mission autonomy burn and breaker state
  - keep generated mission/operator views derived-only and forbid any new
    second activity journal
- Big-bang implementation steps:
  - bump `octon.yml` to `0.6.0` and publish runtime input bindings for mission
    registry, mission control root, ownership registry, and mission autonomy
    policy
  - update architecture SSOT docs and add the Mission-Scoped Reversible
    Autonomy governing principle
  - upgrade mission scaffolding and registry to `octon-mission-v2` and
    `octon-mission-registry-v2`
  - add repo-owned `mission-autonomy.yml` and `ownership/registry.yml`
  - add mission-control and control-receipt schemas plus `execution-request-v2`,
    `execution-receipt-v2`, and `policy-receipt-v2`
  - update kernel authorization so autonomous workflow execution requires and
    records mission autonomy context
  - extend cognition sync generation for mission `now/next/recent/recover`
    summaries and operator digests
  - add mission-autonomy validators, alignment profile wiring, and CI coverage
  - record ADR, migration evidence bundle, and proposal registry/archive state
- Big-bang rollout steps:
  - implement on one branch and merge only after final-state validation passes
  - regenerate affected generated cognition outputs in the same branch
  - archive the proposal only after durable contracts, validators, evidence,
    and generated outputs are coherent

## Impact Map (code, tests, docs, contracts)

### Code

- `framework/engine/runtime/crates/kernel/**`
- `framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh`
- `framework/orchestration/runtime/workflows/missions/**`
- `framework/assurance/runtime/_ops/scripts/**`

### Tests

- targeted kernel authorization tests for autonomous mission context
- targeted pipeline fixture tests for mission-scoped workflow execution
- mission-autonomy validator scripts and scenario runner
- alignment profile and CI execution of `mission-autonomy`

### Docs

- root manifest and architecture contracts
- governance principles for mission autonomy, ACP, reversibility, and ownership
- mission scaffolding and mission workflow docs
- bootstrap and root `.octon` orientation docs
- ADR, migration plan, and migration evidence bundle

### Contracts

- mission charter v2
- mission autonomy policy and ownership registry schemas
- mission control state schemas
- execution request/receipt v2 and control receipt v1
- alignment profile and architecture-conformance CI gate wiring

## Compliance Receipt

- [x] Exactly one profile selected before implementation
- [x] Release-state gate applied
- [x] Pre-1.0 atomic default respected
- [x] Hard-gate fact collection recorded
- [x] Tie-break rule enforced
- [x] Obsolete/legacy surfaces removed at final state
- [x] Required validations executed and linked

## Exceptions/Escalations

- Current exceptions: none
- Escalations raised: none during planning
- Risk acceptance owner: Octon maintainers

## Verification Evidence

### Static Verification

- [x] Mission authority, mission autonomy policy, ownership registry, and new
  runtime schema surfaces exist
- [x] Root manifest and architecture contracts name the mission control and
  retained control evidence roots
- [x] Generated mission/operator summary roots exist and remain derived-only

### Runtime Verification

- [x] Autonomous workflow execution denies when mission autonomy context is
  missing
- [x] Autonomous workflow execution records mission context in execution/policy
  receipts when mission surfaces are seeded
- [x] Mission `proceed_on_silence` blocks when autonomy burn is not healthy

### CI Verification

- [x] `alignment-check.sh --profile mission-autonomy`
- [x] `alignment-check.sh --profile harness,mission-autonomy`
- [x] `validate-runtime-effective-state.sh`

Required evidence bundle location:

- `/.octon/state/evidence/migration/2026-03-23-mission-scoped-reversible-autonomy-cutover/`
- bundle files:
  - `bundle.yml`
  - `evidence.md`
  - `commands.md`
  - `validation.md`
  - `inventory.md`

## Rollback

- Rollback strategy: revert the atomic cutover as one change set and
  regenerate any affected generated cognition outputs
- Rollback trigger conditions: mission-less autonomous execution still
  succeeds, generated mission summaries depend on non-canonical sources,
  material control mutations lack retained control receipts, or final-state
  breaker/safing semantics are incorrect
- Rollback evidence references: this migration plan, ADR 063, and the retained
  migration evidence bundle
