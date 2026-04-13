# Full concept integration assessment

## Concept: Evaluator calibration by disagreement distillation

### A. Upstream concept record
- **Mechanism:** Capture evaluator misses and disagreement cases as retained evidence, then distill them into reusable calibration candidates rather than relying on ad hoc prompt tweaking.
- **Why it mattered upstream:** The source showed that evaluator quality improved only after reviewing disagreement logs and tuning the evaluator against those cases.
- **Verification correction:** The prior verification pass elevated this as the strongest missed useful concept and recommended an evidence-first refinement.
- **Source evidence:** The Anthropic article explicitly describes few-shot calibration and a tuning loop where evaluator logs were read, disagreement cases were found, and the evaluator prompt was revised.

### B. Current Octon coverage
- Evaluator proof-plane documentation and retained evaluator output already exist.
- Canonical review-finding and review-disposition contracts now exist.
- A retained review finding file exists in a real run bundle.
- A generic failure-distillation workflow overlay exists.
- A real retained failure-distillation bundle already references the earlier selected-harness packet.

### C. Coverage judgment
**partially_covered**

The repo clearly has the ingredients, but not yet a reusable disagreement-specific calibration loop. Current distillation exists as a generic evidence-hardening mechanism and one retained bundle. That is strong partial coverage, not full reusable capability.

### D. Conflict / overlap / misalignment analysis
- Overlap with existing surfaces is high by design; this must be an extension, not a new subsystem.
- The main invariant risk is hidden policy: if calibration artifacts become de facto authority, the repo would blur evidence and governance.
- A narrower path (for example, keeping calibration as free-form notes in evidence bundles) would preserve pseudo-coverage because operators could not repeat it reliably.
- A broader path (a new calibration control plane) would violate Octon’s authority discipline.

### E. Integration decision rubric outcome
- **Integration bias judgment:** evidence-first refinement of existing proof-plane and distillation surfaces.
- **Selected approach:** extension/refinement of current canonical surfaces.
- **Why this is correct:** the repo already has evaluator evidence, findings/dispositions, distillation workflows, and generated summary space.
- **Why narrower alternatives are insufficient:** they would leave disagreement capture ad hoc and non-enforceable.
- **Why broader alternatives are unnecessary:** they would duplicate proof-plane and governance logic already present.
- **How this becomes genuinely usable:** by making disagreement bundle generation and validation deterministic and repeatable.

### F. Canonical placement
- **Durable authority:** extend
  - `/.octon/framework/constitution/contracts/assurance/distillation-bundle-v1.schema.json`
  - `/.octon/instance/governance/contracts/failure-distillation-workflow.yml`
- **Retained evidence:** new bundle path under
  - `/.octon/state/evidence/validation/failure-distillation/<bundle-id>/**`
- **Derived only:** optional generated summary under
  - `/.octon/generated/cognition/distillation/<bundle-id>/summary.md`
- **Canonical vs derived:** retained evidence is canonical evidence; generated summary is derived only.

### G. Implementation shape
- **Preferred Change Path:** extend the generic distillation contract and workflow so evaluator disagreement bundles are first-class retained evidence; add a deterministic authoring script and validator.
- **Minimal Change Path fallback:** generate one disagreement bundle manually and validate it with a lightweight script, but do not stop there; this is a fallback only.
- **Proposal-first vs direct backlog:** proposal-first because schema/workflow changes and CI wiring are involved.
- **Files to add or change:** see `architecture/file-change-map.md`.
- **What would make this incomplete if omitted:** no repeatable authoring path, no validator, or no retained disagreement bundle.

### H. Validation and proof
- One disagreement bundle must exist and link evaluator evidence to findings/dispositions and a calibration candidate.
- The disagreement bundle validator must pass twice in CI.
- Generated summaries may exist but must never be treated as truth.

### I. Operationalization
- Operators and maintainers use the disagreement bundle as the retained review surface for deciding whether a new evaluator heuristic or guidance change is warranted.
- No live control-state change is required.

### J. Rollback / reversal / deferment posture
- Easy rollback: revert schema/workflow/script changes.
- Preserve retained disagreement bundles even if the workflow is rolled back.
- Safe to defer only if the repo accepts continued ad hoc evaluator tuning; this packet does not recommend deferral.

### K. Final disposition
**adapt**

---

## Concept: Slice-to-stage binding refinement for mission-bound runs

### A. Upstream concept record
- **Mechanism:** Ensure bounded executable work in runs resolves explicitly to declared mission action slices rather than living only as implicit mission context.
- **Why it mattered upstream:** The source’s sprint contract bridged high-level intent to bounded, testable implementation work before code was written.
- **Verification correction:** The earlier extraction wrongly proposed a new mission-slice run-contract family; verification corrected this to a refinement of existing run/stage/action-slice surfaces.
- **Source evidence:** The Anthropic article’s generator/evaluator sprint contract explicitly defined what “done” meant for a chunk of work before coding began.

### B. Current Octon coverage
- Mission action-slices exist under mission control.
- Mission classification exists.
- Stage-attempt schema exists.
- Retained stage-attempt example exists.
- But neither the current stage-attempt schema nor the retained example explicitly binds a stage attempt to a mission action slice.

