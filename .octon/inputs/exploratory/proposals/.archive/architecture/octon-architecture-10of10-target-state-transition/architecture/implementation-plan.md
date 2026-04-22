# Implementation Plan

This plan is ordered to preserve Octon's current governance boundaries while closing the architecture gaps that prevent a 10/10 score.

## Phase 0 — Proposal acceptance and guardrails

### Tasks

1. Confirm this packet remains under `inputs/exploratory/proposals/architecture/**` until promotion.
2. Confirm no runtime, policy, support, publication, or control path consumes this packet directly.
3. Register the proposal in the generated/discovery-only proposal registry after packet creation if the repository's proposal publishing process requires it.
4. Create a promotion worktree or branch dedicated to the 10/10 transition.

### Exit criteria

- Packet reviewed as a proposal.
- Promotion targets acknowledged.
- No proposal artifact is treated as authority.

## Phase 1 — Contract hardening

### Tasks

1. Add `runtime-effective-artifact-handle-v1.md` and schema.
2. Add route-bundle lock v2 schema with explicit `freshness.mode`.
3. Add publication freshness gates v3.
4. Add architecture-health contract v2.
5. Update runtime-resolution spec to require handle-based generated/effective consumption.
6. Update fail-closed and evidence obligations for handle/freshness/proof/cutover evidence.
7. Update contract registry to include new path families, validators, doc targets, and publication targets.

### Exit criteria

- Contracts distinguish authored authority, mutable state/control, retained evidence, generated runtime-effective handles, generated operator read models, compatibility projections, and historical evidence.
- Freshness no longer depends on fake far-future TTL semantics.

## Phase 2 — Runtime resolver and authorization hardening

### Tasks

1. Implement a single resolver API for generated/effective runtime handles.
2. Prohibit raw-path runtime consumption of generated/effective route bundles, pack routes, extension catalogs, and support matrices.
3. Enforce source digests, generation IDs, receipt references, invalidation conditions, and freshness mode.
4. Require successful handle verification before `authority_engine` emits grants.
5. Add negative-control tests for stale source digest, missing receipt, widened pack route, quarantined extension, and retired projection access.

### Exit criteria

- Grants fail closed on stale, widened, missing, unverified, or raw-path generated/effective inputs.
- Runtime and validators agree on the same effective-artifact handle model.

## Phase 3 — Material side-effect coverage automation

### Tasks

1. Add a runtime side-effect discovery pass for CLI commands, services, workflows, publication scripts, and extension publishers.
2. Regenerate `material-side-effect-inventory.yml` with source classification: discovered, static, manual exception.
3. Regenerate `authorization-boundary-coverage.yml` with request-builder, receipt, and negative-control coverage.
4. Fail architecture health when any material side-effect path lacks coverage.

### Exit criteria

- Every material side effect is covered by `authorize_execution` or explicitly denied/stage-only with evidence.
- Inventory drift fails validation.

## Phase 4 — Capability-pack simplification

### Tasks

1. Freeze `instance/capabilities/runtime/packs/**` as compatibility projection only.
2. Remove or downgrade steady-state references to this root as a runtime authority surface.
3. Ensure runtime pack routing consumes only `generated/effective/capabilities/pack-routes.effective.yml` through the handle API.
4. Update retirement register with cutover status and evidence refs.
5. Update non-authority register to mark retained pack projections as compatibility-only.

### Exit criteria

- Framework pack contracts, instance pack governance, generated/effective pack routes, and support targets have non-overlapping roles.
- Pack admission cannot widen support claims.

## Phase 5 — Extension lifecycle hardening

### Tasks

1. Route extension runtime visibility through generated/effective handle checks.
2. Add negative-control tests for selected-but-not-active, active-but-unpublished, published-but-stale, and quarantined extension states.
3. Expand active/quarantine validation to prove desired, active, quarantine, publication, and generated/effective catalog alignment.

### Exit criteria

- Extension selection is never confused with activation or runtime-effective publication.
- Quarantine state fails closed.

## Phase 6 — Proof-plane maturity

### Tasks

1. Define executable proof bundle minimum fields: scenario, command/harness invocation, input digest, output digest, evaluator version, pass/fail criteria, negative controls, retained traces, replay refs, support tuple, and claim effect.
2. Update support-dossier proofing to require executable proof bundles.
3. Add automatic support downgrade when proof is stale, shallow, missing, or inconsistent with runtime-effective state.
4. Add proof-bundle executability validator.

### Exit criteria

- Support claims are backed by falsifiable evidence, not summary pass files alone.
- Support cards and generated matrices cannot widen claims beyond proof-backed dossiers.

## Phase 7 — Architecture-health v2

### Tasks

1. Add depth classes: existence, schema, semantic, runtime, proof, and closure-grade.
2. Require closure-grade pass for 10/10 target transition.
3. Make `octon doctor --architecture` fail when a required area is only existence/schema-level.
4. Emit a retained architecture-health certificate under `state/evidence/validation/architecture/10of10-target-transition/closure/`.

### Exit criteria

- Architecture health proves enforcement, not merely artifact presence.

## Phase 8 — Operator/read-model traceability

### Tasks

1. Generate architecture map, route map, support-pack-route map, and compatibility-retirement map.
2. Include canonical refs, source digests, publication receipts, freshness metadata, and non-authority notices.
3. Validate read-model traceability and prohibit policy/runtime/support consumption.

### Exit criteria

- Operators can inspect architecture without mistaking generated maps for authority.

## Phase 9 — Cutover and publication

### Tasks

1. Run all validators and negative controls.
2. Publish regenerated route bundle, pack routes, extension catalog, and support matrix.
3. Publish generated/cognition maps.
4. Retain publication receipts and architecture closure certificate.
5. Archive proposal when durable promoted surfaces no longer depend on it.

### Exit criteria

- All acceptance criteria pass.
- Proposal is ready for retirement or historical retention as non-authoritative evidence.
