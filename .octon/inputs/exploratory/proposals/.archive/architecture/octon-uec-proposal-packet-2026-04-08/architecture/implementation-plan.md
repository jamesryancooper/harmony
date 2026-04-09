# Implementation Plan

All phases execute on the isolated cutover branch/worktree. The default branch remains untouched until Phase P5 completes successfully.

## P0 — Packet ratification and cutover branch freeze

**Objective:** Ratify the target-state packet, create the isolated cutover branch/worktree, and freeze mainline merges so the cutover can be built and validated without introducing an intermediate partially-compliant state to the default branch.

**Touched files / surfaces:**
- `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/**`
- `proposal packet metadata`
- `branch protection / release freeze controls`

**Preconditions:**
- Proposal packet accepted as the sole cutover plan.
- No in-flight repo-wide architecture migrations outside this packet.
- Cutover release id chosen and written into release lineage stub.

**Exact steps:**
1. Create one protected cutover branch and isolated worktree for the full-attainment migration.
2. Freeze merges to `main` except emergency fixes unrelated to the constitutional surfaces; emergency fixes must be rebased into the cutover branch before validation.
3. Seed the cutover release directory at `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/` with an empty closure manifest and release lineage stub.
4. Register this packet as non-authoritative planning input and record the packet id in the cutover branch notes.

**Outputs:**
- Cutover branch/worktree
- Release directory stub
- Freeze record

**Failure modes:**
- Parallel mainline drift invalidates validation results.
- Packet scope is re-litigated mid-cutover.

**Validators:**
- `V-SOT-001`

**Exit criteria:** Cutover branch is isolated, release stub exists, and no partially compliant state has landed on `main`.

## P1 — Canonical authority and objective normalization

**Objective:** Make the constitutional kernel, objective stack, precedence, and mirror discipline unambiguous before any support-target broadening or certification work begins.

**Touched files / surfaces:**
- `/.octon/framework/constitution/**`
- `/.octon/instance/charter/**`
- `/.octon/state/control/execution/runs/**`
- `/AGENTS.md`
- `/CLAUDE.md`
- `/.octon/AGENTS.md`

**Preconditions:**
- P0 complete

**Exact steps:**
1. Update constitutional source-of-truth and mirror classification surfaces.
2. Tighten objective schemas and migrate all run contracts/manifests to legal mission/run/stage combinations.
3. Retire historical objective shims from live authority paths.
4. Implement one effective precedence resolver and generated precedence view.

**Outputs:**
- Normalized objective schemas and instances
- Mirror parity rules
- Precedence resolver + evidence

**Failure modes:**
- Legacy shims remain referenced.
- Mission/run instances cannot be migrated losslessly.

**Validators:**
- `V-SOT-001`
- `V-SOT-002`
- `V-PREC-001`
- `V-OBJ-001`
- `V-OBJ-002`
- `V-LEG-001`

**Exit criteria:** No live authority ambiguity remains in ingress, objective, or precedence surfaces.

## P2 — Authority runtime centralization and support-target admission

**Objective:** Move authority issuance fully into canonical runtime/governance surfaces, formalize governed capability packs, and broaden the support universe to the full target-state set.

**Touched files / surfaces:**
- `/.octon/framework/engine/runtime/adapters/{model,host}/**`
- `/.github/workflows/{pr-autonomy-policy.yml,ai-review-gate.yml}`
- `/.octon/instance/governance/{support-targets.yml,capability-packs/**,exclusions/**}`
- `/.octon/state/control/execution/approvals/**`
- `/.octon/state/evidence/control/execution/**`

**Preconditions:**
- P1 complete

**Exact steps:**
1. Refactor host workflows to project canonical authority artifacts rather than mint them.
2. Complete lease/revocation/quorum coverage and fail-closed routing.
3. Instantiate governed capability pack manifests for repo/git/shell/telemetry/browser/api and bind them into support-target governance.
4. Upgrade host and model adapter manifests so every admitted tuple is explicit and validated.
5. Remove all in-scope live-claim exclusions from support-target policy.

**Outputs:**
- Centralized authority flows
- Capability pack manifests
- Expanded support-target matrix

**Failure modes:**
- Host projections still carry hidden authority.
- A capability pack is admitted without route controls.

**Validators:**
- `V-AUTH-001`
- `V-AUTH-002`
- `V-AUTH-003`
- `V-SUP-001`
- `V-CAP-001`

**Exit criteria:** Authority is canonical, host projections are non-authoritative, and the full target support universe is admitted in policy.

## P3 — Runtime, evidence, observability, proof-plane, and lab completion

**Objective:** Complete the durable lifecycle, external replay proof, intervention completeness, proof-plane coverage, and real lab substance needed for a full-attainment claim.

