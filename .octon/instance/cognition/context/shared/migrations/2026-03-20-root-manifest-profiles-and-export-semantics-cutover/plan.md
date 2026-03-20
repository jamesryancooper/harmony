---
title: Root Manifest, Profiles, And Export Semantics Atomic Cutover
description: Retrospective closeout record for promoting and archiving Packet 2 root manifest and profile behavior.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-20
- Version source(s): `/.octon/octon.yml`
- Current version: `0.5.1`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - downtime tolerance: not applicable; this is archival closeout for an
    already-landed contract
  - external consumer coordination ability: not required
  - data migration/backfill needs: none beyond evidencing the landed state
  - rollback mechanism: full revert of the closeout change set
  - blast radius and uncertainty: low; evidence and lifecycle-state closure
  - compliance/policy constraints: preserve the already-landed root-manifest
    and profile contract without introducing shims
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no staged coexistence requirement
  - no data backfill requirement
- Tie-break status: `atomic` selected without exception

## Implementation Plan

- Name: Root manifest/profile archival closeout
- Owner: `architect`
- Motivation: Record the durable Packet 2 contract and retire the completed
  proposal package into the archive.
- Scope: archival metadata, ADR/evidence linkage, registry state, and proposal
  lifecycle closeout.

## Impact Map (code, tests, docs, contracts)

### Code

- none beyond proposal/archive metadata

### Tests

- proposal standard validation
- harness alignment/profile checks

### Docs

- proposal lifecycle records
- migration evidence
- ADR discovery index

### Contracts

- `octon.yml` root-manifest and profile contract (already live)

## Compliance Receipt

- [x] Exactly one profile selected before implementation
- [x] Release-state gate applied
- [x] No compatibility shim introduced
- [x] Required validations linked

## Exceptions/Escalations

- Current exceptions: none
- Escalations raised: none
- Risk acceptance owner: Octon maintainers

## Verification Evidence

Required evidence bundle location:

- `/.octon/state/evidence/migration/2026-03-20-root-manifest-profiles-and-export-semantics-cutover/`
