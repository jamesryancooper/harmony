# Risk Register

| Risk ID | Risk | Severity | Likelihood | Mitigation | Closure evidence |
|---|---|---:|---:|---|---|
| R-001 | Generated/effective route bundle becomes accidental authority. | High | Medium | Resolver-only handle API, non-authority register, raw-path denial validator. | Raw-path denial evidence. |
| R-002 | Freshness locks appear valid despite stale sources. | High | Medium | Explicit freshness modes, source digest recomputation, receipt verification. | Stale-source negative-control denial. |
| R-003 | Capability-pack admission widens beyond support claims. | High | Medium | Pack-route no-widening validator and support/pack alignment contract. | Pack-route widening denial test. |
| R-004 | Runtime pack compatibility projection remains de facto route source. | Medium | High | Freeze/retire projection, update retirement register, deny runtime consumption. | Compatibility cutover report. |
| R-005 | Support dossiers overstate maturity with summary proof. | High | Medium | Executable proof-bundle requirement and automatic downgrade. | Proof-bundle executability report. |
| R-006 | Architecture-health gate becomes false confidence. | High | Medium | Depth-aware architecture-health v2 and closure-grade requirements. | Closure certificate with depth classes. |
| R-007 | Extension selected state is confused with active/published availability. | High | Medium | Validate desired/active/quarantine/publication lifecycle and negative controls. | Extension lifecycle denial evidence. |
| R-008 | Operator maps become unofficial authority. | Medium | Medium | Operator-read-model contract, non-authority registry, forbidden consumers. | Read-model non-authority validation. |
| R-009 | Root manifest becomes overloaded. | Medium | Medium | Keep `octon.yml` as anchor only; delegate route semantics. | Contract-registry review. |
| R-010 | Complexity increases faster than enforcement maturity. | High | Medium | Retire compatibility projections, simplify pack stack, require evidence before new layers. | Complexity/retirement validation. |
| R-011 | Cutover breaks runtime due to all-at-once publication changes. | High | Low-Medium | Staged cutover, snapshot, rollback plan, dual-read warning phase. | Cutover and rollback evidence. |
| R-012 | New validators check existence but not semantics. | Medium | High | Require semantic/runtime/proof depth classification. | Architecture-health v2 report. |
| R-013 | Generated proposal registry is mistaken for proposal approval. | Medium | Low | Maintain proposal workspace non-authority notice and discovery-only registry treatment. | Proposal registry non-authority validation. |
