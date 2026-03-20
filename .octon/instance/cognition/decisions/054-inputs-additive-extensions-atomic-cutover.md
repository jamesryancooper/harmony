# ADR 054: Inputs/Additive/Extensions Atomic Cutover

- Date: 2026-03-20
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/inputs-additive-extensions/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-20-inputs-additive-extensions-cutover/plan.md`
  - `/.octon/instance/extensions.yml`

## Context

Packet 8 formalizes additive extension-pack placement and the
 desired/actual/quarantine/compiled split. The live repository already carried
 the Packet 8 durable outputs and the repo task ledger marked the atomic
 cutover complete, but the proposal package had no dedicated archival receipt.

That left Packet 8 in the same incomplete closeout state Packet 2 had: the
 implementation was live, but the proposal had not been retired into the
 archive with explicit evidence.

## Decision

Record Packet 8 as complete and archive the proposal.

Rules:

1. Raw additive packs remain under `inputs/additive/extensions/**`.
2. Desired state remains in `instance/extensions.yml`.
3. Actual/quarantine state remains in `state/control/extensions/**`.
4. Runtime-facing compiled outputs remain in
   `generated/effective/extensions/**`.
5. The superseded sidecar-pack proposal remains archived historical input only.
6. The Packet 8 proposal package moves to `.archive/**` with an `implemented`
   disposition.

## Consequences

### Benefits

- Packet 8 now has explicit implementation closeout evidence.
- The active proposal set no longer keeps a completed extension-placement
  proposal open unnecessarily.

### Costs

- Adds retrospective cutover evidence after the durable implementation already
  landed.

### Follow-on Work

1. Future extension-pipeline changes should promote directly against the
   durable `inputs/`, `instance/`, `state/`, and `generated/` surfaces.
2. Packet 13 and Packet 14 can build on the live extension contract without
   leaving Packet 8 active.
