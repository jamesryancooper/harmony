---
title: Harness Integrity Tightening Atomic Cutover
description: Atomic clean-break migration plan for re-rooting runtime writes, removing broad default egress, adding spend governance, and enforcing architecture conformance.
---

# Migration Plan

## Profile Selection Receipt

- Date: 2026-03-22
- Version source(s): `/.octon/octon.yml`
- Current version: `0.5.2`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Selection facts:
  - downtime tolerance: one-step cutover is acceptable because the affected
    surfaces are internal Octon runtime, governance, assurance, and CI
    contracts
  - external consumer coordination ability: not required; all direct consumers
    are repo-local engine code, repo-local policy, repo-local docs, and
    repo-local validators
  - data migration/backfill needs: low; the cutover normalizes current write
    roots and retained artifacts but does not require a staged historical data
    migration
  - rollback mechanism: full revert of the cutover change set and regeneration
    of any affected effective outputs
  - blast radius and uncertainty: high; engine config, authorization,
    trace/state writes, policy wiring, assurance gates, docs, and CI must all
    move together
  - compliance/policy constraints: fail closed on framework-local runtime
    writes, broad default egress, missing retained egress or cost evidence,
    and registry/doc/test skew
- Hard-gate outcomes:
  - no zero-downtime requirement
  - no staged coexistence requirement
  - no external data backfill requirement
- Tie-break status: `atomic` selected without exception

## Implementation Plan

- Name: Harness integrity tightening atomic cutover
- Owner: `architect`
- Motivation: Promote the harness-integrity-tightening proposal so Octon's live
  runtime, policy, assurance, and documentation surfaces finally converge on
  the already-declared super-root and execution-governance model.
- Scope: engine runtime config and consumers, retained execution evidence
  placement, repo-owned egress and budget policy surfaces, mutable execution
  control state, architecture-conformance validators and CI, aligned runtime
  docs, migration evidence, and proposal closeout.

### Atomic Profile Execution

- Clean-break approach:
  - replace `RuntimeConfig.state_dir` in the same change set that updates every
    current consumer in `octon_core`, `octon_kernel`, and `octon_wasm_host`
  - bind all retained run artifacts from `authorize_execution(...)` so trace,
    egress, and cost evidence converge on one canonical run root
  - remove default `net.http` only when repo-owned destination policy and
    retained egress evidence ship in the same window
  - land spend governance only with authored policy, mutable state, retained
    evidence, and machine-enforced stage/deny behavior
  - flip registry, validators, CI, and docs together so no prose-only interim
    state survives
  - archive the proposal in the same promotion window as the durable cutover
- Big-bang implementation steps:
  - add `framework/cognition/_meta/architecture/contract-registry.yml` and
    declare canonical execution write roots, policy roots, doc surfaces, and
    blocking checks
  - replace `RuntimeConfig.state_dir` in
    `framework/engine/runtime/crates/core/src/config.rs` with explicit
    retained-run, execution-control, and generated-scratch roots
  - update `framework/engine/runtime/crates/core/src/trace.rs`,
    `framework/engine/runtime/crates/kernel/src/authorization.rs`,
    `framework/engine/runtime/crates/kernel/src/main.rs`,
    `framework/engine/runtime/crates/kernel/src/stdio.rs`, and
    `framework/engine/runtime/crates/wasm_host/src/invoke.rs` to consume the
    explicit roots
  - re-home mutable KV state under `state/control/execution/**`, keep rebuildable
    scratch under `generated/.tmp/execution/**`, and route retained traces to
    `state/evidence/runs/<run_id>/trace.ndjson`
  - add fail-closed write-root enforcement so runtime code cannot write under
    `framework/**`
  - remove `net.http` from `framework/engine/runtime/config/policy.yml`
    defaults and add repo-owned `instance/governance/policies/network-egress.yml`
    plus `state/control/execution/exception-leases.yml`
  - emit retained `network-egress.ndjson` and evaluate outbound access against
    destination-scoped rules only
  - add repo-owned `instance/governance/policies/execution-budgets.yml`,
    mutable `state/control/execution/budget-state.yml`, retained
    `state/evidence/runs/<run_id>/cost.json`, and machine-readable budget
    reason codes
  - add architecture-conformance validation under
    `framework/assurance/runtime/**`, wire it into
    `validate-runtime-effective-state.sh` and `alignment-check.sh`, and add a
    blocking GitHub workflow
  - update architecture/bootstrap/runtime docs, record the cutover ADR,
    materialize the migration evidence bundle, update the proposal registry,
    and archive the proposal package
