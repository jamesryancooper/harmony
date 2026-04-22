# Target Architecture

## Target-state thesis

Octon's 10/10 architecture is the current constitutional harness architecture made closure-grade: fewer ambiguous compatibility surfaces, one enforced runtime-effective handle path, explicit digest-bound freshness, executable proof bundles, deeper architecture-health validation, stronger non-authority coverage, and generated navigation maps that improve legibility without minting authority.

The target state preserves the core architecture. It does not replace the constitutional kernel, does not create a new control plane, and does not collapse repo-native authority into generated, host, chat, or proposal surfaces.

## 10/10 target-state invariants

1. **Authority remains class-rooted.** Durable authored authority may live only in `framework/**` and `instance/**`; mutable execution truth remains in `state/control/**`; retained evidence remains in `state/evidence/**`; continuity remains in `state/continuity/**`; generated surfaces remain derived-only; inputs remain non-authoritative.
2. **Runtime-effective generated outputs are handles, not authority.** Runtime may consume generated/effective outputs only through a verified resolver handle that validates schema, lock, digest, receipt, source hashes, invalidation conditions, freshness mode, and allowed consumer class.
3. **Freshness is explicit and falsifiable.** Lock files must declare `freshness.mode` rather than relying on a far-future timestamp. Accepted modes are `digest_bound`, `ttl_bound`, and `receipt_bound`.
4. **Run-first lifecycle is structurally primary.** The run contract is the atomic consequential execution unit; mission remains the continuity container; workflow wrappers are compatibility or orchestration surfaces only.
5. **All material side effects prove boundary coverage.** Every material side-effect entrypoint is mapped in `material-side-effect-inventory.yml` and `authorization-boundary-coverage.yml`, auto-checked against runtime command, service, workflow, publication, and extension-publisher code paths, and denied when uncovered.
6. **Support claims are finite, partitioned, and proof-backed.** Live, stage-only, unadmitted, and retired claim states stay partitioned under support admissions and dossiers. Generated support matrices and support cards cannot widen the live claim.
7. **Capability-pack routing has one runtime-facing compiled view.** Framework pack contracts define portable contract semantics; instance governance packs declare repo-specific intent; generated/effective pack routes are the single runtime-facing route view. `instance/capabilities/runtime/packs/**` is frozen as compatibility projection or retired.
8. **Extension lifecycle remains desired / active / quarantine / published.** Raw additive extension inputs remain non-authoritative until desired selection, active materialization, quarantine check, publication, and freshness validation complete. Published effective extension catalogs are derived handles only.
9. **Proof reports become executable.** Support, runtime, governance, maintainability, publication, and architecture-health proofs must include commands or evaluator IDs, input/source digests, output digests, pass/fail criteria, negative controls, replay or trace references, and retained evidence refs.
10. **Architecture-health is depth-aware.** `octon doctor --architecture` reports existence, structural, semantic, runtime-enforcement, proof-plane, publication-freshness, operator-read-model, and compatibility-retirement grades separately. A shallow existence pass cannot masquerade as closure-grade architecture health.
11. **Non-authority registration covers all claim-adjacent projections.** The non-authority register includes generated/effective runtime handles, support cards, route maps, mission summaries, closure projections, operator digests, and generated architecture maps.
12. **Operator navigation is generated, traceable, and non-authoritative.** New generated cognition maps explain canonical sources, generated/effective handles, compatibility projections, validators, receipts, runtime consumers, and retirement posture.

## Target-state planes

| Plane | Target-state role | Canonical roots |
|---|---|---|
| Constitutional authority | Supreme repo-local authority | `framework/constitution/**` |
| Structural architecture | Registry-backed topology and doc targets | `framework/cognition/_meta/architecture/**` |
| Root manifest | Super-root anchors, profiles, runtime-resolution refs, global defaults | `octon.yml` |
| Runtime resolution | Authored selector plus compiled verified handles | `instance/governance/runtime-resolution.yml`, `generated/effective/runtime/**` |
| Execution control | Run-first lifecycle, approvals, exceptions, revocations, runtime state | `state/control/execution/**` |
| Mission continuity | Long-horizon mission authority and continuity state | `instance/orchestration/missions/**`, `state/continuity/**` |
| Support governance | Bounded live/stage-only/unadmitted/retired claims | `instance/governance/support-targets.yml`, admissions, dossiers |
| Capability packs | Portable contracts, repo intent, compiled pack routes | `framework/capabilities/packs/**`, `instance/governance/capability-packs/**`, `generated/effective/capabilities/**` |
| Extensions | Raw inputs, desired selection, active/quarantine state, compiled catalog | `inputs/additive/extensions/**`, `instance/extensions.yml`, `state/control/extensions/**`, `generated/effective/extensions/**` |
| Evidence and proof | Retained proof, receipts, RunCards, HarnessCards, validation evidence | `state/evidence/**` |
| Operator read models | Generated traceable summaries and maps | `generated/cognition/**` |

## Target-state runtime-effective handle contract

A new `runtime-effective-artifact-handle-v1` contract governs runtime-facing derived outputs.

```yaml
schema_version: runtime-effective-artifact-handle-v1
artifact_kind: runtime_route_bundle | pack_routes | support_matrix | extension_catalog | capability_routing
output_ref: .octon/generated/effective/...
lock_ref: .octon/generated/effective/...
publication_receipt_ref: .octon/state/evidence/validation/publication/...
source_refs:
  - .octon/octon.yml
  - .octon/instance/governance/runtime-resolution.yml
source_digests:
  .octon/octon.yml: <sha256>
freshness:
  mode: digest_bound
  invalidation_conditions:
    - root-manifest-sha-changed
    - runtime-resolution-sha-changed
allowed_consumers:
  - runtime_resolver
  - validators
forbidden_consumers:
  - direct_runtime_raw_path_read
  - generated_cognition_as_authority
non_authority_classification: derived-runtime-handle
```

The resolver fails closed when any field is missing, stale, digest-drifted, receipt-missing, incompatible with freshness mode, or consumed by an unauthorized runtime path.

## Target-state proof maturity

A closure-grade proof bundle must include source refs/digests, validator or evaluator version, exact command invocation or evaluator ID, pass/fail criteria, negative controls, replay or trace refs, retained evidence refs, support tuple or runtime route affected, expected claim effect, and denial/stage/allow evidence where relevant.

## Target-state compatibility posture

Compatibility surfaces may remain only if they are listed in `retirement-register.yml`, have canonical successor refs, have next review dates, carry `future_widening_blocker: true` when claim-adjacent, are listed in `non-authority-register.yml` when claim-adjacent, are not consumed directly by runtime or policy paths, and are covered by a validator or retirement-readiness check.

## Non-goals

This target state does not make generated/effective outputs authored authority, does not make proposal packets runtime inputs, does not broaden live support, does not remove stage-only/unadmitted/retired partitions, does not replace the existing Rust runtime, and does not make active docs carry full path matrices again.
