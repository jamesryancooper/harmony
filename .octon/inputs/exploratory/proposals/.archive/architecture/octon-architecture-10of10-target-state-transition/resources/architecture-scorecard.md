# Architecture Scorecard

Current-state score estimate: **8.0 / 10**.

| # | Dimension | Score | Main strength | Main limiter |
|---:|---|---:|---|---|
| 1 | Architectural clarity | 7.5 | Strong model after study. | Too many registries/projections for first-pass comprehension. |
| 2 | Conceptual coherence | 8.7 | Authority, runtime, support, evidence fit together. | Pack/extension/projection overlap. |
| 3 | Structural integrity | 8.6 | Durable class-root structure. | Compatibility surfaces still visible. |
| 4 | Registry-backed structural modeling | 8.5 | Contract registry is a real anchor. | Fragmented structural truth needs navigation. |
| 5 | Documentation-to-registry alignment | 8.0 | Docs subordinate to registries. | Active docs sometimes too thin for maintainers. |
| 6 | Root-manifest/profile portability | 8.0 | `octon.yml` anchors correct global defaults. | Practical portability proof limited. |
| 7 | Runtime-resolution/governance defaults | 8.1 | Correct root-manifest-to-selector-to-route-bundle path. | Runtime-resolution must avoid overloading root manifest. |
| 8 | Ingress/bootstrap/operator orientation | 7.6 | Ingress manifest and adapter parity are sound. | Boot path remains heavy. |
| 9 | Ingress contextual closeout gate | 7.0 | Closeout refs exist. | Boot/orientation and closeout are close enough to be fragile. |
| 10 | Separation of concerns | 8.5 | Authority/state/generated/input split is excellent. | Pack/runtime projection overlap. |
| 11 | Authority-model correctness | 9.0 | Clear precedence and non-authority treatment. | Compatibility roots need final deauthorization. |
| 12 | Governance-model strength | 8.7 | Fail-closed obligations and support bounds are strong. | Enforcement coverage must be proven everywhere. |
| 13 | Runtime architecture quality | 7.8 | Runtime resolver and authority engine are real. | Runtime maturity and coverage still emerging. |
| 14 | Mission/run/control-state model | 8.6 | Run atomicity and mission continuity are correct. | Mission-required semantics need normalization. |
| 15 | Publication model | 8.2 | Promotion/activation/publication separation is strong. | Receipts need deeper enforcement and inspection. |
| 16 | Publication freshness discipline | 7.6 | Lock/digest/receipt pattern exists. | Fake-future freshness weakens semantic honesty. |
| 17 | Generated-vs-authored discipline | 9.0 | Very strong non-authority doctrine. | Runtime-facing generated/effective surfaces require continued guardrails. |
| 18 | Capability-pack architecture | 7.4 | Good abstraction above tools/services/skills. | Too many overlapping pack surfaces. |
| 19 | Runtime pack admission architecture | 7.2 | Admission/projection exists. | Compatibility projection root creates ambiguity. |
| 20 | Extension lifecycle architecture | 8.0 | Desired/active/quarantine/publication is coherent. | Heavy and needs stronger runtime negative controls. |
| 21 | Support-target realism | 8.8 | Bounded live/stage-only/non-live claims. | Proof depth uneven. |
| 22 | Support/pack/admission alignment | 8.0 | Pack routes and support targets align. | Needs automated semantic drift detection. |
| 23 | Support dossier/card credibility | 7.4 | Dossiers and support cards are traceable. | Proof reports are often summary-like. |
| 24 | Proof-plane architecture | 7.7 | Lab/observability/evidence/support proof separated. | Executability/falsifiability incomplete. |
| 25 | Maintainability | 7.3 | Validators and registries help. | Complexity and distributed truth hurt maintainability. |
| 26 | Evolvability | 8.0 | Overlays, packs, extensions, publication support evolution. | Evolvability risks registry sprawl. |
| 27 | Scalability | 7.2 | Machine-readable surfaces scale better than prose. | Human complexity may not scale. |
| 28 | Reliability | 7.6 | Fail-closed design and resolver improve reliability. | Runtime tests/proof not yet closure-grade. |
| 29 | Recoverability/reversibility | 8.1 | Run lifecycle, checkpoints, rollback, evidence roots. | Need more demonstrated recovery scenarios. |
| 30 | Observability/inspectability | 7.8 | Observability and RunCard structures exist. | Operator UX/read models immature. |
| 31 | Evidence/auditability | 8.5 | Evidence-store spec is strong. | Evidence quality varies. |
| 32 | Portability/adapter discipline | 8.1 | Adapters are non-authoritative. | Adapter breadth narrow. |
| 33 | Extensibility | 8.0 | Extension lifecycle is governed. | Extension stack is heavy. |
| 34 | Complexity management | 6.8 | Much complexity is load-bearing. | Some complexity is architectural anxiety. |
| 35 | Boundary discipline | 8.8 | Raw/generated/host/model boundaries are strong. | Runtime-effective projection subtlety. |
| 36 | Implementation alignment | 7.7 | Runtime code implements key architecture. | Not all declared coverage is proven end-to-end. |
| 37 | Long-running governed agentic fitness | 8.3 | Mission/run/evidence/support model fits. | Operator loop/proof depth lag. |
| 38 | Runtime-effective route-bundle architecture | 8.2 | Strong compiled runtime view. | Must prevent second-authority drift. |
| 39 | Freshness enforcement realism | 7.3 | Hash/receipt verification exists. | Freshness mode and invalidation need hardening. |
| 40 | Promotion/activation/publication discipline | 8.2 | Excellent distinction. | Universal receipt enforcement needed. |
| 41 | Non-authority register quality | 7.8 | Strong anti-entropy concept. | Needs broader coverage. |
| 42 | Operator read-model traceability | 7.6 | Contract is good. | Need more useful generated maps. |
| 43 | Architecture-health gate credibility | 7.7 | Broad validator aggregation. | Depth classification and negative controls needed. |
| 44 | Compatibility-projection retirement | 8.0 | Retirement register is strong. | Some compatibility roots too prominent. |
| 45 | Deployment practicality | 6.6 | Runtime exists. | Install/cutover/product packaging immature. |

## Target-state scoring expectation

The proposal aims to move all sub-8 critical dimensions above 9 by closing concrete gaps rather than inflating scores rhetorically. The target-state score should be earned only after closure evidence passes.
