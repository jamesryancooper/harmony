# Target architecture

## Goal

Promote only the two packet-time missing capabilities while explicitly preserving one no-change concept as already covered.

## Target state by concept

### 1. Evaluator calibration by disagreement distillation

**Durable meaning**
- Existing generic distillation contracts remain canonical.
- The target state is an **extended** distillation bundle contract and workflow that can explicitly capture evaluator disagreement and calibration candidates without minting authority.

**Operational state**
- No new control plane.
- Canonical mutable truth remains unchanged.
- Retained evidence gains a reusable disagreement bundle path under `state/evidence/validation/failure-distillation/**`.

**Enforcement**
- A dedicated distillation authoring script and bundle validator are added and wired into CI.

**Derived outputs**
- Optional generated summaries under `generated/cognition/distillation/**` remain non-authoritative.

### 2. Slice-to-stage binding refinement for mission-bound runs

**Durable meaning**
- The stage-attempt contract is extended so mission-bound stage attempts can explicitly resolve to a declared mission action slice.

**Operational state**
- Canonical live control truth remains under current run and mission roots.
- No new contract family is introduced.
- Mission-bound stage attempts carry `action_slice_ref` and resolve to `state/control/execution/missions/<mission-id>/action-slices/*.yml`.

**Enforcement**
- Existing mission runtime contract validation and mission autonomy scenario coverage are extended so a mission-bound stage attempt without a declared action slice fails closed.

**Evidence**
- Binding validation receipts are retained under run evidence.

### 3. Proposal-packet-backed expansion of terse objectives

**Target state**
- No architectural change.
- Current state is sufficient:
  - proposal lineage under `inputs/exploratory/proposals/**`
  - mission classification control records
  - fail-closed proposal requirements in mission autonomy policy
  - proposal references in run-contract-v3

## Why this target is correct

- It respects current run-first consequential execution.
- It preserves proposal packets as non-authoritative lineage only.
- It adds only the missing enforceable semantics and evidence paths.
- It avoids any second control plane, mission-local shadow contract family, or docs-only substitute.
