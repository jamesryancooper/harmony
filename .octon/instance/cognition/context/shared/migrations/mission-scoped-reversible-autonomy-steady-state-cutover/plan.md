---
title: Mission-Scoped Reversible Autonomy Steady-State Cutover
description: Atomic migration plan for the final Mission-Scoped Reversible Autonomy steady-state cutover.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-25
- Version source(s): `version.txt`, `/.octon/octon.yml`
- Current version: `0.6.1`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - affected surfaces are repo-local mission authority, control truth, runtime
    contracts, generated route/view outputs, validators, and CI workflow gates
  - the repo already had a partial MSRAOM implementation, so the safe shape was
    one convergence branch rather than staged coexistence
  - historical receipts remain retained; only live control, generated, and
    contract surfaces are rewritten
  - rollback remains full-branch revert rather than dual live operating models
- Hard-gate outcomes:
  - no zero-downtime coexistence requirement
  - no tolerated split between legacy mission projection `.json` and final
    `mission-view.yml`
  - no advisory-only validator phase

## Implementation Plan

- Name: Mission-Scoped Reversible Autonomy steady-state cutover
- Owner: Octon maintainers
- Motivation: close the remaining MSRAOM cutover gaps so mission creation,
  mission control, effective routing, operator views, retained evidence, and
  CI all enforce one completed model
- Scope:
  - add the final `authorize-update-v1` and `mission-view-v1` contracts
  - converge mission control scripts on the full control-file family
  - replace legacy mission projection `.json` outputs with
    `mission-view.yml`
  - require non-empty slice-linked intent for material autonomous work
  - expand evidence coverage validation and retain representative receipt
    classes under canonical control-evidence roots
  - make architecture-conformance CI block on the full mission validator stack

### Atomic Profile Execution

- Clean-break approach:
  - one integration branch
  - one live mission-control family after merge
  - one live mission projection format after merge
  - one validator/CI gate set after merge
- Big-bang implementation steps:
  1. Upgrade the runtime contract family, policy-interface roots, and contract
     registry.
  2. Rework mission seed/route/evaluator/receipt scripts to emit the final
     control truth and effective route model.
  3. Regenerate mission summaries, operator digests, and machine-readable
     mission views from canonical roots.
  4. Migrate the live validation mission to the final control family with a
     slice-linked intent and non-null route linkage.
  5. Expand validators and CI jobs so the completed model is blocking.
  6. Refresh extension/locality/capability effective outputs after the release
     version change so the umbrella runtime-effective gate stays coherent.

## Impact Map

### Code

- `/.octon/framework/orchestration/runtime/_ops/scripts/*mission*`
- `/.octon/framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-*mission*`
- `/.octon/framework/engine/runtime/spec/*`
- `/.octon/framework/engine/runtime/config/policy-interface.yml`
- `/.github/workflows/architecture-conformance.yml`

### Tests

- `bash .octon/framework/assurance/runtime/_ops/tests/test-mission-autonomy-helpers.sh`
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-runtime-effective-state.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/test-mission-autonomy-scenarios.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-runtime-contracts.sh`

### Docs

- `/.octon/README.md`
- `/.octon/framework/engine/runtime/spec/policy-interface-v1.md`
- `/.octon/framework/cognition/_meta/architecture/contract-registry.yml`
- `/.octon/framework/orchestration/runtime/workflows/missions/create-mission/**`
- this migration plan

## Verification Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/066-mission-scoped-reversible-autonomy-steady-state-cutover.md`
- Evidence bundle:
  `/.octon/state/evidence/migration/2026-03-25-mission-scoped-reversible-autonomy-steady-state-cutover/`

## Rollback

- revert the full steady-state cutover change set
- restore the prior release/version and republish effective extension/locality/
  capability outputs from the reverted manifest
- do not keep the final validators while restoring the older partial mission
  control model
