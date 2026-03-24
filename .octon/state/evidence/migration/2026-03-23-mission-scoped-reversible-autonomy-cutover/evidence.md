# Mission-Scoped Reversible Autonomy Cutover Evidence (2026-03-23)

## Scope

Atomic promotion of Mission-Scoped Reversible Autonomy into durable Octon
runtime, governance, mission authority, validation, and generated cognition
surfaces.

## Cutover Assertions

- `octon.yml` publishes mission registry, mission control root, ownership
  registry, and mission autonomy policy as runtime inputs.
- Mission authority is upgraded to `octon-mission-v2` and discovery to
  `octon-mission-registry-v2`.
- Repo-owned mission autonomy policy and ownership registry exist as durable
  authority.
- Autonomous workflow execution requires mission autonomy context and records
  that context in `execution-receipt-v2` and `policy-receipt-v2`.
- Canonical mission control, continuity, retained control evidence, and
  derived mission/operator summaries resolve under the declared class roots.
- Mission-autonomy validators, alignment profile wiring, and architecture
  conformance CI coverage exist together with the runtime and docs changes.

## Receipts And Evidence

- Validation receipts: `validation.md`
- Command log: `commands.md`
- Change inventory: `inventory.md`
- ADR:
  `/.octon/instance/cognition/decisions/063-mission-scoped-reversible-autonomy-atomic-cutover.md`
- Migration plan:
  `/.octon/instance/cognition/context/shared/migrations/2026-03-23-mission-scoped-reversible-autonomy-cutover/plan.md`
