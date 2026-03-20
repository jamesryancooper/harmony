---
title: Inputs/Exploratory/Proposals Atomic Cutover
description: Atomic clean-break migration plan for promoting Packet 9 exploratory proposal placement, validator, and registry enforcement.
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
  - external consumer coordination ability: not required; the harness is
    self-hosted in this repository
  - data migration/backfill needs: no staged coexistence window; this is a
    path, validator, registry, and tooling convergence sweep
  - rollback mechanism: full revert of the cutover change set
  - blast radius and uncertainty: broad proposal/docs/validator/template/test
    sweep with historical path rewrites
  - compliance/policy constraints: fail closed on numbered proposal-package
    paths, runtime reads of proposal inputs, or framework-local engine build
    state
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no external coexistence requirement
  - no staged publication requirement
- Tie-break status: `atomic` selected without exception

## Implementation Plan

- Name: Inputs/exploratory/proposals atomic cutover
- Owner: `architect`
- Motivation: Promote Packet 9 so proposal authoring, discovery, validation,
  and runtime isolation all converge on one integrated exploratory proposal
  model.
- Scope: proposal package path rename, registry rewrite, standards, validators,
  templates, workflow runner fixtures, historical path rewrites, archive
  metadata finalization, and engine runtime cache relocation needed to keep the
  framework boundary clean during proposal workflow execution.

### Atomic Profile Execution

- Clean-break approach:
  - rename the full architecture packet tree from numbered packet prefixes to
    unnumbered `proposal_id` directories in one change set
  - rewrite active and historical repo-authored references to the new paths
  - harden proposal standards, validators, templates, and workflow runners to
    the unnumbered path contract
  - finalize archive metadata for the archived extension sidecar proposal
  - move engine runtime source-build output to
    `generated/.tmp/engine/build/runtime-crates-target`
- Big-bang implementation steps:
  - `git mv` all architecture proposal directories to `proposal_id`-matched
    paths
  - rewrite the generated proposal registry and historical references
  - update Packet 9 promoted docs and proposal standards
  - make the baseline proposal validator schema-aware and subtype-count aware
  - normalize subtype validator path resolution
  - align launcher/runtime cache paths and workflow runner fixtures
  - record one ADR and one migration evidence bundle

## Impact Map (code, tests, docs, contracts)

### Code

- proposal validators, engine runtime launchers, kernel workflow generator,
  and proposal workflow runner tests

### Tests

- proposal standard validator test
- create/audit proposal workflow runner tests
- live-independence queue/orchestration validators
- framework boundary and harness alignment gates

### Docs

- proposal workspace README
- root/bootstrap/spec/shared-foundation architecture docs
- proposal standards and scaffold templates
- ADR and migration evidence surfaces

### Contracts

- Packet 9 proposal path and authority-order contract
- proposal registry schema
- archive-disposition contract
- framework boundary contract for engine source-build state

## Compliance Receipt

- [x] Exactly one profile selected before implementation
- [x] Release-state gate applied
- [x] Pre-1.0 atomic default respected
- [x] Hard-gate fact collection recorded
- [x] No compatibility shims or dual proposal roots introduced
- [x] Required validations executed and linked

## Exceptions/Escalations

- Current exceptions: none
- Escalations raised: none
- Risk acceptance owner: Octon maintainers

## Verification Evidence

Required evidence bundle location:

- `/.octon/state/evidence/migration/2026-03-20-inputs-exploratory-proposals-cutover/`

Required bundle files:

- `bundle.yml`
- `evidence.md`
- `commands.md`
- `validation.md`
- `inventory.md`
