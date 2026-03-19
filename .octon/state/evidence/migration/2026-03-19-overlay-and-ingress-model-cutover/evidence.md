# Overlay And Ingress Model Cutover Evidence (2026-03-19)

## Scope

Single-promotion atomic migration implementing Packet 5
`overlay-and-ingress-model`:

- harden the overlay registry and repo-side enablement contract without
  changing the class-root topology
- rewrite active architecture, bootstrap, and workflow surfaces to the Packet
  5 overlay and ingress model
- tighten root-ingress adapter enforcement to symlink/parity-copy semantics
- add fail-closed validation for disabled overlay content and ad hoc
  overlay-like paths
- record Packet 5 governance evidence in the repo’s migration and ADR ledgers

## Cutover Assertions

- `framework/overlay-points/registry.yml` remains the only overlay declaration
  surface.
- `instance/manifest.yml#enabled_overlay_points` remains the only repo-side
  overlay enablement surface.
- `instance/ingress/AGENTS.md` remains the sole authored ingress source and
  `/.octon/AGENTS.md` remains the projected ingress surface.
- Root `AGENTS.md` and `CLAUDE.md` are now validated as symlink/parity-copy
  adapters only.
- Disabled or ad hoc overlay content now fails closed.
- The generated ADR summary now refreshes into
  `instance/cognition/context/shared/decisions.md` rather than the retired
  framework cognition runtime path.
- The harness alignment profile passes with the Packet 5 checks enabled.

## Receipts and Evidence

- Proposal:
  `/.octon/inputs/exploratory/proposals/architecture/5-overlay-and-ingress-model/`
- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-19-overlay-and-ingress-model-cutover/plan.md`
- ADR:
  `/.octon/instance/cognition/decisions/049-overlay-and-ingress-model-atomic-cutover.md`

No `path-map.json` is included because this cutover hardens contracts in place
rather than moving tracked authority paths.