**Touched files / surfaces:**
- `/.octon/state/control/execution/runs/**`
- `/.octon/state/evidence/{runs/**,external-index/**,lab/**}`
- `/.octon/framework/{assurance/**,lab/**,observability/**}`
- `/.octon/framework/engine/runtime/crates/{replay_store,telemetry_sink,runtime_bus}`

**Preconditions:**
- P2 complete

**Exact steps:**
1. Normalize all consequential run roots to the required canonical durable-lifecycle shape.
2. Bind tri-class evidence retention and external immutable replay to hash/provenance proofs and restore drills.
3. Make intervention, measurement, trace, and failure taxonomy capture complete for admitted run classes.
4. Populate behavioral/recovery/maintainability proof and held-out evaluator independence policy.
5. Populate lab scenarios, replay packs, shadow manifests, probes, and fault rehearsals with retained evidence indexes.

**Outputs:**
- Durable run-root compliance
- Replay proof
- Observability completeness
- Proof-plane and lab substance

**Failure modes:**
- External replay backend cannot be proven.
- Behavioral or lab suites remain cosmetic.

**Validators:**
- `V-RUN-001`
- `V-RUN-002`
- `V-EVD-001`
- `V-EVD-002`
- `V-OBS-001`
- `V-OBS-002`
- `V-ASS-001`
- `V-LAB-001`
- `V-LAB-002`

**Exit criteria:** Runtime, evidence, lab, and proof planes are complete enough to support full-attainment certification.

## P4 — Simplification, deletion, disclosure truth, and release synthesis

**Objective:** Delete obsolete active surfaces, harden disclosure semantics, and regenerate canonical run/release disclosure so no shadow authority or bounded-claim ambiguity survives cutover.

**Touched files / surfaces:**
- `/.octon/framework/agency/**`
- `/.octon/framework/constitution/contracts/disclosure/**`
- `/.octon/state/evidence/disclosure/**`
- `/.octon/generated/effective/**`
- `/.octon/instance/governance/{retirement-register.yml,decisions/**}`

**Preconditions:**
- P3 complete

**Exact steps:**
1. Delete or archive legacy architect/persona surfaces from active runtime paths.
2. Create the retirement register and ablation rules for future build-to-delete discipline.
3. Harden RunCard/HarnessCard schemas and generation to distinguish bounded attainment from universal completion.
4. Regenerate all affected run cards, the cutover HarnessCard, effective closure views, release manifests, and lineage indexes from canonical sources only.

**Outputs:**
- Simplified agency surface
- Retirement register
- Truthful disclosure artifacts
- Release closure bundle pass 1

**Failure modes:**
- Disclosure still says 'complete' with exclusions.
- A legacy surface survives in active runtime discovery.

**Validators:**
- `V-LEG-001`
- `V-DISC-001`
- `V-DISC-002`
- `V-SOT-002`

**Exit criteria:** All disclosure surfaces are truthful and all obsolete active surfaces are removed or archived.

## P5 — Dual-pass validation, certification, and atomic cutover

**Objective:** Run the full regeneration + validation stack twice, prove no second-pass constitution-related diff, emit closure evidence and durable authored decisions, then merge atomically.

**Touched files / surfaces:**
- `/.github/workflows/{uec-cutover-validate.yml,uec-cutover-certify.yml}`
- `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/**`
- `/.octon/generated/effective/closure/**`
- `/.octon/instance/governance/decisions/ADR-UEC-010-full-attainment-certification.md`

**Preconditions:**
- P4 complete

**Exact steps:**
1. Run the full cutover validation workflow (pass 1) and collect all evidence artifacts.
2. Clean the worktree, rerun all regenerators and validators (pass 2), and capture the no-diff proof.
3. Emit the closure summary, closure certificate, universal attainment proof, and final HarnessCard.
4. Write and merge the durable closeout ADRs, then perform one atomic protected merge/tag/release.
5. Unfreeze `main` only after release disclosure and closure evidence are published.

**Outputs:**
- Two green validation passes
- No-diff proof
- Closure certificate
- Atomic merge and release

**Failure modes:**
- Any validator flips between passes.
- Any constitution-related diff appears on pass 2.
- Any blocker remains unresolved.

**Validators:**
- `V-SOT-001`
- `V-SOT-002`
- `V-PREC-001`
- `V-OBJ-001`
- `V-OBJ-002`
- `V-AUTH-001`
- `V-AUTH-002`
- `V-AUTH-003`
- `V-SUP-001`
- `V-CAP-001`
- `V-RUN-001`
- `V-RUN-002`
- `V-EVD-001`
- `V-EVD-002`
- `V-OBS-001`
- `V-OBS-002`
- `V-ASS-001`
- `V-LAB-001`
- `V-LAB-002`
- `V-DISC-001`
- `V-DISC-002`
- `V-LEG-001`
- `V-CERT-001`

**Exit criteria:** `main` moves directly from current state to the fully certified target state in one merge with no intermediate partially compliant steady state.
