# File Change Map

This map identifies the expected promotion targets. It does not itself authorize changes.

## Authored authority targets

| Path | Required change | Purpose |
|---|---|---|
| `.octon/framework/cognition/_meta/architecture/contract-registry.yml` | Add target-state path families for runtime-effective handles, generated navigation maps, proof-bundle executability, and compatibility cutover. | Keep structural truth machine-readable. |
| `.octon/framework/cognition/_meta/architecture/specification.md` | Document the 10/10 target-state architecture and generated/effective handle semantics. | Human companion to registry truth. |
| `.octon/octon.yml` | Keep current anchors; add only root-level refs for new specs/validators if needed. | Avoid root-manifest overload while anchoring new global defaults. |
| `.octon/framework/constitution/obligations/fail-closed.yml` | Add explicit denial rules for raw generated/effective runtime reads, stale handle mode, weak proof bundles, and retired projection consumption. | Extend fail-closed obligations. |
| `.octon/framework/constitution/obligations/evidence.yml` | Add retained evidence requirements for 10/10 transition closure, executable proof bundles, handle freshness, and cutover. | Make proof obligations canonical. |
| `.octon/framework/engine/runtime/spec/runtime-resolution-v1.md` | Revise to require handle-based generated/effective consumption. | Strengthen runtime resolution. |
| `.octon/framework/engine/runtime/spec/runtime-effective-artifact-handle-v1.md` | New spec. | Define resolver-verified handle contract. |
| `.octon/framework/engine/runtime/spec/runtime-effective-artifact-handle-v1.schema.json` | New schema. | Machine-check handle contract. |
| `.octon/framework/engine/runtime/spec/runtime-effective-route-bundle-lock-v2.schema.json` | New or revised lock schema. | Replace fake TTL freshness with explicit freshness modes. |
| `.octon/framework/engine/runtime/spec/publication-freshness-gates-v3.md` | New or revised publication freshness spec. | Define digest/receipt/TTL/semantic invalidation gates. |
| `.octon/framework/engine/runtime/spec/architecture-health-contract-v2.md` | New contract. | Make architecture-health depth-aware and closure-grade. |
| `.octon/framework/engine/runtime/spec/material-side-effect-inventory.yml` | Regenerate from runtime paths and annotate discovered/static/manual sources. | Prevent missing side-effect paths. |
| `.octon/framework/engine/runtime/spec/authorization-boundary-coverage.yml` | Regenerate and verify against side-effect inventory. | Prove authorization coverage. |
| `.octon/instance/governance/runtime-resolution.yml` | Point to v2/v3 freshness semantics and handle contract. | Instance runtime selector remains authored. |
| `.octon/instance/governance/non-authority-register.yml` | Add derived-runtime-handle and generated-operator-map categories. | Prevent derived outputs from becoming authority. |
| `.octon/instance/governance/retirement-register.yml` | Advance runtime-pack projection retirement state and list cutover evidence. | Contain compatibility debt. |
| `.octon/instance/governance/contracts/support-pack-admission-alignment.yml` | Add runtime-effective handle and proof sufficiency requirements. | Prevent support/pack widening. |
| `.octon/instance/governance/contracts/support-target-proofing.yml` | Add executable proof bundle and automatic downgrade semantics. | Strengthen support claims. |
| `.octon/instance/governance/support-targets.yml` | No broadening unless evidence supports it; add proof sufficiency and freshness references. | Preserve bounded support realism. |

## Runtime implementation targets

| Path | Required change | Purpose |
|---|---|---|
| `.octon/framework/engine/runtime/crates/runtime_resolver/src/lib.rs` | Add handle API, freshness-mode enforcement, retired-projection non-consumption, stronger source invalidation. | Make generated/effective consumption closure-grade. |
| `.octon/framework/engine/runtime/crates/authority_engine/src/implementation/execution.rs` | Require handle verification and proof of allowed support/pack/extension state before grant. | Prevent stale/widened grants. |
| `.octon/framework/engine/runtime/crates/kernel/src/side_effects.rs` | New or expanded side-effect discovery surface. | Feed auto-generated material side-effect inventory. |
| `.octon/framework/engine/runtime/crates/kernel/src/main.rs` | Keep workflow wrappers compatibility-labeled; expose architecture-health v2 commands if needed. | Preserve run-first semantics. |

