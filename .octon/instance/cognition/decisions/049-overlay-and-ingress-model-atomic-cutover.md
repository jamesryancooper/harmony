# ADR 049: Overlay And Ingress Model Atomic Cutover

- Date: 2026-03-19
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/architecture/overlay-and-ingress-model/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-19-overlay-and-ingress-model-cutover/plan.md`
  - `/.octon/framework/cognition/_meta/architecture/specification.md`

## Context

Packet 5 formalizes the overlay and ingress model that Packet 4 left
intentionally bounded but not yet fully hardened:

1. the live repository already has a framework overlay registry, repo-side
   enablement, canonical internal ingress, and reserved overlay roots,
2. active docs and bootstrap/scaffolding surfaces do not yet enumerate the
   Packet 5 contract consistently,
3. overlay validation currently proves declaration and enablement shape, but
   not actual overlay-root placement discipline or strict root-adapter
   thinness.

That leaves one remaining class-boundary risk: repo-local overlay behavior and
repo-root ingress behavior can still drift by convention rather than by one
fully enforced contract.

## Decision

Promote Packet 5 as one atomic clean-break cutover.

Rules:

1. Packet 5 lands as a single promotion event.
2. After cutover, `framework/overlay-points/registry.yml` and
   `instance/manifest.yml#enabled_overlay_points` are the only legal overlay
   declaration and enablement surfaces.
3. `instance/ingress/AGENTS.md` remains the sole authored ingress source and
   `/.octon/AGENTS.md` remains the sole projected ingress surface.
4. Root `AGENTS.md` and `CLAUDE.md` are valid only as a symlink to
   `/.octon/AGENTS.md` or a byte-for-byte parity copy.
5. No ad hoc overlay-like paths, fallback ingress authority, or staged
   compatibility shims are allowed after promotion.
6. Rollback is full-revert-only for the cutover change set.
7. If validation cannot converge to one bounded overlay and ingress contract,
   promotion is blocked and the harness fails closed.

## Consequences

### Benefits

- Deterministic overlay declaration, enablement, and precedence semantics.
- Clear separation between instance-native authority and overlay-capable
  authority.
- Fail-closed enforcement for disabled overlay roots, ad hoc overlay paths,
  and root-ingress drift.

### Costs

- Large one-shot sweep across docs, validators, tests, scaffolding, and
  workflow guidance.
- Reduced flexibility for partial rollback or soft compatibility behavior.

### Follow-on Work

1. Packet 6 can rely on stable ingress and overlay boundaries while finishing
   locality/scope ratification.
2. Packet 14 can treat overlay-point enforcement as a first-class fail-closed
   rule rather than a prose convention.
3. Packet 15 can remove any remaining legacy mixed overlay or ingress paths
   only by full contract convergence.
