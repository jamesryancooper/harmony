# Decision Record Plan

## Purpose

Durable decisions produced by this packet should be recorded in repo-authoritative decision surfaces, not left inside the proposal packet.

## Proposed decision records

| Decision record | Proposed durable location | Purpose | Timing |
|---|---|---|---|
| Frontier governance target-state adoption | `.octon/instance/cognition/decisions/<next>-frontier-governance-target-state.md` | Accept/reject/adapt the packet's target-state architecture. | After review acceptance. |
| Support-target vocabulary reconciliation | `.octon/instance/cognition/decisions/<next>-support-target-vocabulary-reconciliation.md` | Record chosen support mode vocabulary and schema/file/charter migration. | Phase 0. |
| Overlay registry truth alignment | `.octon/instance/cognition/decisions/<next>-overlay-registry-truth-alignment.md` | Record canonical overlay source and doc/manifest update approach. | Phase 0. |
| Context-pack first-class contract | `.octon/instance/cognition/decisions/<next>-context-pack-contract.md` | Approve context-pack schema, evidence path, and generated-source guardrails. | Phase 1. |
| Risk/materiality classifier | `.octon/instance/cognition/decisions/<next>-risk-materiality-classifier.md` | Approve classifier dimensions and policy effects. | Phase 1. |
| Workflow simplification disposition | `.octon/instance/cognition/decisions/<next>-workflow-catalog-simplification.md` | Record workflow core/optional/deprecated/delete classifications. | Phase 2. |
| Browser/API stage-to-live criteria | `.octon/instance/cognition/decisions/<next>-browser-api-support-admission.md` | Record runtime/evidence/support requirements for live claims. | Phase 3. |
| Benchmark and proof-plane certification | `.octon/instance/cognition/decisions/<next>-frontier-benchmark-certification.md` | Record benchmark model and acceptance thresholds. | Phase 5. |

## Decision record requirements

Each decision should include:

- source proposal id;
- source review artifact path;
- accepted/deferred/rejected motions;
- affected durable surfaces;
- support-target effect;
- evidence produced;
- rollback/reversal path;
- closure status.

## Non-goal

Decision records must not cite this packet as ongoing runtime authority after promotion. They may cite it as historical lineage.
