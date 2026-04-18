# Risk Register

| Risk | Description | Impact | Likelihood | Mitigation | Owner surface |
|---|---|---:|---:|---|---|
| Over-simplification | Deleting governance surfaces because they resemble old tooling. | High | Medium | Require every deletion to classify whether surface is cognition scaffolding or governance scaffolding. | Deletion matrix, ADR. |
| Under-simplification | Preserving workflows/actor/cognition bloat without governance value. | High | High | Workflow audit and removal triggers. | Orchestration manifest. |
| Support truth drift | Schema/file/charter mismatch persists. | High | High | P0 validator and release blocker. | Support targets/schema/charter. |
| Browser/API overclaim | Browser/API support treated as live before runtime/evidence exists. | High | Medium | Stage-only posture and support dossier gate. | Capability packs, service manifest. |
| Generated authority leakage | Generated cognition or effective projections become policy/approval truth. | High | Medium | Generated authority ban and context-pack labels. | Cognition spec, validators. |
| Context false confidence | Long context leads to ungoverned prompt dumps. | Medium/High | High | Context-pack contract with source hashes/freshness/omissions. | Context-pack schema. |
| Benchmark theater | Benchmarks test output quality but not governance. | Medium | Medium | Include authorization/evidence/recovery/support metrics. | Lab/assurance. |
| Runtime burden | Browser/API/recovery implementation exceeds near-term capacity. | Medium | High | Stage rollout; do not claim live support until proof exists. | Implementation plan. |
| Adapter churn | Frontier providers/hosts change rapidly. | Medium | High | Treat adapter facts as observed support facts tied to dossiers. | Adapter manifests/support dossiers. |
| Hidden human control plane | Human interventions happen in chat/UI without control evidence. | High | Medium | Require intervention/control directive artifacts. | State/control/evidence. |
| Validator brittleness | New validators block useful work due to false positives. | Medium | Medium | Stage validators in advisory then hard-enforce with fixtures. | Assurance runtime. |
| Proposal dependency leak | Durable targets cite proposal files as authority after promotion. | High | Low/Medium | Promotion dependency scan before closure. | Closure certification. |
