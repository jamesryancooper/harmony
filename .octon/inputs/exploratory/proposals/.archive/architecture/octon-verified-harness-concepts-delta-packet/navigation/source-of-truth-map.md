# Source-of-truth map

## Canonical class split

| Class | Canonical root | Meaning |
|---|---|---|
| Durable portable authority | `framework/**` | Constitution, contracts, architecture, portable invariants |
| Durable repo-specific authority | `instance/**` | Repo policy, repo contracts, ingress, runtime overlays, mission policy |
| Live mutable control truth | `state/control/**` | Run control, mission control, approvals, exceptions, revocations, current-state routing |
| Retained evidence | `state/evidence/**` | Run evidence, validation bundles, replay pointers, disclosure receipts |
| Continuity | `state/continuity/**` | Handoffs, resumable state, cross-run/mission continuity |
| Derived read models | `generated/**` | Effective, cognition, and proposal discovery outputs only |
| Exploratory lineage | `inputs/exploratory/proposals/**` | Proposal packets only; never runtime or policy truth |

## Live repo anchors used in this packet

- `/.octon/framework/constitution/**`
- `/.octon/framework/cognition/_meta/architecture/specification.md`
- `/.octon/framework/overlay-points/registry.yml`
- `/.octon/instance/manifest.yml`
- `/.octon/instance/governance/policies/mission-autonomy.yml`
- `/.octon/instance/governance/contracts/**`
- `/.octon/state/control/execution/missions/**`
- `/.octon/state/control/execution/runs/**`
- `/.octon/state/evidence/runs/**`
- `/.octon/state/evidence/validation/failure-distillation/**`
- `/.octon/generated/cognition/distillation/**`
- `/.octon/inputs/exploratory/proposals/**`

## Packet implications

1. This packet does not treat proposal-local artifacts as canonical truth.
2. The **evaluator calibration** concept is evidence-first. It must remain in `state/evidence/**` and `generated/**` until explicitly promoted into a durable contract or overlay surface.
3. The **slice-to-stage binding** concept changes consequential execution semantics and therefore must place durable meaning in `framework/**` and canonical mutable truth in `state/control/**`.
4. The **terse-objective expansion** concept is already operational through current proposal-packet lineage plus mission/run control records. No new authority family is justified.
