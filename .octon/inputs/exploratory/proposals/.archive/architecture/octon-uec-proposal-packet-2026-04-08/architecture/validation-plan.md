# Validation Plan

Every validator below is blocking unless explicitly marked otherwise. Full-attainment certification fails if any blocking validator is red.

## Global Validation Rules

- Validation must run in a fresh cutover worktree and in CI.
- Validation must be executed twice in full; the second pass must produce no constitution-related diff.
- Every validator emits a machine-readable evidence artifact into `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/`.
- Any validator output that depends on timestamps or non-deterministic ordering must normalize those fields before diffing.

## V-SOT-001 — Authority Classification Validator

- **Type:** structural
- **Implementation script:** `.octon/framework/assurance/scripts/validate-authority-classification.sh`
- **Primary suite/config:** `.octon/framework/assurance/structural/suites/authority-classification.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-authority-classification.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Any live runtime/policy dependency outside `framework/**` and `instance/**`, or any generated/proposal/exploratory surface classified as authoritative.
- **Blocking:** yes
- **Evidence emitted:** `authority-classification-report.yml`

## V-SOT-002 — Mirror Parity Validator

- **Type:** structural
- **Implementation script:** `.octon/framework/assurance/scripts/validate-mirror-parity.sh`
- **Primary suite/config:** `.octon/framework/assurance/structural/suites/mirror-parity.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-mirror-parity.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Byte drift between `AGENTS.md`, `CLAUDE.md`, `/.octon/AGENTS.md`, and any declared thin adapter mirrors; or mirrors containing extra runtime/policy text.
- **Blocking:** yes
- **Evidence emitted:** `mirror-parity-report.yml`

## V-PREC-001 — Precedence Resolution Validator

- **Type:** governance
- **Implementation script:** `.octon/framework/assurance/scripts/validate-precedence-resolution.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/precedence-resolution.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-precedence-resolution.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Normative and epistemic precedence files not both consumed by the same resolver output or precedence report missing.
- **Blocking:** yes
- **Evidence emitted:** `precedence-resolution-report.yml`

## V-OBJ-001 — Objective Stack Legality Validator

- **Type:** structural
- **Implementation script:** `.octon/framework/assurance/scripts/validate-objective-stack.sh`
- **Primary suite/config:** `.octon/framework/assurance/structural/suites/objective-stack.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-objective-stack.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Any workspace/mission/run/stage artifact combination that violates the legal target-state stack.
- **Blocking:** yes
- **Evidence emitted:** `objective-stack-legality-report.yml`

## V-OBJ-002 — Mission/Run Normalization Validator

- **Type:** governance
- **Implementation script:** `.octon/framework/assurance/scripts/validate-mission-run-normalization.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/mission-run-normalization.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-mission-run-normalization.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Contradictory mission fields, missing mission bindings where required, or stage-only/run-only semantics not encoded cleanly.
- **Blocking:** yes
- **Evidence emitted:** `mission-run-normalization-report.yml`

## V-AUTH-001 — Authority Centralization Validator

- **Type:** governance
- **Implementation script:** `.octon/framework/assurance/scripts/validate-authority-centralization.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/authority-centralization.yml`
- **Primary workflow:** `.github/workflows/pr-autonomy-policy.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-authority-centralization.sh` (workflow wrapper may pass additional flags)
- **Fails on:** GitHub/CI/Studio workflows minting authority directly, host projections diverging from canonical authority artifacts, or missing decision/grant bundles.
- **Blocking:** yes
- **Evidence emitted:** `authority-centralization-report.yml`

## V-AUTH-002 — Authority Artifact Completeness Validator

- **Type:** governance
- **Implementation script:** `.octon/framework/assurance/scripts/validate-authority-artifacts.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/authority-artifacts.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-authority-artifacts.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Required ApprovalRequest/ApprovalGrant/Lease/Revocation/DecisionArtifact/QuorumPolicy artifacts missing for governed paths.
- **Blocking:** yes
- **Evidence emitted:** `authority-artifact-completeness-report.yml`

## V-AUTH-003 — Fail-Closed Routing Validator

- **Type:** governance
- **Implementation script:** `.octon/framework/assurance/scripts/validate-fail-closed-routing.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/fail-closed-routing.yml`
- **Primary workflow:** `.github/workflows/pr-autonomy-policy.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-fail-closed-routing.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Any unsupported or under-approved route that continues without deny/stage_only/escalate disposition.
- **Blocking:** yes
- **Evidence emitted:** `fail-closed-routing-report.yml`

## V-SUP-001 — Support-Target Admission Validator

- **Type:** governance
- **Implementation script:** `.octon/framework/assurance/scripts/validate-support-target-admission.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/support-target-admission.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-support-target-admission.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Any adapter, run, or disclosure artifact that claims support outside the admitted target matrix or omits required target tuple fields.
- **Blocking:** yes
- **Evidence emitted:** `support-target-consistency-report.yml`

## V-CAP-001 — Capability Pack Governance Validator

- **Type:** functional
- **Implementation script:** `.octon/framework/assurance/scripts/validate-capability-packs.sh`
- **Primary suite/config:** `.octon/framework/assurance/functional/api/capability-packs.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-capability-packs.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Missing pack manifests, missing allow/stage_only/escalate/deny routing, or pack disclosure/admission mismatches.
- **Blocking:** yes
- **Evidence emitted:** `capability-pack-governance-report.yml`

## V-RUN-001 — Canonical Run Root Validator

- **Type:** runtime
- **Implementation script:** `.octon/framework/assurance/scripts/validate-run-roots.sh`
- **Primary suite/config:** `.octon/framework/assurance/structural/suites/run-roots.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-run-roots.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Consequential runs lacking required roots/files: runtime-state, rollback-posture, checkpoints, contamination, retry-records, events, manifests, receipts.
- **Blocking:** yes
- **Evidence emitted:** `run-root-completeness-report.yml`

## V-RUN-002 — Durable Lifecycle & Replay Linkage Validator

- **Type:** recovery
- **Implementation script:** `.octon/framework/assurance/scripts/validate-durable-lifecycle.sh`
- **Primary suite/config:** `.octon/framework/assurance/recovery/suites/durable-lifecycle.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-durable-lifecycle.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Broken replay pointers, missing checkpoint lineage, or rollback posture not linked to the canonical run root.
- **Blocking:** yes
- **Evidence emitted:** `durable-lifecycle-report.yml`

## V-EVD-001 — Evidence Retention Proof Validator

- **Type:** recovery
- **Implementation script:** `.octon/framework/assurance/scripts/validate-evidence-retention.sh`
- **Primary suite/config:** `.octon/framework/assurance/recovery/suites/evidence-retention.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-evidence-retention.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Evidence classes not assigned, missing hash/provenance links for external-immutable evidence, or unresolved replay indexes.
- **Blocking:** yes
- **Evidence emitted:** `evidence-retention-proof.yml`

## V-EVD-002 — External Replay Restore Drill

- **Type:** recovery
- **Implementation script:** `.octon/framework/assurance/scripts/validate-external-replay-restore.sh`
- **Primary suite/config:** `.octon/framework/assurance/recovery/suites/external-replay-restore.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-certify.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-external-replay-restore.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Immutable external payloads cannot be fetched, hash-verified, and re-bound to a replay manifest.
- **Blocking:** yes
- **Evidence emitted:** `external-replay-restore-report.yml`

## V-OBS-001 — Intervention Completeness Validator

- **Type:** observability
- **Implementation script:** `.octon/framework/assurance/scripts/validate-interventions.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/intervention-completeness.yml`
- **Primary workflow:** `.github/workflows/ai-review-gate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-interventions.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Manual approvals, hotfixes, reruns, or overrides without intervention records linked to affected runs.
- **Blocking:** yes
- **Evidence emitted:** `intervention-completeness.yml`

## V-OBS-002 — Measurement & Trace Coverage Validator

- **Type:** observability
- **Implementation script:** `.octon/framework/assurance/scripts/validate-measurements.sh`
- **Primary suite/config:** `.octon/framework/assurance/maintainability/suites/measurement-trace-coverage.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-measurements.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Run bundles lacking cost/latency/failure taxonomy summaries, trace pointers, or measurement records.
- **Blocking:** yes
- **Evidence emitted:** `measurement-trace-coverage.yml`

## V-ASS-001 — Proof-Plane Coverage Validator

- **Type:** assurance
- **Implementation script:** `.octon/framework/assurance/scripts/validate-proof-planes.sh`
- **Primary suite/config:** `.octon/framework/assurance/maintainability/suites/proof-plane-coverage.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-certify.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-proof-planes.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Any required proof plane missing for the admitted target universe or any claimed plane failing its gate.
- **Blocking:** yes
- **Evidence emitted:** `proof-plane-coverage-report.yml`

## V-LAB-001 — Lab Substance Validator

- **Type:** behavioral
- **Implementation script:** `.octon/framework/assurance/scripts/validate-lab-substance.sh`
- **Primary suite/config:** `.octon/framework/assurance/behavioral/suites/lab-substance.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-lab-substance.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Lab domains missing scenario/replay/shadow/fault/probe assets or lacking retained evidence pointers.
- **Blocking:** yes
- **Evidence emitted:** `lab-substance-report.yml`

## V-LAB-002 — Evaluator Independence Validator

- **Type:** behavioral
- **Implementation script:** `.octon/framework/assurance/scripts/validate-evaluator-independence.sh`
- **Primary suite/config:** `.octon/framework/assurance/behavioral/suites/evaluator-independence.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-certify.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-evaluator-independence.sh` (workflow wrapper may pass additional flags)
- **Fails on:** No held-out/hidden-check policy, no independent evaluator lane, or evaluator-overfit protections absent.
- **Blocking:** yes
- **Evidence emitted:** `evaluator-independence-report.yml`

## V-DISC-001 — Run Disclosure Truth Validator

- **Type:** disclosure
- **Implementation script:** `.octon/framework/assurance/scripts/validate-run-card-truth.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/run-card-truth.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-run-card-truth.sh` (workflow wrapper may pass additional flags)
- **Fails on:** RunCard fields disagree with run contracts/manifests/evidence or omit required disclosure fields.
- **Blocking:** yes
- **Evidence emitted:** `run-card-truth-report.yml`

## V-DISC-002 — Harness Claim Universe Validator

- **Type:** disclosure
- **Implementation script:** `.octon/framework/assurance/scripts/validate-harness-card-claim.sh`
- **Primary suite/config:** `.octon/framework/assurance/governance/suites/harness-card-claim.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-certify.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-harness-card-claim.sh` (workflow wrapper may pass additional flags)
- **Fails on:** HarnessCard universal-complete claim while any in-scope support target, adapter, or capability pack remains excluded or stage-only.
- **Blocking:** yes
- **Evidence emitted:** `universal-attainment-proof.yml`

## V-LEG-001 — Legacy Surface Retirement Validator

- **Type:** maintainability
- **Implementation script:** `.octon/framework/assurance/scripts/validate-legacy-retirement.sh`
- **Primary suite/config:** `.octon/framework/assurance/maintainability/suites/legacy-retirement.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-validate.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-legacy-retirement.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Legacy architect/persona or compatibility shim surfaces remain live-authoritative after cutover.
- **Blocking:** yes
- **Evidence emitted:** `compatibility-retirement-report.yml`

## V-CERT-001 — Dual-Pass Idempotence & Certification Validator

- **Type:** certification
- **Implementation script:** `.octon/framework/assurance/scripts/validate-dual-pass-idempotence.sh`
- **Primary suite/config:** `.octon/framework/assurance/maintainability/suites/dual-pass-idempotence.yml`
- **Primary workflow:** `.github/workflows/uec-cutover-certify.yml`
- **Invocation:** `bash .octon/framework/assurance/scripts/validate-dual-pass-idempotence.sh` (workflow wrapper may pass additional flags)
- **Fails on:** Any constitution-related diff appears on the second regeneration/validation pass or any blocking validator is non-green in either pass.
- **Blocking:** yes
- **Evidence emitted:** `second-pass-no-diff-report.yml`

## Required Workflow Updates

| Workflow | Required change |
| --- | --- |
| `/.github/workflows/pr-autonomy-policy.yml` | Project canonical authority artifacts only; fail on authority drift or fail-open routing; upload authority/intervention evidence. |
| `/.github/workflows/ai-review-gate.yml` | Consume canonical decision outputs, upload intervention completeness evidence, and fail on disclosure/authority mismatches. |
| `/.github/workflows/uec-cutover-validate.yml` | Run full validation pass; publish pass-1 evidence bundle. |
| `/.github/workflows/uec-cutover-certify.yml` | Run second full pass, enforce no-diff rule, and emit closure certificate. |
| `/.github/workflows/uec-drift-watch.yml` | Post-cutover drift watcher for mirrors, support-targets, disclosure, and retirement violations. |

## Required End-to-End Checks

1. **Fresh-worktree / fresh-bootstrap verification** — create a fresh cutover worktree, bootstrap it from canonical ingress, and run the full validator stack.
2. **Regeneration verification** — regenerate effective views, run cards, harness card, and closure views from canonical sources only.
3. **Pass 1** — all blocking validators green; evidence bundle written.
4. **Pass 2** — fresh clean state, rerun the entire regeneration + validation stack; all blocking validators green again.
5. **No-diff proof** — `second-pass-no-diff-report.yml` confirms no constitution-related diff.

## Blocking Semantics

No validator in this plan may be advisory for full-attainment certification. If a validator exists, it must either block or the target-state packet is incomplete.
