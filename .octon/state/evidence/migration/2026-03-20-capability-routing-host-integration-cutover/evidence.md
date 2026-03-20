# Capability Routing And Host Integration Cutover Evidence (2026-03-20)

## Scope

Single-promotion atomic migration implementing Packet 12
`capability-routing-host-integration`:

- upgrade capability routing publication to `v2`
- tighten locality scope routing hints to `octon-locality-scope-v2`
- upgrade extension effective publication to `v3` with `routing_exports`
- replace symlink-era host surfaces with materialized projections for
  `.claude/.cursor/.codex`
- update active docs, templates, workflows, and validators to the generated
  routing model

## Cutover Assertions

- `generated/effective/capabilities/**` is the only live routing authority.
- Capability manifests/registries now declare explicit `routing` and
  `host_adapters` metadata.
- `state/control/extensions/**` plus
  `generated/effective/extensions/catalog.effective.yml` publish `v3`
  extension outputs with `routing_exports`.
- Host command and skill surfaces are materialized copies, not symlinks.
- `.codex/commands/**` now exists as a projected host surface.
- Routing and host validation fail closed on stale locality or extension
  linkage, raw `inputs/**` leakage, or projection drift.

## Receipts And Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-20-capability-routing-host-integration-cutover/plan.md`
- ADR:
  `/.octon/instance/cognition/decisions/056-capability-routing-and-host-integration-atomic-cutover.md`
- Live routing outputs:
  `/.octon/generated/effective/capabilities/`
