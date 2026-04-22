# Validation Plan

## Validation objective

Prove that Octon's target-state architecture is structurally coherent, runtime-enforced, freshness-aware, proof-backed, compatibility-contained, and operator-traceable.

## Validator families

| Family | Validator target | Required depth |
|---|---|---|
| Structural contract | class roots, contract registry, root manifest, path families | semantic |
| Runtime effective handles | route bundle, pack routes, extension catalog, support matrix | runtime |
| Publication freshness | locks, receipts, source digests, invalidation conditions, freshness modes | semantic + runtime |
| Authorization coverage | material side-effect inventory and authorization-boundary coverage | runtime |
| Capability-pack routing | framework contracts, instance governance, generated/effective pack routes | semantic + runtime |
| Extension lifecycle | desired, active, quarantine, publication, generated/effective catalog | semantic + runtime |
| Support proof | live/stage-only admissions, dossiers, support cards, proof bundles | proof |
| Operator read models | generated architecture/route/support/compatibility maps | semantic |
| Compatibility retirement | retirement register, non-authority register, consumer checks | semantic + runtime |
| Architecture health | aggregate closure gate | closure-grade |

## Required negative controls

1. Route bundle source hash mismatch must deny grant.
2. Missing route-bundle publication receipt must deny grant.
3. Fake-fresh far-future lock without explicit freshness mode must fail v2 validation.
4. Raw runtime read of `generated/effective/**` must fail.
5. Generated support matrix widening beyond support target admission must fail.
6. Pack route allowing a pack not admitted by support tuple must fail.
7. Retired runtime pack projection consumed by runtime must fail.
8. Extension selected but not active must fail runtime availability.
9. Extension active but unpublished must fail runtime availability.
10. Extension quarantined must fail runtime availability.
11. Summary-only proof bundle must fail support-claim sufficiency.
12. Operator read model consumed as policy/runtime input must fail.

## Required retained evidence

| Evidence root | Required contents |
|---|---|
| `.octon/state/evidence/validation/architecture/10of10-target-transition/structure/` | Structural contract validation. |
| `.octon/state/evidence/validation/architecture/10of10-target-transition/runtime-effective/` | Handle, route bundle, pack route, extension runtime checks. |
| `.octon/state/evidence/validation/architecture/10of10-target-transition/publication/` | Freshness, receipt, digest, publication validation. |
| `.octon/state/evidence/validation/architecture/10of10-target-transition/authorization/` | Side-effect inventory and authorization coverage. |
| `.octon/state/evidence/validation/architecture/10of10-target-transition/proof-plane/` | Executable proof-bundle validation. |
| `.octon/state/evidence/validation/architecture/10of10-target-transition/support/` | Support dossier/card/admission alignment. |
| `.octon/state/evidence/validation/architecture/10of10-target-transition/operator-read-models/` | Generated read-model traceability. |
| `.octon/state/evidence/validation/architecture/10of10-target-transition/closure/` | Final architecture-health v2 certificate. |

## Pass/fail standard

The transition passes only if all high-criticality validators pass at semantic/runtime/proof depth, not merely existence or schema depth.
