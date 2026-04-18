# Octon Frontier Governance Target-State Revalidation Plan

- `run_id`: `2026-04-18-octon-frontier-governance-target-state`
- `executed_on`: `2026-04-18`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- `cutover_mode`: `support-honest-revalidation-open`
- `selection_rationale`: Repo ingress defaults `pre-1.0` work to `atomic`. The truthful immediate action is a fail-closed corrective pass that narrows live claims before any runtime widening.
- `transitional_exception_note`: Full frontier target-state attainment remains blocked until later packet phases have real runtime substrate, retained proof, and comparative benchmark evidence.
- `proposal_packet_ref`: `/.octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state/`

## Profile Selection Receipt

- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- `rationale`: Support truth, runtime admission, and active disclosure currently disagree. One coherent corrective migration is safer than leaving a broader false live claim in place.

## Implementation Plan

1. Revalidate the packet against live repo authority and runtime surfaces.
2. Correct Phase 0 authority drift:
   - support-target vocabulary,
   - overlay truth,
   - cognition runtime discovery,
   - browser/API and frontier-boundary support overclaim.
3. Narrow the active live claim to the currently supportable tuple set.
4. Replace the false `complete` live-claim posture with an explicit recertification-open posture.
5. Record durable decisions, blockers, and rollback posture.
6. Run the available Phase 0 validator set and regenerate derived views affected by the new support truth.

## Impact Map

- `authority surfaces`:
  - `/.octon/framework/constitution/{CHARTER.md,charter.yml}`
  - `/.octon/instance/charter/{workspace.md,workspace.yml}`
  - `/.octon/instance/governance/support-targets.yml`
  - `/.octon/instance/governance/capability-packs/**`
  - `/.octon/instance/governance/disclosure/**`
  - `/.octon/instance/governance/closure/**`
- `runtime/support surfaces`:
  - `/.octon/instance/capabilities/runtime/packs/**`
  - `/.octon/framework/capabilities/packs/**`
  - `/.octon/framework/cognition/runtime/{README.md,index.yml}`
- `docs/topology surfaces`:
  - `/.octon/README.md`
- `derived/effective surfaces`:
  - `/.octon/generated/effective/governance/support-target-matrix.yml`
  - `/.octon/generated/effective/closure/{claim-status.yml,recertification-status.yml}`
- `validation surfaces`:
  - support-target and capability-pack validators
  - proposal and overlay validation reuse

## Compliance Receipt

- Proposal files remain non-authoritative and are not wired into runtime or policy.
- Authored authority stays under `framework/**` and `instance/**`; retained evidence stays under `state/**`; generated views stay under `generated/**`.
- Browser/API live support is not widened. The migration narrows claims to match the current runtime substrate.

## Exceptions / Escalations

- `hard blocker`: later packet phases remain blocked by missing truthful runtime and proof prerequisites, including context-pack integration, risk/materiality contracts, rollback-plan enforcement, browser/API runtime admission, and comparative benchmark proof.
- `safe posture`: keep the repo fail-closed, narrow the active live claim, and mark broader target-state work as recertification-open rather than complete.
