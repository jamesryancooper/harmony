---
title: Proposal System Integrity And Archive Normalization Atomic Cutover
description: Atomic clean-break migration plan for converging the proposal contract, generator, workflows, archive corpus, and committed proposal registry in one final-state merge.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-24
- Version source(s): `/.octon/octon.yml`
- Current version: `0.6.0`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - downtime tolerance: one-step cutover is acceptable because the affected
    surfaces are repo-local proposal governance, validation, workflow, archive,
    and discovery contracts
  - external consumer coordination ability: not required; no external
    repository or runtime consumer needs staged compatibility
  - data migration/backfill needs: bounded repo-local manifest rewrites,
    archive metadata repair, deterministic registry rebuild, and proposal
    closeout records only
  - rollback mechanism: full revert of the cutover branch plus regeneration of
    the committed registry from the reverted manifests
  - blast radius and uncertainty: medium-high; standards, schemas, validators,
    workflow runners, archive packets, and proposal discovery change together
  - compliance/policy constraints: no dual registry writers, no mixed
    authoritative-versus-generated lifecycle model, no invalid archive packets
    in the main projection, and no completion claim until the final-state gate
    is green
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no staged coexistence requirement
  - no external migration coordination requirement
  - no large data backfill requirement
- Tie-break status: `atomic` selected without exception
- Transitional Exception Note (required when `change_profile=transitional` in pre-1.0): N/A
- `transitional_exception_note` (required when `change_profile=transitional` in pre-1.0):
  - rationale: N/A
  - risks: N/A
  - owner: N/A
  - target_removal_date: N/A

## Implementation Plan

- Name: Proposal system integrity and archive normalization atomic cutover
- Owner: Octon maintainers
- Motivation: Finish the remaining proposal-system integrity work in one branch
  so standards, schemas, workflow execution, archive packets, and committed
  discovery all converge together instead of preserving mixed steady state.
- Scope:
  - converge proposal standards, templates, schemas, and validators
  - keep the deterministic generator as the only proposal-registry writer
  - converge create, validate, promote, and archive workflow execution on one
    fail-closed model
  - normalize or exclude broken archive packets from the main projection
  - rebuild the committed registry from manifests and archive the implementing
    proposal in the same closeout transaction

### Atomic Profile Execution

- Clean-break approach:
  - one integration branch
  - no advisory-first generator or validator phase
  - no dual registry writers or manual edit fallback
  - no mixed archive where invalid packets remain in the main projection
  - active implementing proposal remains active during branch work and is
    archived only in the final closeout change
- Big-bang implementation steps:
  1. Update durable proposal standards, subtype standards, bootstrap guidance,
     proposal workspace guidance, and umbrella architecture docs to the final
     model.
  2. Update proposal schemas, scaffolding templates, and shell validators so
     they all accept the same contract.
  3. Rewire proposal workflow packages and kernel workflow execution so the
     canonical generator is the only supported writer of
     `/.octon/generated/proposals/registry.yml`.
  4. Repair or exclude the bounded archive inventory and rebuild the committed
     registry from manifests.
  5. Run the full final-state validation suite and keep fixing drift on the
     same branch until the tree is generator-clean and validator-clean.
  6. Record closeout receipts, archive the implementing proposal package, and
     regenerate the registry one final time.
- Big-bang rollout steps:
  1. Merge only after all final-state checks are green on the same tree.
  2. Treat the merged tree as the only supported proposal-system model.
  3. If the checks cannot be made green together, do not merge.

### Transitional Profile Execution (if selected)

- Phases: N/A
- Phase exit criteria: N/A
- Final decommission/removal date: N/A

## Impact Map (Code, Tests, Docs, Contracts)

### Code

