# Root Manifest, Profiles, And Export Semantics Cutover Evidence (2026-03-20)

## Scope

Retrospective closeout migration implementing Packet 2
`root-manifest-profiles-and-export-semantics`:

- record the already-landed `octon.yml` root-manifest contract
- record the live profile/export behavior and companion manifest linkage
- retire the completed proposal package into the proposal archive

## Cutover Assertions

- `/.octon/octon.yml` is the canonical root manifest.
- `bootstrap_core`, `repo_snapshot`, `pack_bundle`, and `full_fidelity` are
  the live profile set.
- `repo_snapshot` remains behaviorally complete and fail closed.
- Packet 2 no longer needs to remain an active proposal package.

## Receipts And Evidence

- Proposal:
  `/.octon/inputs/exploratory/proposals/.archive/architecture/root-manifest-profiles-and-export-semantics/`
- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-20-root-manifest-profiles-and-export-semantics-cutover/plan.md`
- ADR:
  `/.octon/instance/cognition/decisions/053-root-manifest-profiles-and-export-semantics-atomic-cutover.md`
