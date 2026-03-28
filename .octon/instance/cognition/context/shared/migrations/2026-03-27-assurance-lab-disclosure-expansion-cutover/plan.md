---
title: Assurance, Lab, And Disclosure Expansion Cutover
description: Transitional migration plan for Wave 4 assurance, lab, observability, and disclosure expansion.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-27
- Version source(s): `/.octon/octon.yml`
- Current version before cutover: `0.6.6`
- Target version after cutover: `0.6.6`
- `release_state`: `pre-1.0`
- `change_profile`: `transitional`
- Selection facts:
  - downtime tolerance: repo-local harness work can absorb staged validation
    and evidence backfill, but structural/governance gates must stay live
    while the new proof and disclosure families land
  - external consumer coordination ability: low external dependency pressure,
    but non-trivial repo-local coordination across constitutional contracts,
    run writers, validators, docs, and retained evidence
  - data migration and backfill needs: medium-high; the existing consequential
    run bundle needs replay, proof-plane, observability, and RunCard backfill,
    and system-level claims need a bounded HarnessCard seed
  - rollback mechanism: revert the Wave 4 change set, remove the new contract
    families and retained evidence extensions, and restore the pre-Wave 4 run
    evidence shape without weakening the already-promoted structural,
    governance, objective, authority, or runtime gates
  - blast radius and uncertainty: high; this cutover touches constitutional
    registries, run evidence writers, run validation, docs, and support-claim
    disclosure
  - compliance and policy constraints: disclosure must remain subordinate to
    durable authority, behavioral claims must stay gated on retained replay or
    lab evidence, and no current structural or governance gate may be removed
- Hard-gate outcomes:
  - structural and governance gates remain the blocking baseline throughout
    the cutover
  - behavioral proof cannot pass without retained lab, replay, scenario, or
    shadow-run evidence
  - RunCards and HarnessCards must cite canonical authority and evidence refs
    instead of introducing a second control plane
  - support claims remain bounded by the published support-target matrix
- Tie-break status: `transitional` selected because Wave 4 adds new proof
  planes and retained evidence families while preserving the current blocking
  gates and backfilling an already-bound consequential run
- `transitional_exception_note`:
  - rationale: promote assurance, lab, observability, and disclosure as
    first-class constitutional families without weakening the live
    structural/governance posture or over-claiming support
  - risks:
    - older consequential run bundles may remain partially backfilled until
      future cleanup sweeps land
    - HarnessCard disclosure could outrun true support if support-target refs
      or proof bundles drift
    - evaluator proof remains present but mostly `not_required` for this
      bounded repo-local support tier
  - owner: `Octon governance`
  - target_removal_date: `2026-06-30`

## Implementation Summary

- Name: Assurance, lab, and disclosure expansion cutover
- Owner: Octon maintainers
- Motivation: promote Wave 4 constitutional families, retain first-class
  proof-plane evidence beside consequential run roots, add a top-level lab and
  observability domain, and make consequential runs plus system-level claims
  replayable and interpretable through RunCards and HarnessCards
- Scope:
  - activate the constitutional assurance and disclosure families under
    `/.octon/framework/constitution/contracts/{assurance,disclosure}/**`
  - promote first-class proof-plane docs under
    `/.octon/framework/assurance/{structural,functional,behavioral,recovery,evaluators}/**`
  - add authored lab and observability surfaces under
    `/.octon/framework/{lab,observability}/**`
  - extend retained run evidence beneath
    `/.octon/state/evidence/runs/<run-id>/**` with replay manifests,
    proof-plane reports, measurements, interventions, and RunCards
  - add retained lab evidence and a bounded HarnessCard under
    `/.octon/state/evidence/lab/**`
  - add a dedicated Wave 4 validator and fold it into the harness alignment
    profile without removing prior blocking validators

## Transitional Execution

1. Promote the assurance and disclosure contract families and update the
   constitutional registries, obligations, and structural docs to reference
   them.
2. Add authored proof-plane, lab, and observability surfaces before requiring
   the new retained evidence families from live run validators.
3. Extend the run writer and retained sample run bundle so replay, proof,
   measurement, intervention, and RunCard outputs become normal retained
   evidence for consequential runs.
4. Seed one bounded support-target-backed HarnessCard through retained lab
   evidence instead of widening the support matrix or relying on prose.

## Impact Map

### Constitutional and structural authority

- `/.octon/framework/constitution/contracts/{registry.yml,assurance/**,disclosure/**}`
- `/.octon/framework/constitution/{CHARTER.md,charter.yml,obligations/**,precedence/normative.yml}`
- `/.octon/octon.yml`
- `/.octon/framework/engine/runtime/config/policy-interface.yml`
- `/.octon/framework/cognition/_meta/architecture/{specification.md,contract-registry.yml}`
- `/.octon/README.md`
- `/.octon/instance/bootstrap/START.md`

### Assurance, lab, and observability surfaces

- `/.octon/framework/assurance/{README.md,structural/**,functional/**,behavioral/**,recovery/**,evaluators/**}`
- `/.octon/framework/lab/**`
- `/.octon/framework/observability/**`

### Retained evidence and run wiring

- `/.octon/framework/orchestration/runtime/_ops/scripts/write-run.sh`
- `/.octon/framework/orchestration/runtime/runs/{README.md,_ops/scripts/validate-runs.sh}`
- `/.octon/state/control/execution/runs/run-wave3-runtime-bridge-20260327/run-contract.yml`
- `/.octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/**`
- `/.octon/state/evidence/lab/**`

### Validators and migration evidence

- `/.octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`
- `/.octon/framework/assurance/runtime/contracts/alignment-profiles.yml`
- `/.octon/framework/assurance/runtime/_ops/scripts/{alignment-check.sh,validate-harness-structure.sh,validate-architecture-conformance.sh}`
- `/.octon/instance/cognition/decisions/071-assurance-lab-disclosure-expansion-cutover.md`
- `/.octon/state/evidence/migration/2026-03-27-assurance-lab-disclosure-expansion-cutover/`

## Verification Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/071-assurance-lab-disclosure-expansion-cutover.md`
- Evidence bundle:
  `/.octon/state/evidence/migration/2026-03-27-assurance-lab-disclosure-expansion-cutover/`

## Rollback

- revert the Wave 4 assurance/disclosure/lab/observability change set
- remove the new retained run evidence families only if the full Wave 4 branch
  is being reverted
- restore the older run validation contract if the new run evidence extensions
  are removed
- do not leave a partial state where docs and validators require RunCards or
  HarnessCards but the retained evidence roots no longer materialize them
