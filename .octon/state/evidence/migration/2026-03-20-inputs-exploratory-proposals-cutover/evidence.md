# Inputs/Exploratory/Proposals Cutover Evidence (2026-03-20)

## Scope

Single-promotion atomic migration implementing Packet 9
`inputs-exploratory-proposals`:

- rename architecture proposal packages to unnumbered `proposal_id`-matched
  directories
- rewrite proposal registry paths and repo-authored historical references
- ratify the integrated proposal workspace contract in active docs and
  standards
- harden proposal validators, schemas, templates, and workflow runner tests
- finalize archive metadata for the superseded extension sidecar proposal
- relocate engine runtime source-build cache output to
  `generated/.tmp/engine/build/runtime-crates-target`

## Cutover Assertions

- `inputs/exploratory/proposals/<kind>/<proposal_id>/` is now the only active
  proposal-package path model.
- Architecture packet numbering is no longer encoded in on-disk proposal
  paths.
- `generated/proposals/registry.yml` points only at unnumbered architecture
  proposal directories and remains non-authoritative.
- Proposal validators accept absolute and repo-root-relative package paths
  consistently.
- Proposal workflow runner fixtures no longer depend on the broken framework
  engine cache path.
- `framework/engine/_ops/state/**` is no longer used as a runtime source-build
  cache location.

## Receipts And Evidence

- Proposal:
  `/.octon/inputs/exploratory/proposals/architecture/inputs-exploratory-proposals/`
- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-20-inputs-exploratory-proposals-cutover/plan.md`
- ADR:
  `/.octon/instance/cognition/decisions/052-inputs-exploratory-proposals-atomic-cutover.md`
