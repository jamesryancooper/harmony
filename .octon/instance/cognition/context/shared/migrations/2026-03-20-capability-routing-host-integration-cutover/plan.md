---
title: Capability Routing And Host Integration Atomic Cutover
description: Atomic clean-break migration plan for promoting Packet 12 generated routing, bounded scope signals, compiled extension exports, and materialized host projections.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-20
- Version source(s): `/.octon/octon.yml`
- Current version: `0.5.1`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - downtime tolerance: one-step cutover is acceptable because this is an
    internal harness control-plane migration
  - external consumer coordination ability: not required; host surfaces are
    repo-local projections regenerated inside this repository
  - data migration/backfill needs: no staged coexistence; this is a schema,
    generator, validator, host-projection, and docs convergence sweep
  - rollback mechanism: full revert of the cutover change set
  - blast radius and uncertainty: broad active-reference rewrite across
    capability manifests, locality schema, extension publication, routing
    publication, host projections, scaffolding, workflows, and assurance
  - compliance/policy constraints: fail closed on raw `inputs/**` leakage,
    stale locality or extension linkage, ambiguous routing identities, or
    stale host projections
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no external coexistence requirement
  - no staged publication requirement
- Tie-break status: `atomic` selected without exception

## Implementation Plan

- Name: Capability routing and host integration atomic cutover
- Owner: `architect`
- Motivation: Promote Packet 12 so Octon uses one generated routing contract
  for framework-native, repo-native, and extension-derived capabilities, with
  bounded scope signals and materialized host projections.
- Scope: capability manifests/registries, locality scope schema, extension
  effective publication, routing publisher and validator, host projection
  publisher and validator, generated outputs, host-facing directories,
  templates, active docs, Packet 12 closeout ADR, and migration evidence.

### Atomic Profile Execution

- Clean-break approach:
  - upgrade routing publication and extension publication schemas in the same
    change set that updates generators and validators
  - replace symlink-era host surfaces with materialized projections in the
    same change set that updates docs and workflows
  - keep routing consumers on generated publication only; no raw-path or
    symlink fallback remains
  - record one Packet 12 closeout ADR and one migration evidence bundle
- Big-bang implementation steps:
  - add explicit routing and `host_adapters` metadata to capability
    definitions
  - add repo-native capability manifests for commands and skills
  - tighten the locality scope schema to `octon-locality-scope-v2`
  - extend extension effective publication to `v3` with `routing_exports`
  - refactor capability routing publication to `v2`
  - replace host link setup with `publish-host-projections.sh`
  - add host projection validation and regenerate `.claude/.cursor/.codex`
    command and skill surfaces
  - update templates, workflow guidance, and active architecture docs
  - record the Packet 12 closeout ADR and migration evidence bundle

## Impact Map (code, tests, docs, contracts)

### Code

- capability manifests and routing publishers
- extension publication and locality publication
- host projection publisher and validator
- harness alignment profile and validator stack

### Tests

- `test-validate-locality-registry.sh`
- `test-validate-locality-publication-state.sh`
- `test-validate-extension-publication-state.sh`
- `test-validate-capability-publication-state.sh`
- `test-validate-host-projections.sh`
- `alignment-check.sh --profile harness`

### Docs

- capability architecture and creation guidance
- skills README and create-skill references
- generated effective routing and extension architecture readmes
- scaffolding template manifests and effective output templates

### Contracts

- Packet 12 capability routing contract
- Packet 8 extension publication contract
- Packet 6 locality schema contract
- host projection contract for `.claude/.cursor/.codex`

## Compliance Receipt

- [x] Exactly one profile selected before implementation
- [x] Release-state gate applied
- [x] Pre-1.0 atomic default respected
- [x] Hard-gate fact collection recorded
- [x] No dual-read or symlink fallback introduced
- [x] Required validations executed and linked

## Exceptions/Escalations

- Current exceptions: none
- Escalations raised: sandbox-only elevated run needed in this environment to
  rewrite `.codex/commands/**` during the alignment profile
- Risk acceptance owner: Octon maintainers

## Verification Evidence

Required evidence bundle location:

- `/.octon/state/evidence/migration/2026-03-20-capability-routing-host-integration-cutover/`

Required bundle files:

- `bundle.yml`
- `evidence.md`
- `commands.md`
- `validation.md`
- `inventory.md`
