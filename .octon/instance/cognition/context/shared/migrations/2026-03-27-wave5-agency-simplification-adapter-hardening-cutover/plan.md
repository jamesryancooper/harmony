---
title: Wave 5 Agency Simplification And Adapter Hardening Cutover
description: Transitional migration plan for Wave 5 agency simplification and adapter hardening.
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
  - downtime tolerance: repo-local docs and validators can tolerate a staged
    cutover, but runtime support routing and agency discovery cannot drift
    across branches
  - external consumer coordination ability: low external dependency pressure,
    but live coordination is required across constitutional contracts, runtime
    policy surfaces, agency registries, and assurance gates
  - data migration and backfill needs: medium; adapter support declarations and
    validator expectations must land before runtime can fail closed on missing
    adapter envelopes
  - rollback mechanism: revert the Wave 5 change set, restore the prior
    persona-heavy agency defaults, and remove the adapter family plus support
    declarations together
  - blast radius and uncertainty: high; this cutover touches the default
    execution role, constitutional registries, runtime support routing, and
    architecture validation
  - compliance and policy constraints: no host or model adapter may become
    hidden authority during the cutover
- Hard-gate outcomes:
  - one accountable orchestrator must remain the default execution role
  - additional roles must stay justified by separation of duties, context
    isolation, or concurrency value
  - host adapters and model adapters must remain replaceable and
    non-authoritative
  - support claims must stay bounded by declared support targets and adapter
    conformance criteria
- Tie-break status: `transitional` selected because the runtime, agency, and
  validator cutover must land together while older persona-shaped assumptions
  are removed
- `transitional_exception_note`:
  - rationale: simplify the agency kernel and publish adapter contracts without
    leaving a window where runtime, docs, and validators disagree on authority
  - risks:
    - older persona-shaped references could persist in active docs or
      validators
    - runtime could accept undeclared adapter envelopes if support declarations
      and code drift
    - host projection paths could look authoritative if the adapter family and
      support matrix do not land together
  - owner: `Octon governance`
  - target_removal_date: `2026-06-30`

## Implementation Summary

- Name: Wave 5 agency simplification and adapter hardening
- Owner: Octon maintainers
- Motivation: simplify the agency kernel around one accountable orchestrator,
  retain only boundary-valued supporting roles, publish host/model adapter
  contracts, and bound adapter-backed support claims through runtime-backed
  support declarations
- Scope:
  - simplify `/.octon/framework/agency/**` around `orchestrator` and
    `verifier`
  - demote persona overlays so `SOUL.md` remains optional and
    non-authoritative
  - publish constitutional adapter contracts under
    `/.octon/framework/constitution/contracts/adapters/**`
  - publish runtime adapter manifests under
    `/.octon/framework/engine/runtime/adapters/**`
  - expand `/.octon/instance/governance/support-targets.yml` with adapter
    envelopes and conformance criteria
  - update runtime policy surfaces and validators so undeclared adapter support
    fails closed

## Transitional Execution

1. Simplify agency discovery and contracts before validator hardening removes
   older persona defaults.
2. Publish adapter contracts and support-target declarations before runtime
   starts failing closed on undeclared adapters.
3. Keep host projections explicitly non-authoritative throughout the cutover.
4. Update architecture, bootstrap, and assurance surfaces in the same branch as
   the runtime changes.

## Impact Map

### Agency and bootstrap

- `/.octon/framework/agency/**`
- `/.octon/instance/ingress/AGENTS.md`
- `/.octon/instance/bootstrap/{START.md,catalog.md,scope.md}`
- `/.octon/framework/scaffolding/runtime/templates/octon/agency/**`

### Constitution, governance, and runtime

- `/.octon/framework/constitution/{CHARTER.md,charter.yml,precedence/*.yml,obligations/*.yml,support-targets.schema.json}`
- `/.octon/framework/constitution/contracts/{registry.yml,adapters/**}`
- `/.octon/framework/engine/runtime/{README.md,config/policy-interface.yml,spec/policy-interface-v1.md,adapters/**}`
- `/.octon/framework/engine/runtime/crates/kernel/src/{authorization.rs,pipeline.rs}`
- `/.octon/instance/governance/support-targets.yml`
- `/.octon/octon.yml`

### Assurance and architecture

- `/.octon/framework/assurance/runtime/_ops/scripts/{alignment-check.sh,validate-harness-structure.sh,validate-execution-governance.sh,validate-wave5-agency-adapter-hardening.sh}`
- `/.octon/framework/assurance/runtime/contracts/alignment-profiles.yml`
- `/.octon/framework/cognition/_meta/architecture/{specification.md,contract-registry.yml}`
- `/.github/workflows/architecture-conformance.yml`

## Verification Evidence

- Validation receipts:
  `/.octon/state/evidence/migration/2026-03-27-wave5-agency-simplification-adapter-hardening-cutover/validation.md`
- Command log:
  `/.octon/state/evidence/migration/2026-03-27-wave5-agency-simplification-adapter-hardening-cutover/commands.md`
- Change inventory:
  `/.octon/state/evidence/migration/2026-03-27-wave5-agency-simplification-adapter-hardening-cutover/inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/073-wave5-agency-simplification-and-adapter-hardening-cutover.md`

## Exit Gate Status

- Wave 5 completion status: complete
- Exit gate checks:
  - kernel agency responsibilities are narrow, explicit, and runtime-backed
  - adapter families are non-authoritative and replaceable
  - support claims are bounded and evidence-backed
- Remaining active Wave 5 gaps: none

## Rollback

- revert the Wave 5 change set
- restore the prior agency registry and validation assumptions only as part of
  the same full revert
- remove the adapter contract family and adapter support declarations together
- do not leave runtime or validators in a partial state where adapter
  declarations are required but not published
