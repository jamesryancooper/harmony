# Implementation Plan

## Stabilization principle

Land the target state by stabilizing authority truth first, then runtime gates, then context/recovery, then browser/API and assurance automation. Do not add new live capability claims before proof surfaces exist.

## Phase 0 — Authority truth alignment and fail-closed cleanup

**Goal:** remove contradictions that undermine support, overlay, and proposal correctness.

1. Reconcile support-target vocabulary across:
   - `.octon/instance/governance/support-targets.yml`
   - `.octon/framework/constitution/support-targets.schema.json`
   - `.octon/framework/constitution/CHARTER.md`
   - `.octon/framework/constitution/charter.yml`
2. Make tuple admissions the operational support truth.
3. Align `.octon/README.md`, `framework/overlay-points/registry.yml`, and `instance/manifest.yml`.
4. Reconcile cognition runtime index with actual implemented runtime surfaces.
5. Quarantine or stage-only the experimental external model adapter.
6. Regenerate proposal registry and validate this packet.
7. Add drift validators for support vocabulary, overlay points, cognition runtime, and active adapter discovery.

**Proof prerequisites:** schema validation, overlay validation, proposal validation, support-target validation.

**Exit criteria:** no known authority drift remains in support/overlay/cognition/experimental-adapter surfaces.

## Phase 1 — Minimum frontier-native run core

**Goal:** make consequential runs context-, risk-, rollback-, and evidence-aware.

1. Add `risk-materiality-v1.schema.json` and instance policy.
2. Add `context-pack-v1.schema.json` and run evidence receipt path.
3. Extend execution request/grant/receipt with context-pack, materiality, pack, rollback, budget, and evidence refs.
4. Add `rollback-plan-v1.schema.json` and require rollback/compensation posture before material actions when materiality requires it.
5. Expand execution budgets from workflow-stage/provider rules to run/mission/model/tool/browser/API budgets.
6. Expand network egress policy into connector leases or keep API pack stage-only.
7. Ensure every material path calls `authorize_execution` and emits receipt requirements.

**Dependencies:** Phase 0 support/overlay cleanup; schema versioning decision for execution request/grant/receipt compatibility.

**Exit criteria:** a repo-consequential reference run produces context pack, risk/materiality classification, grant, receipt, rollback posture, replay pointers, and evidence classification.

## Phase 2 — Simplification and deletion pass

**Goal:** remove or demote older-model scaffolding while preserving governance.

1. Audit workflow manifest entries and classify each as:
   - core governance workflow;
   - optional practice/workflow pack;
   - deprecated compatibility workflow;
   - delete.
2. Update agency docs and registries to make one orchestrator, bounded specialists, and optional verifier the future actor model.
3. Update capability README/practices to teach two conceptual classes while retaining detailed contracts.
4. Move token/progressive-disclosure rationale into context-pack budget policy and degraded-model profile guidance.
5. Add validators forbidding generated cognition as authority and blocking proposal-path dependencies in durable targets.

**Dependencies:** Phase 1 context-pack and risk/materiality contracts.

**Exit criteria:** deleted/demoted workflows have safe replacements, and retained workflows each cite an authority/evidence/recovery/publication purpose.

## Phase 3 — Browser/API/multimodal runtime admission

**Goal:** make boundary-sensitive external action support real or keep it stage-only.

1. Implement or explicitly stage-only `browser-session` runtime service.
2. Implement or explicitly stage-only `api-client` runtime service.
3. Add browser/UI execution record schema and retained evidence emission.
4. Add API egress record schema, connector lease registry, redaction policy, idempotency classification, and compensation obligations.
5. Add negative tests and lab scenarios for browser/API packs.
6. Add support dossiers for every admitted browser/API tuple.
7. Update `services/manifest.runtime.yml` only after executable services and evidence pass.

**Dependencies:** Phase 0 support truth; Phase 1 materiality/context/rollback; Phase 2 capability simplification.

**Exit criteria:** browser/API claims either remain explicitly stage-only or have runtime service entries, conformance tests, replay evidence, support dossiers, and HarnessCard coverage.

## Phase 4 — Recovery, rollback, and intervention quality

**Goal:** validate long-running, high-consequence operation.

1. Exercise mission control leases.
2. Exercise control directives: pause, narrow, revoke, safing mode, resume.
3. Exercise circuit breaker trip/reset with retained evidence.
4. Run rollback and compensation drills for repo mutation, browser pre-submit, API partial failure, stale context, and support denial.
5. Add intervention latency, safe-boundary, and recovery-quality metrics.
6. Add retained evidence for recovery drills under `state/evidence/lab/**` and run evidence roots.

**Dependencies:** Phases 1 and 3.

**Exit criteria:** recovery and intervention suite passes and produces retained evidence.

## Phase 5 — Assurance and benchmark automation

**Goal:** prove Octon's governance value against frontier baselines.

1. Add benchmark-suite contract.
2. Define raw frontier-model, thin-wrapper, Octon-governed, Octon+verifier, and degraded/local model baselines.
3. Add governance-compliance graders.
4. Add evidence-completeness graders.
5. Add replayability and rollback scoring.
6. Generate RunCards and HarnessCards from retained evidence.
7. Gate support claims and releases on benchmark/assurance status.

**Dependencies:** Phases 1–4.

**Exit criteria:** target-state certification bundle exists for at least one admitted repo-consequential tuple and one boundary-sensitive staged scenario.

## Phase 6 — Portability hardening

**Goal:** express support honestly across frontier-native and degraded tiers.

1. Define frontier-native support tier.
2. Define degraded/local tier and stricter review requirements.
3. Require tuple-level support evidence before support publication.
4. Narrow adapter declarations to proven scope.
5. Add contamination/reset receipts for long-running model contexts.
6. Add support-target CI enforcement and generated projection freshness.

**Dependencies:** support-target schema fixed; benchmark suite active.

**Exit criteria:** support matrix is a truthful proof-backed finite admitted universe with generated discovery only.