### C. Coverage judgment
**partially_covered**

The repo already has the right families, but the explicit binding is still missing at the stage-attempt layer.

### D. Conflict / overlap / misalignment analysis
- The earlier mission-slice contract idea would now duplicate existing run contracts, mission control, and action-slices.
- The correct refinement is to make stage attempts explicitly slice-aware.
- A docs-only cross-reference would be pseudo-coverage.
- A broader redesign is unnecessary because current surfaces are already close.

### E. Integration decision rubric outcome
- **Integration bias judgment:** refine current runtime contract surfaces.
- **Selected approach:** coordinated extension of stage-attempt contract + validator + scenario suite + retained receipts.
- **Why this is correct:** it adds the missing explicit binding where consequential execution is already tracked.
- **Why narrower alternatives are insufficient:** they would leave stage-to-slice traceability informal and non-enforceable.
- **Why broader alternatives are unnecessary:** they would duplicate existing run-first execution architecture.
- **How this becomes genuinely usable:** mission-bound stage attempts can be inspected, validated, and replayed against a declared mission slice.

### F. Canonical placement
- **Durable authority:** edit
  - `/.octon/framework/constitution/contracts/runtime/stage-attempt-v2.schema.json`
- **Canonical control truth:** backfill/update
  - `/.octon/state/control/execution/runs/<mission-bound-run-id>/stage-attempts/*.yml`
- **Retained evidence:**
  - `/.octon/state/evidence/runs/<mission-bound-run-id>/receipts/stage-action-slice-binding.yml`
- **Validation/enforcement:**
  - `/.octon/framework/assurance/runtime/_ops/scripts/validate-mission-runtime-contracts.sh`
  - `/.octon/framework/assurance/runtime/_ops/scripts/test-mission-autonomy-scenarios.sh`

### G. Implementation shape
- **Preferred Change Path:** add explicit `action_slice_ref` to stage-attempt-v2, update validators, add scenario coverage, and backfill any mission-bound retained runs.
- **Minimal Change Path fallback:** allow optional field first, then gate on validator only for new mission-bound runs. Use only if backfill sequencing demands it.
- **Proposal-first vs direct backlog:** proposal-first because consequential execution semantics and validation are involved.
- **What would make this incomplete if omitted:** missing validator, missing backfill, or missing retained receipt.

### H. Validation and proof
- Validator fails closed when mission-bound stage attempts lack a valid slice reference.
- Mission autonomy scenario suite proves one passing slice-bound run.
- Retained receipt exists for each affected run.

### I. Operationalization
- Runtime consumers and maintainers can inspect a run’s stage attempts and see exactly which action slice each stage executed against.
- This improves replay, audit, and bounded execution clarity.

### J. Rollback / reversal / deferment posture
- Roll back schema requirement and validator if needed, but preserve backfilled control/evidence artifacts.
- Deferment is not preferred because the current gap affects consequential execution traceability.

### K. Final disposition
**adapt**

---

## Concept: Proposal-packet-backed expansion of terse objectives

### A. Upstream concept record
- **Mechanism:** Use proposal packets to expand weak objectives before consequential execution, while keeping planner output non-authoritative until promoted.
- **Why it mattered upstream:** The source’s planner turned short prompts into richer specs without prematurely locking technical detail.
- **Verification correction:** Verification kept the concept as useful but warned against treating planner output as runtime truth.

### B. Current Octon coverage
- Manifest-governed proposal packet lineage already exists.
- Mission classification already carries `proposal_requirement` and `proposal_refs`.
- Mission-autonomy policy fail-closes when proposal refs are required and absent.
- Run-contract-v3 already supports proposal refs and mission classification refs.
- An archived selected-harness packet already demonstrates the packet convention in repo lineage.

### C. Coverage judgment
**fully_covered**

### D. Conflict / overlap / misalignment analysis
- A new specialized mission-planning family would duplicate current proposal lineage and control-path gating.
- No migration is needed.
- Creating more packet families would add ceremony without extra enforceability.

### E. Integration decision rubric outcome
- **Integration bias judgment:** no change.
- **Selected approach:** already covered.
- **Why this is correct:** current policy, schema, and proposal lineage already make the capability operational.
- **Why narrower alternatives are irrelevant:** no change needed.
- **Why broader alternatives are unnecessary:** existing surfaces are already sufficient.

### F. Canonical placement
- Leave unchanged:
  - `/.octon/inputs/exploratory/proposals/**`
  - `/.octon/framework/engine/runtime/spec/mission-classification-v1.schema.json`
  - `/.octon/instance/governance/policies/mission-autonomy.yml`
  - `/.octon/framework/constitution/contracts/runtime/run-contract-v3.schema.json`

### G. Implementation shape
- No new files.
- No schema expansion.
- No migration.

### H. Validation and proof
- Existing fail-closed controls remain the proof surface.
- Existing proposal packet lineage remains non-authoritative.

### I. Operationalization
- Operators or agents can already create a proposal packet, cite it in mission classification, and carry the promoted reference into run-contract issuance.

### J. Rollback / reversal / deferment posture
- Not applicable; no change.

### K. Final disposition
**already_covered**
