# File Change Map

This map identifies the exact repo paths and path families that must change in the cutover branch. Path families using `**` are deliberate family-wide migrations and regenerations.

## Canonical-State Changes

| Path / family | Action | Why it changes |
| --- | --- | --- |
| /.octon/framework/constitution/CHARTER.md | update | Clarify full-attainment semantics, admitted-vs-target universe, and no-shadow-authority rule. |
| /.octon/framework/constitution/charter.yml | update | Machine-readable counterpart for full-attainment constitution semantics. |
| /.octon/framework/constitution/precedence/normative.yml | update | Bind normative precedence to one effective resolver. |
| /.octon/framework/constitution/precedence/epistemic.yml | update | Bind epistemic precedence to one effective resolver. |
| /.octon/framework/constitution/contracts/registry.yml | update | Register any newly added or hardened contract families and retire live shims. |
| /.octon/framework/constitution/contracts/objective/README.md | update | Remove live-shim language and encode the final objective stack. |
| /.octon/framework/constitution/contracts/objective/run-contract-v3.schema.json | update | Disallow contradictory mission/run combinations and add capability-pack refs if absent. |
| /.octon/framework/constitution/contracts/objective/stage-attempt-v1.schema.json | update | Ensure stage attempts remain subordinate to a legal run contract. |
| /.octon/framework/constitution/contracts/runtime/run-manifest-v1.schema.json | update | Require canonical evidence, capability-pack, and observability linkages. |
| /.octon/framework/constitution/contracts/disclosure/run-card-v2.schema.json | update | Separate stage-only, bounded, and universal attainment semantics. |
| /.octon/framework/constitution/contracts/disclosure/harness-card-v2.schema.json | update | Require target universe, admitted universe, remaining exclusions, and universal-claim gating. |
| /.octon/framework/constitution/contracts/retention/evidence-retention-contract-v1.schema.json | update | Harden tri-class evidence linkage requirements. |
| /.octon/framework/constitution/contracts/retention/external-replay-index-v1.schema.json | update | Require hash/provenance pointers for external immutable payloads. |
| /.octon/framework/constitution/contracts/adapters/capability-pack-v1.schema.json | update | Make pack routing, admission, and disclosure explicit. |
| /.octon/framework/agency/manifest.yml | update | Finalize orchestrator-only kernel posture and point to retirement register. |
| /.octon/framework/agency/runtime/agents/architect/** | delete | Retire active architect persona surfaces from live runtime discovery. |
| /.octon/framework/engine/runtime/adapters/model/repo-local-governed.yml | update | Bind conformance and support-target evidence to full target universe. |
| /.octon/framework/engine/runtime/adapters/model/frontier-governed.yml | update | Admit frontier-governed model surface into the universal target universe. |
| /.octon/framework/engine/runtime/adapters/host/repo-shell.yml | update | Align host admission semantics to support-target matrix. |
| /.octon/framework/engine/runtime/adapters/host/github-control-plane.yml | update | Reduce to pure projection role and bind conformance suites. |
| /.octon/framework/engine/runtime/adapters/host/ci-control-plane.yml | update | Admit and classify CI host surface under support-target governance. |
| /.octon/framework/engine/runtime/adapters/host/studio-control-plane.yml | update | Admit and classify Studio host surface under support-target governance. |
| /.octon/framework/engine/runtime/README.md | update | Reflect universal run-first lifecycle and certification gate expectations. |
| /.octon/instance/charter/workspace.md | update | Ensure workspace objective language matches final execution constitution. |
| /.octon/instance/charter/workspace.yml | update | Machine objective parity with workspace charter narrative. |
| /.octon/instance/orchestration/missions/** | update | Normalize mission continuity semantics where missions remain required. |
| /.octon/instance/governance/support-targets.yml | update | Declare the full admitted support universe and bind admission logic. |
| /.octon/instance/governance/exclusions/action-classes.yml | update | Keep fail-closed exclusions aligned to new capability packs and host surfaces. |
| /.octon/instance/governance/disclosure/release-lineage.yml | update | Track the full-attainment release and superseded bounded-claim release. |
| /.octon/instance/governance/retirement-register.yml | add | Formal build-to-delete and retirement tracking. |
| /.octon/instance/governance/capability-packs/repo.yml | add | First-class governed pack manifest. |
| /.octon/instance/governance/capability-packs/git.yml | add | First-class governed pack manifest. |
| /.octon/instance/governance/capability-packs/shell.yml | add | First-class governed pack manifest. |
| /.octon/instance/governance/capability-packs/telemetry.yml | add | First-class governed pack manifest. |
| /.octon/instance/governance/capability-packs/browser.yml | add | Admit browser/UI action surface through governed pack. |
| /.octon/instance/governance/capability-packs/api.yml | add | Admit broader API action surface through governed pack. |
| /AGENTS.md | update | Keep root ingress adapter byte-aligned and explicitly non-authoritative. |
| /CLAUDE.md | update | Keep root ingress adapter byte-aligned and explicitly non-authoritative. |
| /.octon/AGENTS.md | update | Keep `.octon` ingress adapter byte-aligned and explicitly non-authoritative. |
| /.octon/instance/bootstrap/OBJECTIVE.md | delete-or-archive | Remove live compatibility shim from active authority path. |
| /.octon/instance/cognition/context/shared/intent.contract.yml | delete-or-archive | Remove live compatibility shim from active authority path. |
| /.octon/state/control/execution/runs/**/run-contract.yml | update | Migrate all consequential runs to legal objective + capability-pack + support-target semantics. |
| /.octon/state/control/execution/runs/**/run-manifest.yml | update | Require full evidence, observability, capability-pack, and disclosure links. |
| /.octon/state/control/execution/runs/**/runtime-state.yml | update | Normalize runtime-state fields for durable lifecycle. |
| /.octon/state/control/execution/runs/**/rollback-posture.yml | update | Make rollback posture explicit and linked to evidence retention. |
| /.octon/state/control/execution/runs/**/stage-attempts/** | update | Normalize stage-attempt hierarchy under legal run roots. |
| /.octon/framework/lab/scenarios/** | update | Populate scenario catalog for full-attainment proof. |
| /.octon/framework/lab/replay/** | update | Populate replay packs and workload definitions. |
| /.octon/framework/lab/shadow/** | update | Populate shadow-run packs for admitted surfaces. |
| /.octon/framework/lab/faults/** | update | Populate fault rehearsals for recovery proof. |
| /.octon/framework/lab/probes/** | update | Populate evaluator-independence and runtime probes. |
| /.octon/framework/observability/runtime/contracts/** | update | Harden intervention, measurement, drift, and reporting contracts. |

## Archive / Provenance Changes

| Path / family | Action | Why it changes |
| --- | --- | --- |
| /.octon/state/evidence/runs/**/evidence-classification.yml | update | Assign tri-class evidence consistently across runs. |
| /.octon/state/evidence/runs/**/replay-pointers.yml | update | Bind replay pointers to hash/provenance checks. |
| /.octon/state/evidence/runs/**/trace-pointers.yml | update | Require trace-query coverage for every admitted run class. |
| /.octon/state/evidence/runs/**/interventions/** | update | Capture every human intervention and manual repair. |
| /.octon/state/evidence/runs/**/measurements/** | update | Capture cost/latency/failure taxonomy consistently. |
| /.octon/state/evidence/disclosure/runs/**/run-card.yml | regenerate | Regenerate truthful run disclosures from canonical sources only. |
| /.octon/state/evidence/disclosure/releases/<cutover-release-id>/harness-card.yml | add-or-regenerate | Emit the universal full-attainment HarnessCard. |
| /.octon/state/evidence/disclosure/releases/<cutover-release-id>/manifest.yml | add-or-regenerate | Release disclosure manifest for the cutover release. |
| /.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/** | add | Closure evidence bundle for certification. |
| /.octon/state/evidence/external-index/** | update | Hash/provenance linkage for external immutable evidence. |
| /.octon/state/evidence/lab/** | update | Retained evidence for scenarios, replay, shadow, probes, and faults. |
| /.octon/instance/governance/decisions/ADR-UEC-001-universal-claim-semantics.md | add | Durable decision record for universal vs bounded claim semantics. |
| /.octon/instance/governance/decisions/ADR-UEC-002-objective-stack-normalization.md | add | Durable decision record for mission/run/stage semantics. |
| /.octon/instance/governance/decisions/ADR-UEC-003-runtime-authority-centralization.md | add | Durable decision record for authority centralization. |
| /.octon/instance/governance/decisions/ADR-UEC-004-capability-pack-admission.md | add | Durable decision record for capability pack governance and admission. |
| /.octon/instance/governance/decisions/ADR-UEC-005-external-replay-proof.md | add | Durable decision record for evidence externalization and replay proof. |
| /.octon/instance/governance/decisions/ADR-UEC-006-agency-simplification-and-retirement.md | add | Durable decision record for architect surface retirement and orchestrator-only kernel. |
| /.octon/instance/governance/decisions/ADR-UEC-007-dual-precedence-resolution.md | add | Durable decision record for precedence resolution. |
| /.octon/instance/governance/decisions/ADR-UEC-008-proof-plane-and-lab-closure.md | add | Durable decision record for proof/lab closure requirements. |
| /.octon/instance/governance/decisions/ADR-UEC-009-support-target-universe.md | add | Durable decision record for full target support universe. |
| /.octon/instance/governance/decisions/ADR-UEC-010-full-attainment-certification.md | add | Durable closeout decision for full Unified Execution Constitution attainment. |

## Discovery / Index Changes

| Path / family | Action | Why it changes |
| --- | --- | --- |
| /.octon/generated/effective/closure/** | regenerate | Regenerate claim status, parity, and closure projections from canonical authority. |
| /.octon/generated/effective/precedence/** | add-or-regenerate | Generated effective precedence views from one resolver. |

## Validator / Ci Changes

| Path / family | Action | Why it changes |
| --- | --- | --- |
| /.octon/framework/assurance/behavioral/** | update | Add held-out, shadow, browser/API, and evaluator-independence suites. |
| /.octon/framework/assurance/functional/api/** | update | Add browser/API capability-pack conformance suites. |
| /.octon/framework/assurance/governance/** | update | Add support-target, authority-centralization, run-card truth, and intervention completeness suites. |
| /.octon/framework/assurance/recovery/** | update | Add replay restore and durable lifecycle suites. |
| /.octon/framework/assurance/maintainability/** | update | Add proof-plane coverage, measurement-trace coverage, retirement, and dual-pass idempotence suites. |
| /.octon/framework/assurance/scripts/validate-authority-classification.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-mirror-parity.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-precedence-resolution.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-objective-stack.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-mission-run-normalization.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-authority-centralization.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-authority-artifacts.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-fail-closed-routing.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-support-target-admission.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-capability-packs.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-run-roots.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-durable-lifecycle.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-evidence-retention.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-external-replay-restore.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-interventions.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-measurements.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-proof-planes.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-lab-substance.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-evaluator-independence.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-run-card-truth.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-harness-card-claim.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-legacy-retirement.sh | add | Executable validator used by CI and local certification. |
| /.octon/framework/assurance/scripts/validate-dual-pass-idempotence.sh | add | Executable validator used by CI and local certification. |
| /.github/workflows/pr-autonomy-policy.yml | update | Project canonical authority artifacts into PR status without minting authority and emit intervention evidence. |
| /.github/workflows/ai-review-gate.yml | update | Consume canonical authority/disclosure outputs, upload intervention completeness evidence, and fail on policy drift. |
| /.github/workflows/uec-cutover-validate.yml | add | Blocking workflow for full-attainment validation pass 1 and pass 2. |
| /.github/workflows/uec-cutover-certify.yml | add | Blocking workflow for closure certificate and no-diff proof. |
| /.github/workflows/uec-drift-watch.yml | add | Post-cutover drift monitor for mirrors, support-targets, disclosure, and retired surfaces. |
