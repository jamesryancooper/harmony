---
title: Overlay And Ingress Model Atomic Cutover
description: Atomic clean-break migration plan for promoting Packet 5 overlay and ingress enforcement.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-19
- Version source(s): `/.octon/octon.yml`
- Current version: `0.5.0`
- Release state (`pre-1.0` or `stable`): `pre-1.0`
- `release_state` (`pre-1.0` or `stable`): `pre-1.0`
- `change_profile` (`atomic` or `transitional`): `atomic`
- Selection facts:
  - downtime tolerance: one-step cutover is acceptable because this is an
    internal harness contract hardening
  - external consumer coordination ability: not required; the harness is
    self-hosted in this repository
  - data migration/backfill needs: none; this is a doc, validator, scaffolding,
    and evidence convergence sweep
  - rollback mechanism: full revert of the cutover change set
  - blast radius and uncertainty: broad control-plane sweep, but still within
    one authoritative harness root
  - compliance/policy constraints: fail closed on ad hoc overlays, disabled
    overlay artifacts, or root-ingress drift
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no external coexistence requirement
  - no staged publication requirement
- Tie-break status: `atomic` selected without exception
- Transitional Exception Note (required when `change_profile=transitional` in pre-1.0): N/A
- `transitional_exception_note` (required when `change_profile=transitional` in pre-1.0):
  - rationale: N/A
  - risks: N/A
  - owner: N/A
  - target_removal_date: N/A

## Implementation Plan

- Name: Overlay and ingress model atomic cutover
- Owner: `architect`
- Motivation: Promote Packet 5 so repo-instance overlays and ingress become
  explicit, bounded, and validator-enforced.
- Scope: overlay registry strictness, repo-side enablement, ingress adapters,
  Packet 5 docs/workflows/scaffolding, validation tests, ADRs, and migration
  evidence.

### Atomic Profile Execution

- Clean-break approach:
  - keep the live overlay registry, instance manifest, and ingress chain as
    the only contract surfaces
  - harden validators to reject disabled overlay content, ad hoc overlay-like
    paths, and non-thin root adapters
  - rewrite active docs, templates, and workflows to the Packet 5 contract
  - record one migration evidence bundle
- Big-bang implementation steps:
  - update canonical architecture and bootstrap docs
  - tighten overlay, ingress, and agency validators
  - add focused fixture tests for overlay placement drift and adapter thinness
  - align scaffolding/runtime bootstrap assets and workflow guidance
  - record ADR and migration evidence
- Big-bang rollout steps:
  - run the Packet 5 validation commands locally
  - refresh generated ADR summaries from the updated decision index
  - publish one migration evidence bundle

### Transitional Profile Execution (if selected)

- Not applicable. Packet 5 is landing under `atomic`.

## Impact Map (code, tests, docs, contracts)

### Code

- Files changed:
  - architecture docs, ingress adapters, validators, tests, scaffolding
    assets, workflow stages, ADR records, and migration evidence
- Legacy removals:
  - permissive root-adapter matching
  - tolerated ad hoc overlay-like content outside the ratified roots

### Tests

- Final-state tests:
  - `test-validate-overlay-points.sh`
  - `test-validate-bootstrap-ingress.sh`
  - `test-validate-repo-instance-boundary.sh`
  - `alignment-check.sh --profile harness`
- Phase-behavior tests (if transitional):
  - N/A

### Docs

- Updated docs/runbooks:
  - root README
  - bootstrap START/orientation surfaces
  - shared-foundation and umbrella specification
  - update/migrate harness workflow stages
  - bootstrap asset guidance

### Contracts

- Schemas/manifests/contracts changed:
  - overlay validation rules
  - root ingress adapter validity
  - bootstrap projection metadata
  - Packet 5 migration evidence bundle

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

- [x] Packet 5 docs enumerate instance-native and overlay-capable surfaces
- [x] Root ingress adapters are constrained to symlink/parity-copy behavior

### Runtime Verification

- [x] Packet 5 overlay and ingress validators pass in the live repo
- [x] Harness alignment profile includes the Packet 5 checks

### CI Verification

- [x] Focused fixture tests cover overlay placement drift and adapter thinness

Required evidence bundle location:

- `/.octon/state/evidence/migration/2026-03-19-overlay-and-ingress-model-cutover/`
- bundle files:
  - `bundle.yml`
  - `evidence.md`
  - `commands.md`
  - `validation.md`
  - `inventory.md`

## Rollback

- Rollback strategy: full commit-range revert of this cutover
- Rollback trigger conditions:
  - overlay validation allows disabled or ad hoc overlay content
  - root-ingress adapter enforcement cannot converge to one adapter model
- Rollback evidence references:
  - `/.octon/state/evidence/migration/2026-03-19-overlay-and-ingress-model-cutover/`
