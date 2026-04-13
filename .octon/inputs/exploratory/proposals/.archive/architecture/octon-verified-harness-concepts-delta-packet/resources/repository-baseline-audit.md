# Repository baseline audit

Prepared against `https://github.com/jamesryancooper/octon` @ `main` on 2026-04-13.

## 1. Current super-root and authority model

The live repo remains a single `/.octon/` super-root with class roots `framework/`, `instance/`, `inputs/`, `state/`, and `generated/`. Only `framework/**` and `instance/**` are authored authority. `state/**` is authoritative only as operational truth and retained evidence. `generated/**` is derived-only.

## 2. Current constitutional and overlay anchors

The constitutional kernel remains under `/.octon/framework/constitution/**`. The cross-subsystem umbrella contract remains `/.octon/framework/cognition/_meta/architecture/specification.md`.

The instance manifest still enables the following overlay points relevant to this packet:
- `instance-governance-policies`
- `instance-governance-contracts`
- `instance-agency-runtime`
- `instance-assurance-runtime`

## 3. Current consequential execution model

The current repo remains run-centered for consequential execution:
- run control roots under `state/control/execution/runs/**`
- mission control roots under `state/control/execution/missions/**`
- mission continuity under `state/continuity/repo/missions/**`

This confirms the packet must avoid inventing any new mission-slice contract family.

## 4. Current evaluator / distillation surfaces

The live repo already contains:
- evaluator proof-plane documentation and scripts under `framework/assurance/evaluators/**`
- retained evaluator evidence under `state/evidence/runs/**/assurance/evaluator.yml`
- canonical review finding/disposition contracts
- an actual retained review finding file
- a failure-distillation workflow overlay
- a real retained failure-distillation bundle for selected harness concepts

## 5. Current proposal packet convention

Two packet conventions are visible in repo lineage:
- the active architecture directory presently contains a numbered-Markdown packet (`octon_bounded_uec_proposal_packet`)
- the archive also contains a manifest-governed packet (`octon-selected-harness-concepts-integration-packet`)

This packet intentionally follows the manifest-governed convention because it is both repo-real and aligned with the task requirements.

## 6. Packet-time repository drift notes

### Drift Note A — prior broader selected-harness packet already exists and is archived
The repo already contains an archived manifest-governed packet for a broader harness concept set. This new packet must therefore be a superseding delta for the verified subset, not a casual duplicate.

### Drift Note B — proposal-backed mission classification is stronger than the prior verification report treated it
Packet-time inspection confirms:
- mission classification schema exists,
- mission autonomy policy fail-closes when proposal refs are required and absent,
- run-contract-v3 supports proposal refs and mission classification refs,
- and manifest-governed packet lineage already exists.
This concept is therefore now best treated as **already covered**.

### Drift Note C — stage-to-slice binding is still not explicit at the stage-attempt layer
Mission action slices exist, but the retained stage-attempt example and the current v2 schema do not yet carry an explicit action-slice binding. This remains a real integration gap.

### Drift Note D — evaluator disagreement handling is present generically but not yet reusable as a calibration loop
The repo has evaluator evidence, review findings/dispositions, and failure-distillation workflows, but the disagreement-to-calibration mechanism is still implicit rather than explicit.