- Big-bang rollout steps:
  - implement the full cutover on one branch with no partial landing of mixed
    write-root or mixed egress semantics
  - regenerate any affected effective outputs or retained publication metadata
    in the same branch as the runtime and policy changes
  - run the full validator and test stack before promotion
  - promote only when code, tests, docs, contracts, generated outputs, and
    retained evidence are coherent
  - archive the proposal immediately after promotion and treat any legacy
    runtime write-path reintroduction as a blocking regression

## Impact Map (Code, Tests, Docs, Contracts)

### Code

- `framework/engine/runtime/crates/core/src/config.rs`
- `framework/engine/runtime/crates/core/src/trace.rs`
- `framework/engine/runtime/crates/kernel/src/authorization.rs`
- `framework/engine/runtime/crates/kernel/src/main.rs`
- `framework/engine/runtime/crates/kernel/src/stdio.rs`
- `framework/engine/runtime/crates/wasm_host/src/invoke.rs`
- `framework/engine/runtime/config/policy.yml`
- `framework/engine/runtime/config/policy-interface.yml`
- `instance/governance/policies/network-egress.yml`
- `instance/governance/policies/execution-budgets.yml`
- `state/control/execution/**`
- `framework/assurance/runtime/**`
- `.github/workflows/architecture-conformance.yml`

### Tests

- targeted Rust coverage for `octon_core`, `octon_kernel`,
  `octon_wasm_host`, and `policy_engine`
- focused shell regressions for write-root drift, egress drift, budget drift,
  and registry/doc skew
- `validate-framework-core-boundary.sh`
- `validate-execution-governance.sh`
- `validate-runtime-effective-state.sh`
- `alignment-check.sh --profile harness`

### Docs

- `framework/cognition/_meta/architecture/specification.md`
- `framework/cognition/_meta/architecture/runtime-vs-ops-contract.md`
- `framework/engine/README.md`
- `instance/bootstrap/START.md`
- `framework/engine/runtime/spec/policy-interface-v1.md`
- `framework/engine/runtime/spec/policy-receipt-v1.schema.json`
- any live contributor guidance that still describes advisory-only budget
  handling or legacy execution write roots
- ADR, migration evidence, and proposal lifecycle records

### Contracts

- explicit execution write-root contract
- repo-owned destination-scoped egress contract
- repo-owned execution-budget contract
- machine-readable architecture contract registry
- blocking architecture-conformance assurance and CI contract

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
- Escalations raised: none during planning; implementation may require an
  escalated rerun if host projection refresh or other environment-owned
  validation writes are needed
- Risk acceptance owner: Octon maintainers

## Verification Evidence

### Static Verification

- [x] No runtime write path resolves under `framework/**`
- [x] No default `execution/flow` grant includes `net.http`
- [x] Registry, docs, and blocking checks reference the same canonical roots

### Runtime Verification

- [x] Retained traces, egress logs, and cost evidence terminate under
  `state/evidence/runs/**`
- [x] Mutable execution state terminates under `state/control/execution/**`
- [x] Generated scratch terminates under `generated/.tmp/execution/**`
- [x] Protected execution and stage/deny behavior follow repo-owned egress and
  budget policy

### CI Verification

- [x] Architecture-conformance workflow passes
- [x] `validate-execution-governance.sh` passes
- [x] `validate-runtime-effective-state.sh` passes
- [x] `alignment-check.sh --profile harness` passes

Required evidence bundle location:

- `/.octon/state/evidence/migration/2026-03-22-harness-integrity-tightening-cutover/`
- bundle files:
  - `bundle.yml`
  - `evidence.md`
  - `commands.md`
  - `validation.md`
  - `inventory.md`

## Rollback

- Rollback strategy: revert the atomic cutover as one change set, regenerate
  any affected effective outputs, and remove any newly emitted execution
  control or scratch artifacts created only by the aborted cutover
- Rollback trigger conditions: any validation failure showing framework-local
  runtime writes, ambient default egress, missing required cost evidence, or
  registry/doc/test divergence after the cutover change set lands
- Rollback evidence references: this migration plan, the cutover ADR, and the
  retained validation bundle produced during promotion
