# Concept Coverage Matrix

| Mandatory scope concept | Packet coverage | Review disposition | Proposal disposition | Primary artifacts |
|---|---|---|---|---|
| Executive target-state determination | Covered | Adopt | Adopt directly | `target-architecture.md`, `proposal.yml` |
| Current-state repository audit | Covered | Adopt | Adapt into baseline/gap artifacts | `current-state-gap-map.md`, `repository-baseline-audit.md` |
| Premise audit | Covered | Adopt with limits | Adopt | `target-architecture.md`, `coverage-traceability-matrix.md` |
| Deletion candidates | Covered | Adopt/adapt | Adopt | `deletion-collapse-retention-matrix.md`, `file-change-map.md` |
| Collapse/simplification candidates | Covered | Adopt | Adopt | `deletion-collapse-retention-matrix.md` |
| Retained enduring architecture | Covered | Adopt | Adopt | `target-architecture.md`, `execution-constitution-conformance-card.md` |
| Strengthening priorities | Covered | Adopt | Adopt | `implementation-plan.md`, `file-change-map.md` |
| New first-class surfaces | Covered | Adopt | Split into multiple implementation tracks | `promotion-targets.md`, `implementation-plan.md` |
| Future actor model | Covered | Adopt | Adopt with terminology simplification | `actor-runtime-cognition-assurance-model.md` |
| Future context/cognition/retrieval model | Covered | Adopt | Adopt with context-pack first-class track | `actor-runtime-cognition-assurance-model.md` |
| Future orchestration/mission/run model | Covered | Adopt | Adopt with workflow audit/collapse | `target-architecture.md`, `migration-cutover-plan.md` |
| Future runtime-native substrate | Covered | Adopt | Adopt with staged browser/API caveat | `actor-runtime-cognition-assurance-model.md`, `support-target-and-adapter-strategy.md` |
| Future assurance/proof/benchmarking model | Covered | Adopt | Adopt with benchmark-suite addition | `validation-plan.md`, `evidence-plan.md` |
| Portability/support/adapters | Covered | Adopt | Adopt with support schema fix first | `support-target-and-adapter-strategy.md` |
| File/surface change map | Covered | Adopt | Adapt into promotion program | `file-change-map.md` |
| Implementation roadmap | Covered | Adopt | Adopt | `implementation-plan.md` |
| Migration/cutover strategy | Covered | Adopt | Adopt | `migration-cutover-plan.md`, `cutover-checklist.md` |
| Validation plan | Covered | Adopt | Adopt and expand | `validation-plan.md` |
| Acceptance criteria | Covered | Adopt | Adopt | `acceptance-criteria.md` |
| Closure/certification criteria | Covered | Adopt | Add dedicated plan | `closure-certification-plan.md` |
| Risks/tradeoffs/blind spots | Covered | Adopt | Adopt and extend | `risk-register.md` |
| Promotion targets | Covered in concept | Adapt | Explicit `proposal.yml` targets and placement map | `promotion-targets.md` |

## Review finding disposition summary

| Review finding | Disposition | Implementation treatment |
|---|---|---|
| Octon is not obsolete; its governance core becomes more valuable. | Adopted directly | Target architecture preserves constitution, run-first engine, state/evidence, support targets, assurance. |
| Complexity without governance value is debt. | Adopted directly | Deletion/collapse matrix and workflow audit require governance/runtime/assurance value. |
| Support-target/schema/charter drift must be fixed first. | Adopted directly | Phase 0 blocker and acceptance criterion. |
| Browser/API packs are ahead of runtime manifest. | Adopted directly | Stage-only until runtime services, replay, evidence, support dossiers, and tests exist. |
| Context should become deterministic context packs. | Adopted and expanded | New context-pack schema and evidence receipts. |
| Multi-agent topology should default to one orchestrator. | Adopted directly | Actor model section and agency spec promotion. |
| Generated cognition must stay derived. | Adopted directly | Context/cognition model and validators. |
| Evals/observability are not obsolete. | Adopted directly | Benchmark suite, RunCard/HarnessCard, evidence plan. |
| Token-era progressive-disclosure rationale should be deemphasized. | Adapted | Moved into context-pack budgets and degraded-profile policies rather than deleted. |
| Experimental external adapter should not be active support. | Adopted directly | Demote/quarantine or validator-enforced stage-only. |
