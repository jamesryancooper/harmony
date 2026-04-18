# Evidence Plan

## Evidence objective

Implementation of this proposal must be proven by retained evidence, not by prose claims. Evidence belongs under `state/evidence/**`, generated projections remain rebuildable, and proposal files remain non-canonical.

## Evidence families

| Evidence family | Proposed retained location | Producer | Required for |
|---|---|---|---|
| Proposal validation receipt | `state/evidence/validation/proposals/` | proposal validator | Packet closeout. |
| Support-target validation receipt | `state/evidence/validation/governance/support-targets/` | support validator | Phase 0 closeout. |
| Overlay validation receipt | `state/evidence/validation/governance/overlay-points/` | overlay validator | Phase 0 closeout. |
| Cognition runtime validation receipt | `state/evidence/validation/cognition/` | cognition drift validator | Phase 0 closeout. |
| Context-pack receipt | `state/evidence/runs/<run-id>/context-pack.receipt.json` | context assembler | Consequential run. |
| Risk/materiality receipt | `state/evidence/runs/<run-id>/risk-materiality.receipt.json` | risk classifier | Material actions. |
| Grant bundle | `state/evidence/control/execution/` and run evidence root | authorization engine | Material actions. |
| Execution receipt | `state/evidence/runs/<run-id>/receipts/**` | runtime | Every material attempt. |
| Replay pointers | `state/evidence/runs/<run-id>/replay-pointers.yml` | runtime/replay store | Replayability. |
| Trace pointers | `state/evidence/runs/<run-id>/trace-pointers.yml` | telemetry sink | Debugging and assurance. |
| Rollback evidence | `state/evidence/runs/<run-id>/rollback/**` | recovery service | Material actions requiring rollback. |
| Browser/UI record | `state/evidence/runs/<run-id>/browser-ui/**` | browser service | Browser pack support. |
| API egress record | `state/evidence/runs/<run-id>/api-egress/**` | API service | API pack support. |
| Lab scenario evidence | `state/evidence/lab/scenarios/**` | lab runner | HarnessCard. |
| Benchmark evidence | `state/evidence/lab/benchmarks/**` | benchmark runner | Comparative proof. |
| RunCard | `state/evidence/runs/<run-id>/run-card.yml` | assurance generator | Run certification. |
| HarnessCard | `state/evidence/lab/harness-cards/**` | assurance generator | Support certification. |
| Promotion dependency scan | `state/evidence/validation/promotion-dependency-scan/` | promotion validator | Archive readiness. |

## Evidence completeness checks

A consequential run is evidence-complete only if it has:

- execution request;
- context pack;
- risk/materiality classification;
- grant or denial;
- receipt for each material attempt;
- side-effect record;
- rollback/compensation posture when required;
- replay pointers;
- trace pointers;
- evidence classification;
- disclosure artifact if externally visible or support-relevant;
- RunCard.

## Evidence quality rules

- Evidence must be retained, not generated.
- Evidence links must be machine-readable.
- Evidence must record denials and escalations, not only successes.
- Evidence must record human interventions as control/evidence artifacts.
- Evidence must record support tuple and capability pack set.
- Evidence must distinguish authoritative source from derived read model.

## Proof gaps to close

- Browser/API replay evidence.
- Connector egress evidence.
- Raw-vs-Octon frontier benchmark evidence.
- Support dossier completeness evidence.
- Recovery drill evidence.
- Context-pack freshness/generation lock evidence.