- Files changed:
  - `/.octon/framework/scaffolding/governance/patterns/*proposal-standard.md`
  - `/.octon/framework/scaffolding/runtime/templates/*proposal*.json`
  - `/.octon/framework/scaffolding/runtime/templates/proposal-*/**`
  - `/.octon/framework/assurance/runtime/_ops/scripts/*proposal*`
  - `/.octon/framework/assurance/runtime/_ops/scripts/generate-proposal-registry.sh`
  - `/.octon/framework/orchestration/runtime/workflows/meta/*proposal*/**`
  - `/.octon/framework/orchestration/runtime/workflows/{manifest.yml,registry.yml}`
  - `/.octon/framework/engine/runtime/crates/kernel/src/workflow.rs`
  - `/.octon/generated/proposals/registry.yml`
  - bounded archived proposal packets under
    `/.octon/inputs/exploratory/proposals/.archive/**`
- Legacy removals:
  - any remaining non-generator registry mutation behavior
  - stale schema-required keys that do not match live templates and validators
  - invalid archive lineage values and non-conformant archive packets in the
    main projection

### Tests

- Final-state tests:
  - `cargo check --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_kernel`
  - `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-proposal-standard.sh`
  - `bash .octon/framework/assurance/runtime/_ops/tests/test-generate-proposal-registry.sh`
  - `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-proposal-operation-workflows.sh`
  - `bash .octon/framework/assurance/runtime/_ops/tests/test-proposal-operation-workflow-runners.sh`
  - `bash .octon/framework/assurance/runtime/_ops/scripts/validate-validate-proposal-workflow.sh`
  - `bash .octon/framework/assurance/runtime/_ops/scripts/validate-promote-proposal-workflow.sh`
  - `bash .octon/framework/assurance/runtime/_ops/scripts/validate-archive-proposal-workflow.sh`
  - `bash .octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh --all-standard-proposals`
  - `bash .octon/framework/assurance/runtime/_ops/scripts/generate-proposal-registry.sh --check`
- Phase-behavior tests (if transitional): N/A

### Docs

- Updated docs/runbooks:
  - `/.octon/inputs/exploratory/proposals/README.md`
  - `/.octon/instance/bootstrap/START.md`
  - `/.octon/framework/cognition/_meta/architecture/specification.md`
  - `/.octon/framework/cognition/_meta/architecture/runtime-vs-ops-contract.md`
  - `/.octon/framework/cognition/_meta/architecture/generated/proposals/README.md`
  - proposal template README files and source-of-truth-map templates
  - proposal-local implementation and acceptance docs
  - this migration plan plus final closeout records

### Contracts

- Schemas/manifests/contracts changed:
  - base proposal schema and archive disposition support
  - architecture, migration, and policy subtype schemas
  - proposal scaffolding manifest contracts
  - deterministic proposal-registry projection contract
  - archive lineage and promotion-evidence expectations

## Compliance Receipt

- [x] Exactly one profile selected before implementation
- [x] Release-state gate applied
- [x] Pre-1.0 atomic default respected (or transitional exception documented)
- [x] Hard-gate fact collection recorded
- [x] Tie-break rule enforced
- [x] Obsolete/legacy surfaces removed at final state
- [x] Required validations executed and linked

## Exceptions/Escalations

- Current exceptions: none
- Escalations raised: none
- Risk acceptance owner: Octon maintainers

## Verification Evidence

### Static Verification

- [x] No prohibited legacy/profile drift patterns remain
- [x] Required sections and keys present

### Runtime Verification

- [x] Selected profile behavior exercised
- [x] Final state converges to single intended authority

### CI Verification

- [x] Profile-governance validation gates pass

Required evidence bundle location:

- `/.octon/state/evidence/migration/2026-03-24-proposal-system-integrity-and-archive-normalization-cutover/`
- bundle files:
  - `bundle.yml`
  - `evidence.md`
  - `commands.md`
  - `validation.md`
  - `inventory.md`

## Rollback

- Rollback strategy:
  - revert the full cutover change set
  - regenerate `/.octon/generated/proposals/registry.yml` from the reverted
    manifests
  - restore the active implementing proposal only if the rollback also restores
    the pre-cutover durable contract surfaces
- Rollback trigger conditions:
  - final-state validation cannot be made green on one tree
  - merged behavior contradicts the generator-clean or archive-clean contract
  - workflow execution still depends on non-generator registry mutation
- Rollback evidence references:
  - `/.octon/state/evidence/migration/2026-03-24-proposal-system-integrity-and-archive-normalization-cutover/`