## Validator and test targets

| Path | Required change |
|---|---|
| `.octon/framework/assurance/runtime/_ops/scripts/validate-architecture-health.sh` | Add v2 depth-aware result classes. |
| `.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-route-bundle.sh` | Verify handle contract and freshness modes. |
| `.octon/framework/assurance/runtime/_ops/scripts/validate-publication-freshness-gates.sh` | Enforce publication-freshness-gates v3. |
| `.octon/framework/assurance/runtime/_ops/scripts/validate-generated-effective-freshness.sh` | Remove fake TTL acceptance; require selected freshness mode. |
| `.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-artifact-handles.sh` | New handle validator. |
| `.octon/framework/assurance/runtime/_ops/scripts/validate-no-raw-generated-effective-runtime-reads.sh` | New raw-path denial validator. |
| `.octon/framework/assurance/runtime/_ops/scripts/validate-proof-bundle-executability.sh` | New proof-depth validator. |
| `.octon/framework/assurance/runtime/_ops/scripts/validate-compatibility-retirement-cutover.sh` | New compatibility cutover validator. |
| `.octon/framework/assurance/runtime/_ops/tests/test-runtime-effective-artifact-handle-negative-controls.sh` | New negative-control tests. |
| `.octon/framework/assurance/runtime/_ops/tests/test-stale-digest-bound-route-bundle-denial.sh` | New stale-source denial test. |
| `.octon/framework/assurance/runtime/_ops/tests/test-pack-route-widening-denial.sh` | New pack-route widening denial test. |

## Generated/effective publication targets

These files are not authored authority. They are expected to be regenerated after promotion and publication.

| Path | Required publication change |
|---|---|
| `.octon/generated/effective/runtime/route-bundle.yml` | Regenerate from canonical sources after handle/freshness changes. |
| `.octon/generated/effective/runtime/route-bundle.lock.yml` | Replace fake future freshness with explicit freshness mode and updated source digests. |
| `.octon/generated/effective/capabilities/pack-routes.effective.yml` | Regenerate as sole runtime-facing pack route view. |
| `.octon/generated/effective/capabilities/pack-routes.lock.yml` | Add handle/freshness-mode metadata. |
| `.octon/generated/effective/extensions/catalog.effective.yml` | Regenerate under handle/freshness semantics. |
| `.octon/generated/effective/extensions/generation.lock.yml` | Update source digests, receipt links, invalidation conditions. |
| `.octon/generated/effective/governance/support-target-matrix.yml` | Regenerate; keep registered as non-authority. |

## Generated/cognition read-model targets

These read models improve human/operator legibility and must remain non-authoritative.

| Path | Purpose |
|---|---|
| `.octon/generated/cognition/projections/architecture-map.md` | Explain canonical/generated/compatibility/runtime-consuming surfaces. |
| `.octon/generated/cognition/projections/runtime-route-map.md` | Trace route bundle to canonical sources and resolver checks. |
| `.octon/generated/cognition/projections/support-pack-route-map.md` | Trace support tuples to pack admissions and support proof. |
| `.octon/generated/cognition/projections/compatibility-retirement-map.md` | Show compatibility surfaces and retirement status. |

## Evidence targets

| Path | Required retained evidence |
|---|---|
| `.octon/state/evidence/validation/architecture/10of10-target-transition/**` | Closure evidence for this proposal. |
| `.octon/state/evidence/validation/publication/runtime/**` | Runtime route bundle publication receipts. |
| `.octon/state/evidence/validation/publication/capabilities/**` | Pack route publication receipts. |
| `.octon/state/evidence/validation/publication/extensions/**` | Extension publication receipts. |
| `.octon/state/evidence/support/**` or dossier-linked proof roots | Executable proof bundles for support claims. |
