## PACKET_MANIFEST.md

# Packet Manifest

## Packet identity

- Proposal id: `octon-frontier-governance-target-state`
- Proposal kind: `architecture`
- Proposal path: `/.octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state/`
- Promotion scope: `octon-internal`
- Status: `draft`

## Root files

- `README.md`
- `proposal.yml`
- `architecture-proposal.yml`
- `PACKET_MANIFEST.md`
- `SHA256SUMS.txt`
- `FULL_PACKET_CONTENTS.md`

## Navigation

- `navigation/source-of-truth-map.md`
- `navigation/artifact-catalog.md`

## Architecture

- `architecture/target-architecture.md`
- `architecture/current-state-gap-map.md`
- `architecture/concept-coverage-matrix.md`
- `architecture/file-change-map.md`
- `architecture/deletion-collapse-retention-matrix.md`
- `architecture/implementation-plan.md`
- `architecture/migration-cutover-plan.md`
- `architecture/validation-plan.md`
- `architecture/acceptance-criteria.md`
- `architecture/cutover-checklist.md`
- `architecture/execution-constitution-conformance-card.md`
- `architecture/support-target-and-adapter-strategy.md`
- `architecture/actor-runtime-cognition-assurance-model.md`
- `architecture/closure-certification-plan.md`
- `architecture/promotion-targets.md`

## Resources

- `resources/frontier-governance-architecture-review.md`
- `resources/repository-baseline-audit.md`
- `resources/coverage-traceability-matrix.md`
- `resources/evidence-plan.md`
- `resources/decision-record-plan.md`
- `resources/risk-register.md`
- `resources/assumptions-and-blockers.md`
- `resources/rejection-ledger.md`

## Archive notes

This manifest enumerates the packet as created for exploratory review. It is not a generated proposal registry and does not outrank `proposal.yml` or `architecture-proposal.yml`.


## README.md

# Octon Frontier Governance Target-State Architecture Proposal

## Packet path

`/.octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state/`

## Purpose

This packet converts the repository-grounded **Octon frontier-governance architecture review** into a manifest-governed, promotion-aware architecture proposal for taking Octon to its target state:

> A minimum sufficient governance harness for frontier-model engineering: one accountable orchestrator, deterministic context packs, engine-owned authorization, deny-by-default capability gates, retained evidence, replay, rollback, intervention, support-proof dossiers, and automated assurance.

This packet is not canonical authority. It is an exploratory proposal package. Durable outcomes must be promoted into the `promotion_targets` declared by `proposal.yml`, and those promoted targets must stand alone after this packet is archived.

## Executive determination

Octon should not become a thin wrapper around frontier models. The repo's strongest surfaces are exactly the surfaces that become more important as frontier models become more capable: constitutional authority, engine-owned authorization, deny-by-default capability gates, run roots, retained evidence, support-target honesty, replay, rollback, intervention, and assurance.

Octon should, however, delete or demote surfaces whose primary value was compensating for older model limitations: token-era context-routing logic, workflow catalogs that merely choreograph reasoning, cognition/read-model surfaces that drift toward memory or authority, support claims not tied to proof, and multi-actor terminology that implies agent swarms instead of accountable execution roles.

## Proposal authority posture

The packet follows Octon's active proposal convention:

1. `proposal.yml` is the shared lifecycle authority for this proposal packet.
2. `architecture-proposal.yml` is the architecture subtype manifest.
3. `navigation/source-of-truth-map.md` records canonical authorities, proposal-local authorities, derived projections, retained evidence, and boundary rules.
4. Architecture and resource files are working artifacts.
5. `navigation/artifact-catalog.md` and `PACKET_MANIFEST.md` enumerate packet contents.
6. `SHA256SUMS.txt` provides archive integrity.

## Required upstream source

The full prior review is included verbatim in:

`resources/frontier-governance-architecture-review.md`

The packet's traceability from that review to adopted, adapted, deferred, rejected, and split implementation motions is captured in:

- `resources/coverage-traceability-matrix.md`
- `architecture/concept-coverage-matrix.md`
- `architecture/deletion-collapse-retention-matrix.md`

## Reading order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `navigation/source-of-truth-map.md`
4. `resources/frontier-governance-architecture-review.md`
5. `resources/repository-baseline-audit.md`
6. `architecture/target-architecture.md`
7. `architecture/current-state-gap-map.md`
8. `architecture/deletion-collapse-retention-matrix.md`
9. `architecture/file-change-map.md`
10. `architecture/implementation-plan.md`
11. `architecture/migration-cutover-plan.md`
12. `architecture/validation-plan.md`
13. `architecture/acceptance-criteria.md`
14. `architecture/closure-certification-plan.md`

## Non-authority notice

This packet lives under `inputs/exploratory/proposals/**`. It is excluded from runtime resolution, policy resolution, bootstrap export, and repo snapshot authority. It must never become a second control plane. Promotion outputs must point to durable `.octon/**` surfaces outside the proposal tree.


## architecture-proposal.yml

schema_version: "architecture-proposal-v1"
architecture_scope: "cross-domain-architecture"
decision_type: "boundary-change"
target_state_claims:
  - id: "frontier-governance-harness"
    claim: >-
      Octon should be a control plane and evidence harness for consequential frontier-model
      engineering work, not a cognition scaffold for weak models.
  - id: "single-accountable-orchestrator"
    claim: >-
      The default execution topology is one accountable orchestrator, optional bounded specialists,
      and optional independent verifier for separation-of-duties or high-materiality work.
  - id: "context-pack-default"
    claim: >-
      Context assembly should move from token-era discovery/progressive disclosure toward deterministic
      context packs with authority labels, freshness, source hashes, and generated/authoritative separation.
  - id: "engine-owned-authorization"
    claim: >-
      Engine-owned authorize_execution remains the mandatory material execution boundary and becomes
      broader and more proof-producing as frontier models become more capable.
  - id: "proof-backed-support"
    claim: >-
      Support targets must be tuple-based, schema-valid, dossier-backed, and fail-closed on drift.
current_state_findings:
  - id: "root-class-split-strong"
    disposition: "retain"
    evidence: ".octon/README.md defines framework and instance as authored authority, state as operational truth/evidence, generated as rebuildable, and inputs as non-authoritative."
  - id: "runtime-authorization-strong"
    disposition: "strengthen"
    evidence: ".octon/framework/engine/runtime/spec/execution-authorization-v1.md makes authorize_execution mandatory before material side effects."
  - id: "support-claim-drift"
    disposition: "fix-first"
    evidence: "support-targets.yml uses bounded-admitted-live-universe, while support-targets.schema.json allows bounded-admitted-finite and global-complete-finite."
  - id: "overlay-drift"
    disposition: "fix-first"
    evidence: ".octon/README.md lists fewer overlay-capable surfaces than overlay-points/registry.yml and instance/manifest.yml."
  - id: "browser-api-ahead-of-runtime"
    disposition: "stage-until-proved"
    evidence: "browser/API packs reference runtime contracts and replay requirements, while services/manifest.runtime.yml lists filesystem/KV/flow services but not browser-session/api-client as active runtime services."
  - id: "workflow-catalog-pressure"
    disposition: "audit-collapse"
    evidence: "orchestration workflow manifest contains a broad catalog, some of which is governance-critical and some of which may encode token-era process scaffolding."
proposal_motions:
  required_deletions_or_demotions:
    - "Move experimental external model adapter out of active discovery or mark quarantined/stage-only with validator enforcement."
    - "Delete or demote workflows that merely choreograph model reasoning and do not create authority/evidence/recovery value."
    - "Remove support claims that are not schema-valid, tuple-admitted, and dossier-backed."
    - "Forbid generated cognition as authority, memory, approval, or runtime policy."
  required_simplifications:
    - "Collapse actor model to accountable orchestrator, bounded specialist, optional verifier, and team/composition profile."
    - "Collapse capability teaching model to instruction-level operator contracts and invocation-level runtime contracts."
    - "Collapse support declarations around admitted tuples as operational truth."
    - "Collapse token-budget/progressive-disclosure rationale into context-pack/budget policy."
  required_expansions:
    - "Add risk/materiality classifier and policy."
    - "Add context-pack contract and retained evidence receipts."
    - "Add rollback-plan, browser/UI execution record, API-egress record, and benchmark-suite contracts."
    - "Add browser/API runtime services only when executable, support-dossier-backed, and replay/evidence producing."
    - "Automate RunCard/HarnessCard generation from retained evidence."
validation_motions:
  - "Add structural drift validators for support-target vocabulary, overlay points, cognition runtime index, service manifest vs capability packs, and generated freshness."
  - "Add governance validators for material action grants, capability admissions, risk/materiality classifications, egress leases, and budget enforcement."
  - "Add runtime validators for run roots, evidence roots, receipts, replay pointers, rollback posture, and intervention records."
  - "Add comparative frontier benchmark validation against raw model and thin-wrapper baselines."
acceptance_gates:
  - "No material side effect path bypasses authorize_execution."
  - "No support claim exists outside admitted tuple proof."
  - "No generated or proposal-local artifact is consumed as authority."
  - "Browser/API support remains stage-only until active runtime services and support dossiers pass validation."
  - "RunCards and HarnessCards are generated from retained evidence, not manual statements."
major_risks:
  - "Over-simplification could remove governance rather than cognition scaffolding."
  - "Long-context frontier models could create false confidence without context-pack provenance."
  - "Support truth may look narrower when tuple-backed honesty replaces broad declarative support."
  - "Browser/API/multimodal governance may require substantial runtime implementation before claims are safe."
  - "Assurance may remain taxonomy-heavy unless benchmark and proof automation lands."


## architecture/acceptance-criteria.md

# Acceptance Criteria

## Packet-level acceptance

The proposal packet is review-ready when:

- `proposal.yml` and `architecture-proposal.yml` are present and valid.
- `resources/frontier-governance-architecture-review.md` includes the full upstream review.
- All required architecture and resource files exist.
- `navigation/source-of-truth-map.md` distinguishes canonical authority, proposal-local authority, generated projections, and retained evidence.
- `SHA256SUMS.txt` is generated for packet contents.
- `FULL_PACKET_CONTENTS.md` contains concatenated packet contents for archival review.

## Target-state implementation acceptance

The target state is accepted only when all of the following are true:

1. **Support truth**
   - `support-targets.yml` validates against `support-targets.schema.json`.
   - Support mode vocabulary is consistent across live file, schema, charter, and docs.
   - Operational support truth is finite admitted tuples with support dossiers.

2. **Authority clarity**
   - No runtime, policy, approval, support, or publication path treats raw inputs, generated outputs, proposals, host UI, chat state, or model memory as authority.
   - Durable promoted targets do not depend on this proposal path.

3. **Run enforceability**
   - No material side effect occurs without execution request, grant/denial, run control root, run evidence root, receipt obligations, and rollback posture when required.
   - Denials and escalations emit machine-readable reason codes and retained receipts.

4. **Context legitimacy**
   - Consequential runs have context packs with source hashes, authority labels, freshness checks, generated/authoritative separation, token/byte accounting, and known omissions.
   - Generated cognition is used only as a derived read model and is provenance-labeled.

5. **Capability gating**
   - Tools, services, browser/API packs, and adapters execute only through admitted packs, granted capabilities, and support-target-compatible routes.
   - Browser/API actions fail closed unless runtime service, egress/replay evidence, and support dossier requirements are met.

6. **Rollback and recovery**
   - Material actions have rollback or compensation posture consistent with materiality.
   - Recovery drills for repo mutation, stale context, circuit breaker, mission pause/resume, and browser/API staged scenarios produce retained evidence.

7. **Intervention quality**
   - Pause, narrow, revoke, safing, resume, and circuit-breaker paths are validated and evidenced.
   - Human interventions are control/evidence artifacts, not hidden chat or UI state.

8. **Proof automation**
   - RunCards are generated from retained run evidence.
   - HarnessCards are generated from support/lab/benchmark evidence.
   - Evidence completeness is machine-checked.

9. **Benchmark honesty**
   - Octon is benchmarked against raw frontier-model and thin-wrapper baselines.
   - Octon demonstrates governance value at acceptable overhead: better authorization discipline, evidence completeness, replayability, rollback/recovery quality, and support-claim correctness.

10. **Actor simplicity**
    - A consequential run has exactly one accountable orchestrator.
    - Specialists are bounded and optional.
    - Verifier is optional and materially justified.
    - Teams are composition profiles, not runtime actors.

11. **Workflow economy**
    - Retained core workflows encode authority, evidence, recovery, publication, or support-admission value.
    - Thinking-only workflows are removed, demoted, or moved to practices/optional packs.

12. **Portability honesty**
    - Frontier-native and degraded/local tiers are explicitly declared.
    - Adapter claims are proof-backed and limited to admitted tuples.
    - Experimental adapters cannot produce live support claims.

## Rejection criteria

Reject or defer this proposal if implementation attempts to:

- treat generated cognition as authority;
- make proposal files runtime dependencies;
- broaden support claims without tuple proof;
- make browser/API/multimodal support live before runtime/evidence readiness;
- delete governance surfaces merely because they resemble old AI tooling;
- preserve workflows, agent topologies, or cognition layers without governance/runtime/assurance value.


## architecture/actor-runtime-cognition-assurance-model.md

# Actor, Runtime, Cognition, and Assurance Model

## Actor model

### Target vocabulary

| Term | Durable meaning | Runtime status |
|---|---|---|
| Accountable orchestrator | Single owner for planning, execution discipline, delegation, risk tiering, final integration, and closeout. | Required for consequential run. |
| Bounded specialist | Focused assistant or specialist role with narrow permissions and escalation triggers. | Optional. |
| Independent verifier | Separate judgment role used for materiality, separation-of-duties, or benchmark/proof needs. | Optional and justified. |
| Team/profile | Reusable composition/routing configuration. | Not a runtime actor. |

### Rules

- Exactly one accountable orchestrator per consequential run.
- Specialists cannot own missions or mint authority.
- Verifier cannot retroactively authorize actions; it supplies evidence/judgment through canonical control/evidence paths.
- Teams cannot become hidden swarms or second schedulers.
- Actor privilege is least-privilege and capability-gated.

## Runtime model

### Minimum runtime-native services

1. Run manager.
2. Authorization/policy engine.
3. Capability gateway.
4. Context assembler.
5. Evidence/receipt store.
6. Telemetry/replay store.
7. Lease/directive/circuit-breaker controller.
8. Rollback/recovery service.
9. Host/model adapter boundary.
10. Browser/UI service when admitted.
11. API/connector egress service when admitted.
12. Assurance/benchmark runner.

### Material execution invariant

No material path may bypass:

```text
ExecutionRequest -> authorize_execution -> GrantBundle -> governed invocation -> ExecutionReceipt -> retained evidence
```

## Cognition/context/retrieval model

### Target posture

- Context packs are the primary frontier-native context unit.
- Generated cognition is derived read-model material only.
- Retrieval is used when justified by data size, dynamism, externality, legal scope, or exact provenance, not as accidental memory.
- Raw inputs and proposals are source material only and never direct runtime/policy dependencies.
- Context packs must record provenance, freshness, source hashes, authority labels, generated/authoritative separation, and omissions.

### Generated cognition guardrails

Generated cognition may:

- summarize missions;
- project operator digests;
- provide read-only graph/projection datasets;
- help build context packs when fresh and labeled.

Generated cognition may not:

- approve or deny actions;
- define support truth;
- override policy;
- serve as mission control state;
- be treated as ADR/memory authority;
- satisfy evidence obligations.

## Orchestration/mission/run model

- Missions are continuity containers.
- Runs are atomic consequential execution units.
- Workflows are governance/evidence/recovery/publication procedures, not model-thought recipes.
- Stage/promote/finalize patterns remain valid when they encode authority and evidence.
- Workflow-only execution remains transitional compatibility and should expire.

## Assurance model

Assurance must prove these properties:

1. structural coherence;
2. authority correctness;
3. support-target truth;
4. capability admission correctness;
5. runtime receipt completeness;
6. replayability;
7. rollback/recovery quality;
8. intervention quality;
9. behavior under faults and denials;
10. comparative governance value against raw frontier-model baselines.

## Benchmark model

Benchmark suites should compare:

- raw frontier model with same context;
- raw frontier model plus thin tool wrapper;
- Octon-governed single-orchestrator run;
- Octon-governed run with verifier;
- degraded/local profile.

The primary score is not intelligence gain. The primary score is governance value: authorized actions, denied unsafe actions, evidence completeness, replayability, rollback/recovery, intervention quality, and support honesty.


## architecture/closure-certification-plan.md

# Closure Certification Plan

## Certification purpose

Closure certification proves that accepted target-state changes have been promoted into durable Octon surfaces, validated, evidenced, and decoupled from this proposal packet.

## Certification sequence

1. **Proposal validation**
   - Validate packet structure.
   - Confirm required files and source review inclusion.
   - Regenerate proposal registry.

2. **Authority validation**
   - Validate support-targets against schema.
   - Validate overlay agreement.
   - Validate cognition runtime index.
   - Validate no generated/proposal source is authority.

3. **Runtime validation**
   - Execute reference run.
   - Confirm run/control/evidence roots.
   - Confirm context pack, risk/materiality classification, grant, receipt, rollback posture, replay pointers.

4. **Support validation**
   - Validate admitted tuple support dossier.
   - Validate adapter conformance evidence.
   - Validate browser/API stage-only or live proof.

5. **Recovery/intervention validation**
   - Run recovery drills.
   - Run intervention/circuit-breaker drills.
   - Retain evidence.

6. **Benchmark validation**
   - Run raw frontier baseline.
   - Run thin-wrapper baseline.
   - Run Octon-governed baseline.
   - Compare metrics.

7. **Card generation**
   - Generate RunCard from retained run evidence.
   - Generate HarnessCard from support/lab/benchmark evidence.

8. **Promotion dependency scan**
   - Scan all durable promotion targets for references to this proposal path.
   - Fail closure if durable targets depend on proposal-local artifacts.

9. **Decision closeout**
   - Write ADR/decision records under durable decision surfaces.
   - Record accepted/deferred/rejected components.

10. **Archive decision**
    - Archive proposal as implemented, rejected, superseded, or historical.

## Required retained evidence

- Proposal validation receipt.
- Support-target schema receipt.
- Overlay validation receipt.
- Cognition runtime validation receipt.
- Execution reference run evidence.
- Context-pack receipt.
- Risk/materiality receipt.
- Grant/receipt bundle.
- Replay and trace pointers.
- Rollback/recovery drill evidence.
- Browser/API stage/live proof evidence.
- Benchmark results.
- RunCard.
- HarnessCard.
- Promotion dependency scan result.
- Decision record links.

## Certification failure conditions

- Any live support claim is not tuple-admitted and dossier-backed.
- Any generated/proposal/raw input surface is used as authority.
- Any material side effect bypasses `authorize_execution`.
- Browser/API live support is claimed without runtime service and evidence.
- RunCards or HarnessCards are manually asserted rather than evidence-generated.
- Durable target references proposal path as ongoing authority.


## architecture/concept-coverage-matrix.md

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


## architecture/current-state-gap-map.md

# Current-State Gap Map

## Current strengths

| Surface | Current repository evidence | Target-state implication |
|---|---|---|
| Super-root class split | `/.octon/README.md` defines `framework`, `instance`, `inputs`, `state`, and `generated`; only `framework/**` and `instance/**` are authored authority. | Retain. This is the backbone of authority/control/evidence/derived separation. |
| Generated contract | `/.octon/README.md` and cognition umbrella spec say generated outputs are rebuildable and never source-of-truth. | Retain and enforce harder for context packs and cognition read models. |
| Constitution | `/.octon/framework/constitution/CHARTER.md` says Octon exists to make consequential autonomous work scoped, authorized, fail-closed, observable, and reviewable. | Retain. This is the strongest frontier-era framing. |
| Engine authorization | `execution-authorization-v1.md` requires material execution through `authorize_execution(request) -> GrantBundle` and no side effects before a valid grant. | Strengthen and broaden into all material browser/API/multimodal actions. |
| Run-first lifecycle | Runtime README exposes `octon run start/inspect/resume/checkpoint/close/replay/disclose` and binds run/evidence roots before side effects. | Retain as atomic consequential execution model. |
| Agency direction | Agency spec removes `subagents` as first-class artifact; registry has default orchestrator and optional verifier. | Retain and make this the explicit future actor model. |
| Capability governance | Capability README separates command/skill/tool/service surfaces and says browser/API packs fail closed until repo-local admission. | Retain but simplify conceptual model. |
| Browser/API contracts | Browser/API packs require replay, authority artifacts, RunCard/HarnessCard coverage, and fail-closed limitations. | Keep as design intent; do not treat as live until runtime implementation/proof exists. |
| Assurance/lab/observability | Assurance, lab, and observability surfaces exist as proof-plane scaffolding. | Strengthen into automated proof and benchmark production. |
| Proposal conventions | Proposal README and standards define proposal packets as temporary and non-canonical. | This packet follows proposal conventions and declares durable promotion targets. |

## Current drift / contradictions

| Drift | Current evidence | Why it matters | Required correction |
|---|---|---|---|
| Support-claim vocabulary drift | `support-targets.yml` uses `bounded-admitted-live-universe`; schema allows `bounded-admitted-finite` and `global-complete-finite`; charter uses globally complete finite language. | Support claims are governance authority; vocabulary mismatch undermines fail-closed validation. | Reconcile file/schema/charter and make admitted tuples operational truth. |
| Overlay-point drift | `.octon/README.md` lists four overlay-capable surfaces; overlay registry/instance manifest list additional governance adoption/retirement/exclusions/capability-packs/decisions. | Overlay points shape repo authority. Drift can admit or deny authority incorrectly. | Make overlay registry canonical and regenerate/update README and validators. |
| Browser/API support ahead of runtime | Browser/API pack manifests reference `browser-session` and `api-client`; `services/manifest.runtime.yml` lists filesystem/KV/flow only. | Capability claims can outrun executable support. | Keep browser/API stage-only until runtime services, evidence, tests, and support dossiers exist. |
| Cognition runtime index drift | Cognition umbrella spec allows derived cognition only; runtime index/reviewed surfaces appear broader than visible implemented runtime surfaces. | Old-era cognition scaffolding can accidentally become authority. | Either implement claimed runtime surfaces or collapse cognition runtime to actual context/reference surfaces. |
| Experimental adapter leakage | `experimental-external.yml` exists in model adapter area with experimental tier hints. | Experimental adapters should not be live-discovered or imply support. | Move to quarantine/inputs or add explicit stage-only validation. |
| Token-era routing pressure | Capability and workflow docs include token-budget/progressive-disclosure rationale. | 1M-context frontier models reduce token scarcity as an architectural driver. | Move cost/token concerns to context-pack budgets and degraded-profile policies. |

## Missing executable surfaces relative to target state

| Missing / partial surface | Current repo posture | Target-state requirement |
|---|---|---|
| Risk/materiality classifier | Risk tier exists in execution request; no first-class cross-surface classifier found in reviewed surfaces. | Add contract and instance policy that drives authorization, evidence, rollback, approval, and support requirements. |
| Context-pack contract | Context/generation surfaces exist; no first-class context-pack contract found. | Add deterministic context-pack contract and retained receipts. |
| Browser/UI execution record | Browser pack requires DOM/screenshot/session replay; runtime service not active in manifest. | Add browser runtime service and evidence record before live support. |
| API egress record | API pack requires request/response trace and compensation; network egress policy is narrow. | Add connector lease and API egress record before live support. |
| Rollback-plan contract | Receipts include rollback/compensation handles; rollback posture exists under run roots. | Add pre-action rollback-plan contract and recovery drill validation. |
| Benchmark suite | Lab/assurance surfaces exist; comparative frontier baseline benchmark is not visibly first-class. | Add benchmark suite contract and raw-model/thin-wrapper baselines. |
| Automated RunCard/HarnessCard generation | Evidence obligations exist; RunCard/HarnessCard terms appear in packs/review. | Add schemas and generation validators tied to retained evidence. |
| Drift validators | Validators exist in proposal/conformance areas; specific drift checks need expansion. | Add validators for support, overlay, cognition, service/pack, generated freshness, and proposal promotion. |

## Gap-to-target mapping

| Target-state requirement | Current coverage | Gap | Priority |
|---|---|---|---|
| One accountable orchestrator | Mostly covered by agency spec/registry | Make it the user-facing default and constrain team/specialist usage. | P1 |
| Deterministic context packs | Partially covered by context/generated/cognition roots | Add context-pack contract, evidence receipts, validators. | P1 |
| Engine-owned authorization | Strong existing spec | Ensure browser/API/multimodal/tool/service paths cannot bypass it. | P1 |
| Deny-by-default capability gates | Strong design, active services limited | Tie packs/services/admissions/support to grants and evidence. | P1 |
| Retained evidence | Strong root split and receipts | Automate evidence completeness and RunCard generation. | P1 |
| Replay | Runtime and lab surfaces exist | Add browser/API/multimodal replay records and benchmarks. | P2 |
| Rollback | Receipts/posture exist | Add rollback-plan contract and recovery drills. | P1 |
| Intervention | Lease/directive/breaker schemas exist | Exercise and validate in long-running runs. | P2 |
| Support-proof dossiers | Support dossier refs exist | Make support claims fail if dossier incomplete or schema-invalid. | P0 |
| Automated assurance | Assurance/lab/observability exist | Add benchmark runner, graders, RunCard/HarnessCard automation. | P2 |


## architecture/cutover-checklist.md

# Cutover Checklist

## Before promotion work starts

- [ ] Packet materialized at the active architecture proposal path.
- [ ] `proposal_id` matches final directory name.
- [ ] Proposal registry can be regenerated from manifests.
- [ ] Source review is included in full.
- [ ] Promotion targets are outside proposal tree and under `.octon/`.
- [ ] No runtime/policy consumer reads proposal paths.

## Phase 0 authority cleanup

- [ ] Support claim mode vocabulary reconciled.
- [ ] Support targets validate against schema.
- [ ] Tuple admissions are operational support truth.
- [ ] Overlay registry, instance manifest, and README agree.
- [ ] Cognition runtime index matches implemented surfaces or is trimmed.
- [ ] Experimental external adapter quarantined or hard stage-only.
- [ ] Drift validators added.

## Phase 1 run core

- [ ] Risk/materiality schema and policy added.
- [ ] Context-pack schema added.
- [ ] Rollback-plan schema added.
- [ ] Execution request/grant/receipt updated or migration path defined.
- [ ] Run/evidence roots bind before material action.
- [ ] Context-pack receipt generated for reference run.
- [ ] Rollback posture validated for material run.

## Phase 2 simplification

- [ ] Workflow catalog audited.
- [ ] Thinking-only workflows deleted/demoted.
- [ ] Actor terminology simplified.
- [ ] Capability docs simplified.
- [ ] Token-era routing moved to budgets/degraded profiles.
- [ ] Generated cognition authority ban validated.

## Phase 3 browser/API

- [ ] Browser-session service contract and implementation ready or pack remains stage-only.
- [ ] API-client service contract and implementation ready or pack remains stage-only.
- [ ] Browser/UI execution record schema added.
- [ ] API egress record schema added.
- [ ] Connector leases and egress rules added.
- [ ] Replay/event ledger evidence generated.
- [ ] Support dossiers and tuple admissions exist before live claims.

## Phase 4 recovery/intervention

- [ ] Mission leases exercised.
- [ ] Control directives exercised.
- [ ] Circuit breaker trip/reset exercised.
- [ ] Safing mode exercised.
- [ ] Rollback drills pass.
- [ ] Recovery evidence retained.

## Phase 5 assurance/benchmark

- [ ] Benchmark-suite schema added.
- [ ] Raw frontier-model baseline defined.
- [ ] Thin-wrapper baseline defined.
- [ ] Octon-governed baseline defined.
- [ ] Evidence graders added.
- [ ] RunCard generated from run evidence.
- [ ] HarnessCard generated from support/lab evidence.

## Final closeout

- [ ] All accepted promotion targets exist.
- [ ] Durable targets have no proposal-path dependencies.
- [ ] Required validators pass.
- [ ] Required evidence is retained.
- [ ] Decision records are written.
- [ ] Proposal is archived or left active only with explicit remaining work.


## architecture/deletion-collapse-retention-matrix.md

# Deletion, Collapse, Retention, and Expansion Matrix

| Surface / pattern | Current role | Frontier-era concern | Governance/runtime/assurance value | Loss if removed | Replacement / durable destination | Recommended action | Priority |
|---|---|---|---|---|---|---|---|
| Experimental external model adapter | Placeholder provider bridge with experimental tier hints. | Can leak unsupported support claims or active discovery. | Low unless explicitly quarantined. | Future experimentation path. | Move to quarantined experimental registry or `inputs/exploratory`; require support-target admission before activation. | Relocate / stage-only | P0 |
| Schema-invalid support claim mode | Live support file uses a mode not in schema. | Support truth becomes ambiguous. | High concept value, invalid implementation. | Support target matrix. | Align schema/file/charter and tuple admissions. | Modify immediately | P0 |
| Generated cognition as authority | Derived summaries/projections can help operators. | Old-era memory/RAG scaffolding may become accidental authority. | High only as derived read model. | Summaries/projections/operator digests. | Context-pack inputs with source hashes/freshness and authority labels. | Keep as derived; forbid authority use | P0/P1 |
| Thinking-only workflows | Procedural model guidance and task choreography. | Frontier models can plan internally; workflow bloat adds control-plane complexity. | Low unless tied to authorization/evidence/recovery. | Some familiar operator recipes. | Practice guides or optional workflow packs. | Delete/demote after audit | P1 |
| Governance/evidence workflows | Stage/promote/finalize, support admission, validation, migration, recovery. | Not obsolete; they encode execution legitimacy. | High. | Authority/evidence gates. | Durable workflow core. | Retain/strengthen | P1 |
| Multi-agent swarm terminology | Agents, assistants, teams may imply multi-agent topology. | Strong models reduce need for role-play decomposition. | Medium/high if used for accountability/separation-of-duties. | Some coordination vocabulary. | Accountable orchestrator, bounded specialist, optional verifier, team profile. | Collapse terminology | P1 |
| `subagents` artifact class | Previously ambiguous artifact class. | Redundant and bloat-prone. | Low. | None if runtime terminology remains. | Runtime assistant invocation term only. | Remove/forbid | Already aligned; enforce |
| Commands/skills/tools/services as many nouns | Capability taxonomy for different control/granularity models. | User-facing complexity can obscure permissioning. | High when tied to contracts and gates. | Discovery clarity. | Two-class teaching model: instruction contracts and invocation contracts. | Simplify docs; retain dirs | P1 |
| Token-budget/progressive-disclosure as architecture | Helps smaller models and cost controls. | 1M-context frontier models make token scarcity less central. | Medium as budget/degraded profile. | Smaller/local support and cost guardrails. | Context-pack budgets, execution budgets, degraded profiles. | Modify, not delete | P1 |
| Browser pack | Governs UI-driving surfaces. | Pack references runtime service not active in manifest. | High once executable. | Browser automation governance. | Stage-only until browser-session service, replay, evidence, support dossier. | Strengthen after proof | P2 |
| API pack | Governs outbound API/connectors. | Egress policy is narrow; service not active in manifest. | High once executable. | API governance. | Connector leases, API client runtime, egress records, support dossier. | Strengthen after proof | P2 |
| Support matrix broad classes | Declares model/workload/context/locale/adapter universe. | Broad declarations can outpace proof. | High as taxonomy, not support truth. | Discovery and planning taxonomy. | Finite admitted tuples as operational truth. | Collapse operational semantics | P0 |
| Support dossiers | Referenced in support-targets. | Need stronger evidence production. | Very high. | Proof-backed support claims. | HarnessCard and conformance evidence. | Strengthen | P1 |
| Engine authorize_execution | Material action gate. | None; frontier models increase need. | Critical. | Core safety/control boundary. | Extend with risk/context/rollback/browser/API. | Retain/strengthen | P1 |
| Run roots and evidence roots | Atomic consequential execution. | None. | Critical. | Replay/audit/rollback. | Add context-pack, rollback, browser/API records. | Retain/strengthen | P1 |
| Mission continuity | Long-running work state. | Need avoid mission-only execution fallback. | High as continuity container. | Long-running autonomy continuity. | Mission + run contract separation. | Retain | P1 |
| Assurance/lab/observability taxonomies | Proof-plane design. | Risk of taxonomy without automation. | High if automated. | Evaluation and support evidence. | Benchmark runner, RunCard/HarnessCard generation. | Strengthen | P2 |
| Host/model adapters | Replaceable projection boundaries. | Generic gateways are less valuable; proof boundaries remain valuable. | High when support-bound. | Portability and isolation. | Tuple-based support and conformance. | Retain/narrow claims | P1 |
| Compatibility wrappers | Ease migration from workflow-first to run-first. | Long-lived dual paths create ambiguity. | Temporary. | Backward compatibility. | Expiring shims with evidence canonicalization. | Deprecate with retirement | P2 |
| Raw inputs/exploratory proposals | Ideation and proposal material. | Can be mistaken for authority. | High as non-authoritative source. | Exploration/proposal workflow. | Source artifacts with promotion into durable targets. | Retain boundary | P0 |


## architecture/execution-constitution-conformance-card.md

# Execution Constitution Conformance Card

## Summary

This proposal conforms to Octon's constitutional intent if and only if it strengthens engine-owned authorization, fail-closed support claims, retained evidence, generated-output boundaries, and run-first execution. It must not become a new authority plane.

## Conformance table

| Constitutional / runtime obligation | Current source | Proposal effect | Required proof |
|---|---|---|---|
| `/.octon` is the single authoritative super-root | `.octon/README.md`, cognition umbrella spec | Preserved. New surfaces are placed under existing class roots. | Placement validator passes. |
| Only `framework/**` and `instance/**` are authored authority | `.octon/README.md` | Preserved. Proposal targets authority under these roots; state is control/evidence; generated is derived. | Source-of-truth map and path validators. |
| Raw `inputs/**` never participate directly in runtime/policy | `.octon/README.md`, cognition umbrella spec | Preserved. This packet is non-authoritative. | Durable targets contain no proposal-path dependencies. |
| Generated outputs are never source of truth | `.octon/README.md`, cognition umbrella spec | Strengthened with context-pack/generation freshness rules. | Generated authority ban validator. |
| Material execution passes through `authorize_execution` | `execution-authorization-v1.md` | Strengthened to include context pack, materiality, rollback, browser/API, egress. | Runtime path tests and receipts. |
| No side effect before grant | `execution-authorization-v1.md` | Preserved and broadened. | Side-effect denial tests. |
| Receipt emission mandatory | `execution-authorization-v1.md`, execution receipt schema | Strengthened with context/replay/rollback/browser/API references. | Receipt completeness validator. |
| Support claims bounded by support targets | support-targets surfaces | Strengthened; schema drift fixed first. | Support-target validation and HarnessCards. |
| Host UI/comments/checks are projections only | execution authorization, cognition umbrella | Preserved. Browser/UI records are evidence, not authority. | Host projection tests. |
| Missions are continuity; runs are atomic execution | `.octon/README.md`, runtime README | Preserved. Context packs and receipts bind to runs. | Mission/run lifecycle tests. |
| Long-running autonomy is mission-scoped and reversible | `.octon/README.md` | Strengthened with leases/directives/breakers/recovery drills. | Intervention/recovery evidence. |

## Required negative tests

- Generated cognition attempts to approve a run: must fail.
- Proposal path referenced by durable runtime target: must fail.
- Browser action without replay evidence: must fail.
- API action without egress lease: must fail.
- Unsupported tuple claim: must fail.
- Material action without context pack when required: must fail.
- Material action without rollback posture when materiality requires it: must fail.
- Team/specialist attempts to own run without accountable orchestrator: must fail.

## Conformance disposition

The proposal is constitution-conformant as an exploratory packet. It becomes implementable only after Phase 0 drift correction and remains non-authoritative until durable promotion targets are updated and validated.


## architecture/file-change-map.md

# File- and Surface-Level Change Map

## Legend

- **Keep**: retain as-is or with editorial clarification only.
- **Modify**: edit existing durable surface.
- **Replace**: swap semantics or schema with a new compatible surface.
- **Relocate**: move to a safer/non-live/non-authoritative location.
- **Deprecate**: mark as transitional with retirement criteria.
- **Remove**: delete after safe replacement or when no governance value remains.
- **Add**: new durable surface.

## Concrete change map

| Current / proposed path | Action | Reason | Promotion / closure requirement | Priority |
|---|---|---|---|---|
| `.octon/README.md` | Modify | Overlay list and support wording must match registry/manifest and target-state generated contract. | README regenerated/updated from canonical registry; no conflict with overlay-points registry. | P0 |
| `.octon/octon.yml` | Modify | Add runtime input hooks for context-pack root, benchmark evidence, browser/API records if accepted. | Schema-compatible root manifest update; portability profiles exclude proposal and state/generated as appropriate. | P1 |
| `.octon/framework/constitution/CHARTER.md` | Modify | Clarify frontier-governance purpose and support-claim vocabulary without weakening current charter. | Charter and support schema terms align. | P0 |
| `.octon/framework/constitution/charter.yml` | Modify | Align support-universe language with schema/live file. | Validator passes against support-target vocabulary. | P0 |
| `.octon/framework/constitution/support-targets.schema.json` | Modify | Current enum does not include live file's `bounded-admitted-live-universe`. | Either schema admits chosen term or live file uses existing enum; tuple-admitted mode documented. | P0 |
| `.octon/instance/governance/support-targets.yml` | Modify | Live file must be schema-valid and tuple admissions must be operational truth. | Support validator passes; unsupported broad claims fail closed. | P0 |
| `.octon/framework/overlay-points/registry.yml` | Modify | Make overlay registry canonical and align docs/instance manifest. | Overlay drift validator passes. | P0 |
| `.octon/instance/manifest.yml` | Modify | Enabled overlay points must agree with registry and docs. | Validator confirms every enabled overlay point is declared and documented. | P0 |
| `.octon/framework/cognition/_meta/architecture/specification.md` | Modify | Add context-pack placement, generated cognition guardrails, and drift rule. | Context pack and generated read-model rules explicit. | P1 |
| `.octon/framework/cognition/runtime/index.yml` | Modify or replace | Current runtime index must not over-declare unimplemented cognition/memory surfaces. | Index matches actual implemented runtime surfaces or surfaces are implemented. | P0 |
| `.octon/generated/cognition/**` | Keep with guardrails | Useful derived summaries/projections; never source of truth. | Freshness/generation-lock validation and context-pack provenance. | P1 |
| `.octon/framework/constitution/contracts/authority/risk-materiality-v1.schema.json` | Add | First-class materiality classification needed for frontier actions. | Schema added, referenced by execution request/grant and policy. | P1 |
| `.octon/instance/governance/policies/risk-materiality.yml` | Add | Repo-specific thresholds for materiality, approvals, evidence, rollback, and support. | Policy validated and applied before grants. | P1 |
| `.octon/framework/constitution/contracts/runtime/context-pack-v1.schema.json` | Add | Deterministic context assembly contract. | Context-pack receipts required for consequential runs. | P1 |
| `.octon/framework/constitution/contracts/runtime/rollback-plan-v1.schema.json` | Add | Pre-action rollback/compensation posture. | Material actions fail closed without matching rollback posture when required. | P1 |
| `.octon/framework/constitution/contracts/runtime/browser-ui-execution-record-v1.schema.json` | Add | Browser/UI governed action evidence. | Required before browser pack live support. | P2 |
| `.octon/framework/constitution/contracts/runtime/api-egress-record-v1.schema.json` | Add | Governed API/connector evidence and egress trace. | Required before API pack live support. | P2 |
| `.octon/framework/constitution/contracts/assurance/benchmark-suite-v1.schema.json` | Add | Comparative frontier benchmark contract. | Benchmark suite produces raw/thin-wrapper/Octon evidence. | P2 |
| `.octon/framework/constitution/contracts/assurance/run-card-v2.schema.json` | Add | Evidence-generated run certification. | RunCards generated from retained evidence. | P2 |
| `.octon/framework/constitution/contracts/assurance/harness-card-v1.schema.json` | Add | Evidence-generated support certification. | HarnessCards generated from support/lab evidence. | P2 |
| `.octon/framework/engine/runtime/spec/execution-authorization-v1.md` | Modify | Include context-pack, risk/materiality, browser/API, rollback prerequisites. | No bypass paths for new material actions. | P1 |
| `.octon/framework/engine/runtime/spec/execution-request-v2.schema.json` | Modify | Add context_pack_ref, risk_materiality_ref/classification, requested_pack_ids, egress/rollback refs. | Backward-compatible additional properties or v3 migration. | P1 |
| `.octon/framework/engine/runtime/spec/execution-grant-v1.schema.json` | Modify | Add granted pack ids, context-pack digest, egress/rollback obligations, evidence obligations. | Grants are sufficient to validate receipts. | P1 |
| `.octon/framework/engine/runtime/spec/execution-receipt-v2.schema.json` | Modify | Add context-pack digest, rollback-plan ref, egress/browser record refs, evidence completeness status. | Receipts close material paths. | P1 |
| `.octon/framework/engine/runtime/spec/mission-control-lease-v1.schema.json` | Modify/strengthen | Existing lease semantics should participate in long-running operation. | Lease lifecycle tested in recovery/intervention suite. | P2 |
| `.octon/framework/engine/runtime/spec/control-directive-v1.schema.json` | Modify/strengthen | Directives must pause/narrow/revoke/safing live runs. | Directive tests and evidence receipts exist. | P2 |
| `.octon/framework/engine/runtime/spec/circuit-breaker-v1.schema.json` | Modify/strengthen | Circuit breakers must be executable and resettable with evidence. | Breaker drills pass. | P2 |
| `.octon/framework/capabilities/README.md` | Modify | Simplify capability conceptual model without removing governance surfaces. | Docs distinguish instruction contracts vs invocation contracts. | P1 |
| `.octon/framework/capabilities/runtime/services/manifest.runtime.yml` | Modify | Active services must match live claims. | Browser/API services only added when implemented and support-dossier-backed. | P1/P2 |
| `.octon/framework/capabilities/runtime/services/browser-session/contract.yml` | Add or implement | Browser pack references this contract. | Contract, service manifest entry, tests, replay/evidence required before live support. | P2 |
| `.octon/framework/capabilities/runtime/services/api-client/contract.yml` | Add or implement | API pack references this contract. | Contract, service manifest entry, egress leases, tests, evidence required before live support. | P2 |
| `.octon/framework/capabilities/packs/browser/manifest.yml` | Modify | Keep pack but mark stage-only until runtime/evidence proof exists. | Support target and runtime manifest agree. | P1 |
| `.octon/framework/capabilities/packs/api/manifest.yml` | Modify | Keep pack but mark stage-only until runtime/evidence proof exists. | Egress policy and connector leases exist. | P1 |
| `.octon/instance/governance/policies/network-egress.yml` | Modify/replace | Current policy only allows local LangGraph runner. | Add connector leases, allowlists, redaction, idempotency, compensation, trace pointers. | P1 |
| `.octon/instance/governance/policies/execution-budgets.yml` | Modify | Current budgets are workflow-stage/provider-focused. | Add run/mission/model/tool/browser/API budgets and long-context thresholds. | P1 |
| `.octon/framework/engine/runtime/adapters/model/experimental-external.yml` | Relocate or stage-only | Experimental adapter should not imply live support. | Quarantine or validator-enforced stage-only with no support claim. | P0 |
| `.octon/framework/agency/_meta/architecture/specification.md` | Modify | Make one-orchestrator/bounded-specialist/verifier model explicit frontier default. | Actor validation passes; team remains composition only. | P1 |
| `.octon/framework/agency/runtime/agents/registry.yml` | Modify | Clarify optional verifier activation and specialist boundary. | Exactly one default orchestrator; no swarm defaults. | P1 |
| `.octon/framework/orchestration/runtime/workflows/manifest.yml` | Modify | Audit workflow catalog for governance value. | Workflows classified: core, optional pack, deprecated, removed. | P1 |
| `.octon/framework/orchestration/_meta/architecture/specification.md` | Modify | Encode mission/run/objective boundaries for frontier-native execution. | Run-first lifecycle remains atomic; missions remain continuity. | P1 |
| `.octon/framework/lab/**` | Modify/add | Add benchmark, recovery, browser/API, context-pack, intervention scenarios. | Lab evidence generated under state/evidence/lab. | P2 |
| `.octon/framework/assurance/**` | Modify/add | Add validators and RunCard/HarnessCard automation. | Blocking conformance workflows include target-state validators. | P2 |
| `.octon/framework/observability/**` | Modify/add | Add run/replay/intervention/rollback/benchmark metrics. | Observability outputs feed retained evidence and cards. | P2 |
| `.octon/generated/effective/capabilities/**` | Modify generated projection | May include normalized capability routes after authority changes. | Generated only, freshness-checked, not authority. | P2 |
| `.octon/generated/proposals/registry.yml` | Regenerate | New proposal must appear as active discovery projection. | Registry generated from manifests; non-authoritative. | P0 |


## architecture/implementation-plan.md

# Implementation Plan

## Stabilization principle

Land the target state by stabilizing authority truth first, then runtime gates, then context/recovery, then browser/API and assurance automation. Do not add new live capability claims before proof surfaces exist.

## Phase 0 — Authority truth alignment and fail-closed cleanup

**Goal:** remove contradictions that undermine support, overlay, and proposal correctness.

1. Reconcile support-target vocabulary across:
   - `.octon/instance/governance/support-targets.yml`
   - `.octon/framework/constitution/support-targets.schema.json`
   - `.octon/framework/constitution/CHARTER.md`
   - `.octon/framework/constitution/charter.yml`
2. Make tuple admissions the operational support truth.
3. Align `.octon/README.md`, `framework/overlay-points/registry.yml`, and `instance/manifest.yml`.
4. Reconcile cognition runtime index with actual implemented runtime surfaces.
5. Quarantine or stage-only the experimental external model adapter.
6. Regenerate proposal registry and validate this packet.
7. Add drift validators for support vocabulary, overlay points, cognition runtime, and active adapter discovery.

**Proof prerequisites:** schema validation, overlay validation, proposal validation, support-target validation.

**Exit criteria:** no known authority drift remains in support/overlay/cognition/experimental-adapter surfaces.

## Phase 1 — Minimum frontier-native run core

**Goal:** make consequential runs context-, risk-, rollback-, and evidence-aware.

1. Add `risk-materiality-v1.schema.json` and instance policy.
2. Add `context-pack-v1.schema.json` and run evidence receipt path.
3. Extend execution request/grant/receipt with context-pack, materiality, pack, rollback, budget, and evidence refs.
4. Add `rollback-plan-v1.schema.json` and require rollback/compensation posture before material actions when materiality requires it.
5. Expand execution budgets from workflow-stage/provider rules to run/mission/model/tool/browser/API budgets.
6. Expand network egress policy into connector leases or keep API pack stage-only.
7. Ensure every material path calls `authorize_execution` and emits receipt requirements.

**Dependencies:** Phase 0 support/overlay cleanup; schema versioning decision for execution request/grant/receipt compatibility.

**Exit criteria:** a repo-consequential reference run produces context pack, risk/materiality classification, grant, receipt, rollback posture, replay pointers, and evidence classification.

## Phase 2 — Simplification and deletion pass

**Goal:** remove or demote older-model scaffolding while preserving governance.

1. Audit workflow manifest entries and classify each as:
   - core governance workflow;
   - optional practice/workflow pack;
   - deprecated compatibility workflow;
   - delete.
2. Update agency docs and registries to make one orchestrator, bounded specialists, and optional verifier the future actor model.
3. Update capability README/practices to teach two conceptual classes while retaining detailed contracts.
4. Move token/progressive-disclosure rationale into context-pack budget policy and degraded-model profile guidance.
5. Add validators forbidding generated cognition as authority and blocking proposal-path dependencies in durable targets.

**Dependencies:** Phase 1 context-pack and risk/materiality contracts.

**Exit criteria:** deleted/demoted workflows have safe replacements, and retained workflows each cite an authority/evidence/recovery/publication purpose.

## Phase 3 — Browser/API/multimodal runtime admission

**Goal:** make boundary-sensitive external action support real or keep it stage-only.

1. Implement or explicitly stage-only `browser-session` runtime service.
2. Implement or explicitly stage-only `api-client` runtime service.
3. Add browser/UI execution record schema and retained evidence emission.
4. Add API egress record schema, connector lease registry, redaction policy, idempotency classification, and compensation obligations.
5. Add negative tests and lab scenarios for browser/API packs.
6. Add support dossiers for every admitted browser/API tuple.
7. Update `services/manifest.runtime.yml` only after executable services and evidence pass.

**Dependencies:** Phase 0 support truth; Phase 1 materiality/context/rollback; Phase 2 capability simplification.

**Exit criteria:** browser/API claims either remain explicitly stage-only or have runtime service entries, conformance tests, replay evidence, support dossiers, and HarnessCard coverage.

## Phase 4 — Recovery, rollback, and intervention quality

**Goal:** validate long-running, high-consequence operation.

1. Exercise mission control leases.
2. Exercise control directives: pause, narrow, revoke, safing mode, resume.
3. Exercise circuit breaker trip/reset with retained evidence.
4. Run rollback and compensation drills for repo mutation, browser pre-submit, API partial failure, stale context, and support denial.
5. Add intervention latency, safe-boundary, and recovery-quality metrics.
6. Add retained evidence for recovery drills under `state/evidence/lab/**` and run evidence roots.

**Dependencies:** Phases 1 and 3.

**Exit criteria:** recovery and intervention suite passes and produces retained evidence.

## Phase 5 — Assurance and benchmark automation

**Goal:** prove Octon's governance value against frontier baselines.

1. Add benchmark-suite contract.
2. Define raw frontier-model, thin-wrapper, Octon-governed, Octon+verifier, and degraded/local model baselines.
3. Add governance-compliance graders.
4. Add evidence-completeness graders.
5. Add replayability and rollback scoring.
6. Generate RunCards and HarnessCards from retained evidence.
7. Gate support claims and releases on benchmark/assurance status.

**Dependencies:** Phases 1–4.

**Exit criteria:** target-state certification bundle exists for at least one admitted repo-consequential tuple and one boundary-sensitive staged scenario.

## Phase 6 — Portability hardening

**Goal:** express support honestly across frontier-native and degraded tiers.

1. Define frontier-native support tier.
2. Define degraded/local tier and stricter review requirements.
3. Require tuple-level support evidence before support publication.
4. Narrow adapter declarations to proven scope.
5. Add contamination/reset receipts for long-running model contexts.
6. Add support-target CI enforcement and generated projection freshness.

**Dependencies:** support-target schema fixed; benchmark suite active.

**Exit criteria:** support matrix is a truthful proof-backed finite admitted universe with generated discovery only.


## architecture/migration-cutover-plan.md

# Migration and Cutover Plan

## Cutover posture

The transition must be additive, fail-closed, and evidence-preserving. No proposal-local artifact becomes runtime authority. Durable changes must land under declared promotion targets and stand alone after this packet is archived.

## Migration principles

1. **Authority before execution:** fix support/overlay/cognition drift before widening runtime behavior.
2. **Stage before live:** browser/API/multimodal support remains stage-only until executable services and support dossiers exist.
3. **Evidence before claim:** no support target, adapter, or capability pack is live without retained proof.
4. **Run-first continuity:** missions remain continuity containers; runs remain atomic consequential execution units.
5. **Generated remains derived:** generated cognition and generated effective projections can assist runtime only when freshness and publication receipts are current; they never mint authority.
6. **Rollback before side effect:** material actions require rollback/compensation posture where materiality demands it.

## Cutover waves

### Wave A — Proposal staging

- Materialize this packet under the active architecture proposal path.
- Regenerate `/.octon/generated/proposals/registry.yml` from manifests.
- Validate proposal structure against proposal and architecture proposal standards.
- Do not wire proposal files into runtime/policy.

### Wave B — Authority drift correction

- Patch support-target vocabulary mismatch.
- Patch overlay registry/README/instance manifest mismatch.
- Patch cognition runtime index drift.
- Quarantine experimental external adapter or make stage-only enforcement explicit.
- Produce migration receipts and decision records.

### Wave C — Contract addition

- Add context-pack, risk/materiality, rollback-plan, browser/UI, API-egress, benchmark, RunCard, and HarnessCard contracts.
- Update contract registry if required.
- Add validation tests for schema shape and cross-reference integrity.

### Wave D — Runtime integration

- Extend execution request/grant/receipt and authorization logic.
- Add context assembler and context-pack evidence emission.
- Add runtime checks for rollback and egress prerequisites.
- Bind new receipts to existing run evidence roots.

### Wave E — Simplification and deletion

- Run workflow audit.
- Demote/delete thinking-only workflows.
- Simplify actor and capability documentation.
- Retire compatibility shims with expiration criteria.
- Confirm no durable target references proposal paths.

### Wave F — Browser/API admission

- Keep packs stage-only unless runtime services and support dossiers exist.
- Add browser/API service contracts and implementations.
- Add event/replay/evidence records.
- Add support-target tuple admission only after proof.

### Wave G — Assurance closeout

- Run structural, governance, runtime, support, recovery, evidence, and benchmark validators.
- Generate RunCards/HarnessCards from evidence.
- Record ADR/decision closeout.
- Archive packet only after durable targets stand alone.

## Evidence continuity

Retain migration evidence under `state/evidence/validation/**` and run/lab evidence roots. The migration must not delete historical evidence. Deletions/demotions should produce receipts identifying:

- removed path or demoted surface;
- replacement path or reason no replacement is required;
- affected support claims;
- validator status;
- rollback plan for migration itself.

## Runtime continuity

Compatibility wrappers may remain temporarily only if they route to canonical run-first lifecycle and emit canonical receipts. Any wrapper that creates a second execution path must be removed or made fail-closed.

## Rollback posture for the migration

Each wave should be reversible or compensable:

- Wave A rollback: remove proposal packet and regenerate proposal registry.
- Wave B rollback: restore prior support/overlay/cognition files while preserving drift evidence.
- Wave C rollback: remove unreferenced new schemas before runtime integration.
- Wave D rollback: disable new runtime checks behind hard-enforce-compatible flags while retaining receipts.
- Wave E rollback: restore optional workflows from archive/practice pack if deletion breaks operators.
- Wave F rollback: demote browser/API tuples to stage-only and remove runtime manifest entries.
- Wave G rollback: retain failed assurance evidence and block certification.


## architecture/promotion-targets.md

# Promotion Targets

## Promotion model

This packet is exploratory and non-canonical. Accepted content must be promoted into durable `.octon/**` surfaces. Promotion targets are grouped by enduring architecture layer.

## Authority and topology

| Target | Promotion intent |
|---|---|
| `.octon/framework/constitution/CHARTER.md` | Clarify frontier-governance purpose and support-truth language. |
| `.octon/framework/constitution/charter.yml` | Align machine-readable support universe wording. |
| `.octon/framework/constitution/support-targets.schema.json` | Reconcile support-claim enum and tuple-admission rules. |
| `.octon/framework/cognition/_meta/architecture/specification.md` | Add context-pack placement and generated cognition guardrails. |
| `.octon/README.md` | Align overlay/support/generated/proposal descriptions with canonical surfaces. |
| `.octon/octon.yml` | Add runtime input hooks if needed for context packs, benchmark evidence, browser/API evidence. |

## New contracts

| Target | Promotion intent |
|---|---|
| `.octon/framework/constitution/contracts/authority/risk-materiality-v1.schema.json` | First-class risk/materiality classification. |
| `.octon/framework/constitution/contracts/runtime/context-pack-v1.schema.json` | Deterministic context-pack contract. |
| `.octon/framework/constitution/contracts/runtime/rollback-plan-v1.schema.json` | Pre-action rollback/compensation posture. |
| `.octon/framework/constitution/contracts/runtime/browser-ui-execution-record-v1.schema.json` | Browser/UI action evidence contract. |
| `.octon/framework/constitution/contracts/runtime/api-egress-record-v1.schema.json` | API egress and connector evidence contract. |
| `.octon/framework/constitution/contracts/assurance/benchmark-suite-v1.schema.json` | Frontier baseline benchmark contract. |
| `.octon/framework/constitution/contracts/assurance/run-card-v2.schema.json` | Evidence-generated run card contract. |
| `.octon/framework/constitution/contracts/assurance/harness-card-v1.schema.json` | Evidence-generated support/harness card contract. |

## Instance governance

| Target | Promotion intent |
|---|---|
| `.octon/instance/governance/support-targets.yml` | Schema-valid support truth and tuple-based operational semantics. |
| `.octon/instance/governance/policies/network-egress.yml` | Connector leases, egress allowlists, redaction, idempotency, compensation. |
| `.octon/instance/governance/policies/execution-budgets.yml` | Run/mission/model/tool/browser/API budget rules. |
| `.octon/instance/governance/policies/risk-materiality.yml` | Repo-specific materiality thresholds. |
| `.octon/instance/governance/support-dossiers/**` | Dossier-backed support claims. |

## Runtime and capability

| Target | Promotion intent |
|---|---|
| `.octon/framework/engine/runtime/spec/execution-authorization-v1.md` | Add context/materiality/rollback/browser/API obligations. |
| `.octon/framework/engine/runtime/spec/execution-request-v2.schema.json` | Add refs for context pack, risk/materiality, rollback, egress, packs. |
| `.octon/framework/engine/runtime/spec/execution-grant-v1.schema.json` | Add obligations and proof refs. |
| `.octon/framework/engine/runtime/spec/execution-receipt-v2.schema.json` | Add context/replay/rollback/browser/API evidence refs. |
| `.octon/framework/capabilities/runtime/services/manifest.runtime.yml` | Admit runtime services only when executable and proof-backed. |
| `.octon/framework/capabilities/runtime/services/browser-session/contract.yml` | Browser service contract. |
| `.octon/framework/capabilities/runtime/services/api-client/contract.yml` | API service contract. |
| `.octon/framework/capabilities/packs/browser/manifest.yml` | Stage/live posture aligned to runtime proof. |
| `.octon/framework/capabilities/packs/api/manifest.yml` | Stage/live posture aligned to runtime proof. |

## Agency and orchestration

| Target | Promotion intent |
|---|---|
| `.octon/framework/agency/_meta/architecture/specification.md` | Make accountable-orchestrator model explicit. |
| `.octon/framework/agency/runtime/agents/registry.yml` | Clarify verifier/specialist activation. |
| `.octon/framework/orchestration/runtime/workflows/manifest.yml` | Classify workflows and delete/demote thinking-only entries. |
| `.octon/framework/orchestration/_meta/architecture/specification.md` | Clarify mission/run/objective and workflow governance role. |

## Assurance/lab/observability

| Target | Promotion intent |
|---|---|
| `.octon/framework/assurance/**` | Validators and RunCard/HarnessCard automation. |
| `.octon/framework/lab/**` | Benchmark, recovery, browser/API, and adversarial scenarios. |
| `.octon/framework/observability/**` | Metrics for replay, rollback, intervention, evidence, and benchmark quality. |
| `.octon/state/evidence/**` | Retained proof from implementation and validation. |

## Generated projections

Generated projections may be updated only after authoritative changes land. They remain non-authoritative:

- `.octon/generated/effective/capabilities/**`
- `.octon/generated/effective/governance/support-target-matrix.yml`
- `.octon/generated/cognition/**`
- `.octon/generated/proposals/registry.yml`


## architecture/support-target-and-adapter-strategy.md

# Support-Target and Adapter Strategy

## Strategy statement

Octon should optimize first for a **frontier-native governed tier**, then define explicit degraded/local profiles. It should not claim broad portability until tuple-level support dossiers prove the claim.

## Current issue

The current support-target file declares `support_claim_mode: bounded-admitted-live-universe`, while the schema allows `bounded-admitted-finite` and `global-complete-finite`. The charter language also uses globally complete finite terminology. This is a P0 authority drift issue because support claims are governance facts.

## Operational support truth

The operational support truth should be finite admitted tuples:

```text
(model tier, workload tier, language/resource tier, locale tier, host adapter, model adapter, capability pack set)
```

Broad model/workload/context/locale/adapter lists are planning taxonomy only. They do not imply support without tuple admission and support dossier.

## Frontier-native tier

Frontier-native support should assume:

- large context windows;
- native tool/computer use;
- multimodal perception/action where admitted;
- stronger planning and instruction following;
- longer-horizon execution;
- deterministic context packs rather than token-era retrieval scaffolding;
- strict authority, evidence, rollback, and intervention requirements.

Default route: escalate for boundary-sensitive and repo-consequential actions until proof-backed support exists.

## Degraded/local tier

Degraded/local support should assume:

- smaller context windows;
- stricter context pack budgets;
- smaller run slices;
- more human review;
- more verifier usage;
- narrower capability packs;
- reduced support claims;
- stronger generated summary freshness checks.

Default route: allow read-only reference-owned work if tuple-admitted; escalate or deny material work unless proof exists.

## Adapter strategy

Host/model adapters remain valuable as **projection and evidence boundaries**, not as generic vendor-routing abstractions.

Each adapter declaration should include:

- support status;
- authority mode;
- replaceability;
- supported tuple subset;
- conformance suite;
- known limitations;
- contamination/reset posture for model adapters;
- disclosure obligations;
- evidence requirements;
- failure/denial behavior.

## Experimental adapters

Experimental adapters may exist only in a quarantined/stage-only surface. They must not appear as live support and must not be routable by default. The `experimental-external` adapter should be moved out of active discovery or explicitly validated as stage-only.

## Browser/API support posture

Browser/API packs should remain **designed but not live by default** until:

- runtime service is active in `services/manifest.runtime.yml`;
- contract and implementation exist;
- negative tests pass;
- replay/event ledger evidence is retained;
- egress/connector leases exist for API;
- support tuple and support dossier exist;
- RunCard/HarnessCard generation covers the pack.

## Support certification artifacts

Each admitted tuple should have:

- admission record;
- support dossier;
- adapter conformance evidence;
- capability-pack evidence;
- lab scenario evidence;
- benchmark evidence;
- disclosure evidence;
- HarnessCard.

## Acceptance gate

A support claim is valid only if all of the following are true:

1. schema-valid support target;
2. tuple admission exists;
3. support dossier exists;
4. runtime services exist for referenced packs;
5. evidence roots contain proof;
6. generated support matrix is fresh and non-authoritative;
7. no retired/experimental tier participates in a live claim.


## architecture/target-architecture.md

# Target Architecture

## Executive target-state determination

Adopt Octon's frontier-governance target state:

> A minimum sufficient governance harness for frontier-model engineering: one accountable orchestrator, deterministic context packs, engine-owned authorization, deny-by-default capability gates, retained evidence, replay, rollback, intervention, support-proof dossiers, and automated assurance.

The target state preserves Octon's constitutional core and strips or demotes scaffolding whose primary purpose was compensating for weaker models. It does not weaken governance because frontier models are stronger. It strengthens governance because stronger models can take more consequential actions over longer horizons.

## What Octon fundamentally is

Octon is a **control plane and evidence harness for consequential autonomous engineering work**. It binds frontier-model execution to durable authority, explicit control truth, retained evidence, replay, rollback, support-target honesty, intervention, and assurance.

Octon should answer these questions for every consequential run:

1. What authority allowed or denied this work?
2. What model/host/capability/support tuple was admitted?
3. What context was assembled, from what source, with what freshness and authority labels?
4. What did the accountable orchestrator intend to do?
5. What material actions were requested, granted, denied, or escalated?
6. What side effects occurred?
7. What evidence, replay pointers, traces, receipts, and disclosure artifacts prove what happened?
8. How can the run be paused, narrowed, rolled back, compensated, replayed, or certified?

## What Octon is not

Octon should not be:

- a generic multi-agent or swarm framework;
- a RAG/memory product;
- a prompt-management platform;
- a generic LLM gateway;
- a workflow engine whose primary purpose is to simulate model reasoning;
- a replacement for frontier-model native planning and tool use;
- a host UI/chat/documentation projection treated as authority;
- a generated cognition layer that becomes memory, policy, approval, or support truth.

## Enduring layers to preserve

| Layer | Durable target role | Preserve because |
|---|---|---|
| Constitution and authority | Charter, fail-closed rules, precedence, evidence obligations, support truth | Frontier autonomy requires stronger, not weaker, authority boundaries. |
| Super-root class split | `framework`, `instance`, `inputs`, `state`, `generated` | It prevents authority/control/evidence/derived-view confusion. |
| Engine-owned authorization | `authorize_execution(request) -> GrantBundle` | Material actions need a single hard gate before side effects. |
| Run-first execution | Run roots and evidence roots | Runs are the atomic consequential execution unit. |
| State/control/evidence separation | mutable control truth and retained proof | Required for replay, rollback, intervention, and audit. |
| Capability packs and service contracts | bounded tool/service invocation | Frontier tool use increases the importance of permissioning. |
| Support-target matrix | bounded support claims | Prevents unsupported portability claims. |
| Assurance/lab/observability | proof and behavioral validation | Evals and observability become governance evidence. |

## Layers to simplify

| Layer | Simplification |
|---|---|
| Actor model | Use one accountable orchestrator by default, optional bounded specialists, optional independent verifier. Treat teams as composition profiles, not runtime actors. |
| Capability taxonomy | Teach as two classes: instruction-level operator contracts and invocation-level runtime contracts. Keep detailed dirs only where they add enforcement or discovery value. |
| Workflow catalog | Keep workflows that encode authority/evidence/recovery/publication. Demote/delete workflows that only choreograph reasoning. |
| Support matrix | Make admitted tuples the operational truth. Treat broad classes as taxonomy only. |
| Token-era prompt routing | Replace token scarcity as design driver with context-pack budgets and degraded-profile policies. |
| Cognition runtime | Either implement claimed runtime surfaces or collapse to actual derived read-model/context surfaces. |

## Layers to delete or demote

- Active discovery of experimental adapters not admitted by support targets.
- Live support claims that are not schema-valid and proof-backed.
- Generated cognition as authority, memory, approval, or runtime policy.
- Workflow units that only encode model thinking patterns.
- Compatibility shims that persist after canonical run-first migration.
- Token-only routing metadata as durable control logic.

## Layers to strengthen

- Support-target schema/charter/live-file alignment.
- Runtime implementation behind execution grants, receipts, control leases, directives, and circuit breakers.
- Network egress and connector lease governance.
- Execution budgets for run/mission/tool/browser/API/model dimensions.
- Runtime service manifest discipline for browser/API/multimodal support.
- Context-pack assembly and evidence receipts.
- Automated RunCard/HarnessCard proof generation.
- Drift detection across overlay, support, cognition, service, capability, and generated surfaces.

## New first-class layers to add

| New layer | Proposed durable placement | Purpose |
|---|---|---|
| Risk/materiality classifier | `framework/constitution/contracts/authority/risk-materiality-v1.schema.json`; `instance/governance/policies/risk-materiality.yml` | Classify action materiality, required posture, approval, evidence, rollback, and support requirements. |
| Context-pack contract | `framework/constitution/contracts/runtime/context-pack-v1.schema.json`; retained receipts under `state/evidence/runs/<run-id>/` | Deterministic context assembly with provenance, hashes, authority labels, freshness, omissions, and generated-vs-authoritative separation. |
| Rollback-plan contract | `framework/constitution/contracts/runtime/rollback-plan-v1.schema.json` | Require rollback/compensation posture before material action. |
| Browser/UI execution record | `framework/constitution/contracts/runtime/browser-ui-execution-record-v1.schema.json` | Capture governed browser/UI actions, visual/DOM state, event ledger, replay pointers, and human-intervention markers. |
| API egress record | `framework/constitution/contracts/runtime/api-egress-record-v1.schema.json` | Capture connector leases, idempotency, request/response trace pointers, redaction, compensation, and external-effect disclosure. |
| Benchmark suite contract | `framework/constitution/contracts/assurance/benchmark-suite-v1.schema.json` | Compare Octon-governed runs against raw frontier-model and thin-wrapper baselines. |
| RunCard / HarnessCard contracts | `framework/constitution/contracts/assurance/{run-card-v2,harness-card-v1}.schema.json` | Make run and support certification evidence-generated rather than manually asserted. |

## Target execution model

1. A human or model proposes an objective.
2. Octon resolves mission continuity and run boundary.
3. A deterministic context pack is assembled from authoritative sources and derived read models.
4. The accountable orchestrator drafts or receives a run contract.
5. The risk/materiality classifier assigns required posture.
6. `authorize_execution` grants, denies, stages, or escalates.
7. The capability gateway invokes only granted tools/services/packs.
8. The runtime emits receipts, traces, checkpoints, replay pointers, and rollback evidence.
9. Leases, directives, circuit breakers, and human intervention may pause, narrow, revoke, or safing-mode the run.
10. Closeout emits RunCard, disclosure, evidence classification, and any support/benchmark evidence.
11. Assurance/lab can replay, grade, benchmark, or deny certification.

## Target actor model

```text
Human / policy authority
        |
        v
Accountable orchestrator
        |
        +-- optional bounded specialist(s)
        |
        +-- optional independent verifier
        |
        v
Engine-owned authorization and capability gateway
```

Rules:

- Exactly one accountable orchestrator per consequential run.
- Specialists are bounded and least-privilege.
- Verifier is used only for separation-of-duties, high materiality, or proof needs.
- Teams are composition/configuration artifacts, not runtime actors.
- No implicit privilege escalation through delegation.
- No hidden second control plane in chat, host UI, comments, labels, or provider memory.

## Target context-pack model

Context packs replace ad hoc prompt stuffing and old token-scarcity routing as the default frontier-native context mechanism.

Each context pack must record:

- authoritative source paths and hashes;
- generated/read-model source paths and hashes;
- raw inputs included only as non-authoritative source material;
- freshness checks and generation locks;
- omitted sources and reasons;
- token/byte budgets and model context limit;
- retrieval/search steps, if any;
- source authority labels;
- statement that generated cognition was used only as derived read model;
- retained evidence receipt under the run evidence root.

Retrieval remains justified for dynamic, external, legally scoped, too-large, or exact-provenance corpora. It is not justified as accidental memory or authority.

## Target runtime-native substrate

Minimum durable runtime-native substrate:

1. Run manager.
2. Policy/authority engine.
3. Capability gateway.
4. Context assembler.
5. State/evidence store.
6. Telemetry/replay store.
7. Intervention/lease/circuit-breaker controller.
8. Rollback/recovery service.
9. Host/model adapters.
10. Browser/UI service.
11. API connector/egress service.
12. Assurance/benchmark runner.

Browser/API/multimodal support must remain stage-only until active runtime services, support dossiers, replay, evidence, negative tests, and support-target admission exist.

## Target proof and assurance model

Assurance must prove governance behavior, not just output quality.

Required assurance families:

- Structural validation.
- Governance validation.
- Runtime validation.
- Support-target validation.
- Behavior validation.
- Recovery validation.
- Evidence validation.
- Comparative benchmark validation.
- Closure certification.

The central benchmark is not whether Octon makes the model smarter. The central benchmark is whether Octon makes the same frontier model more authorized, bounded, replayable, reversible, evidenced, and safe at acceptable overhead.


## architecture/validation-plan.md

# Validation Plan

## Structural validation

Required checks:

- Proposal package path matches `/.octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state/`.
- `proposal.yml` has valid proposal id, kind, status, lifecycle, scope, and all promotion targets are under `.octon/`.
- Exactly one subtype manifest exists: `architecture-proposal.yml`.
- `navigation/source-of-truth-map.md` and `navigation/artifact-catalog.md` exist.
- `PACKET_MANIFEST.md` and `SHA256SUMS.txt` match on-disk contents.
- All new schemas parse and are registered where required.
- Overlay registry, instance manifest, and README overlay description agree.
- Support-target file is valid against support-target schema.
- Cognition runtime index matches actual implemented runtime surfaces.

## Governance validation

Required checks:

- No durable target reads proposal paths as authority.
- No raw `inputs/**` path is a runtime or policy dependency.
- No `generated/**` path is treated as authority, approval, policy, or support truth.
- All material action classes route through `authorize_execution`.
- Risk/materiality classification is present for material actions.
- Support-target tuple admission exists before live support claim.
- Capability packs agree with support targets and exclusions.
- Browser/API actions fail closed unless authority route, runtime service, replay evidence, and support dossier are present.

## Runtime validation

Required checks:

- Run control root exists before side effects.
- Run evidence root exists before side effects.
- Execution requests bind context pack, materiality, requested capabilities, side effects, and rollback posture where required.
- Grants contain decision, reason codes, scope constraints, granted capabilities, policy mode, receipt requirements, and evidence obligations.
- Receipts exist for every material attempt, including denials and escalations.
- Replay pointers and trace pointers are retained.
- Rollback/compensation handles are present when required.
- Control directives, leases, and circuit breakers are exercised and evidenced.

## Support-target validation

Required checks:

- Support mode vocabulary is schema-valid.
- Broad support classes do not imply support without tuple admission.
- Every live tuple has admission ref and support dossier ref.
- Every support dossier has required evidence, conformance criteria, and disclosure coverage.
- Adapters do not claim unsupported tiers.
- Experimental adapters remain quarantined/stage-only.
- Generated support matrix is freshness-checked and non-authoritative.

## Behavior validation

Required scenario suites:

1. Observe-and-read reference-owned English repo-shell run.
2. Repo-consequential English repo-shell mutation with rollback posture.
3. Support denial for unsupported tuple.
4. Stale generated cognition rejected as authority.
5. Context pack with generated summaries used only as derived input.
6. Workflow categorized as thinking-only and demoted without breaking governance path.
7. Optional verifier activated only for materiality/separation-of-duties trigger.

## Recovery validation

Required drills:

- Mid-run tool failure.
- Repo mutation rollback.
- API partial failure compensation.
- Browser pre-submit pause/intervention.
- Human directive pause/narrow/revoke/safing.
- Circuit breaker trip/reset.
- Mission pause/resume with continuity handoff.
- Stale context-pack rejection and rebuild.

## Evidence validation

Required checks:

- Evidence classification is complete.
- RunCard generated from receipts/traces/replay/checkpoints/context-pack/rollback evidence.
- HarnessCard generated from support dossier/lab/benchmark evidence.
- Disclosure artifacts include capability pack set and support tuple.
- Evidence roots are retained under `state/evidence/**`, not `generated/**`.
- Validation receipts are retained under `state/evidence/validation/**`.

## Comparative benchmark validation

Compare the same tasks across:

1. Raw frontier model with same allowed repo context.
2. Raw frontier model plus thin tool wrapper.
3. Octon-governed execution with one orchestrator.
4. Octon-governed execution with optional verifier.
5. Degraded/local model profile.

Metrics:

- Task success.
- Unauthorized action prevention.
- False block/false escalation rate.
- Evidence completeness.
- Replayability.
- Rollback/compensation success.
- Intervention latency and safe-boundary quality.
- Cost, wall-clock time, and token/tool budget usage.
- Support-claim correctness.
- Disclosure quality.

## Closure certification

Certification requires:

- all P0/P1 validators pass;
- accepted support claims are dossier-backed;
- reference runs produce complete RunCards;
- support tuple HarnessCard exists for at least the retained reference tuple;
- browser/API claims are either stage-only or fully proof-backed;
- no durable promoted file references this proposal path as authority.


## navigation/artifact-catalog.md

# Artifact Catalog

## Root

- `README.md` — packet purpose, posture, and reading order.
- `proposal.yml` — shared proposal lifecycle manifest.
- `architecture-proposal.yml` — architecture subtype manifest.
- `PACKET_MANIFEST.md` — enumerated archive manifest.
- `SHA256SUMS.txt` — checksums for packet integrity.
- `FULL_PACKET_CONTENTS.md` — concatenated full contents of packet artifacts except checksum/self-recursive files.

## Navigation

- `navigation/source-of-truth-map.md` — authority, derived, proposal-local, and evidence boundary map.
- `navigation/artifact-catalog.md` — proposal artifact index.

## Architecture

- `architecture/target-architecture.md` — target state for frontier-model governance harness architecture.
- `architecture/current-state-gap-map.md` — current repo strengths, drift, missing executable surfaces, and gaps.
- `architecture/concept-coverage-matrix.md` — mandatory scope coverage and review finding dispositions.
- `architecture/file-change-map.md` — concrete file/surface change program.
- `architecture/deletion-collapse-retention-matrix.md` — delete/collapse/simplify/retain/strengthen/add matrix.
- `architecture/implementation-plan.md` — phased implementation program.
- `architecture/migration-cutover-plan.md` — safe transition and cutover approach.
- `architecture/validation-plan.md` — structural, governance, runtime, support, behavior, recovery, evidence, benchmark, and closure validation.
- `architecture/acceptance-criteria.md` — crisp closure-ready criteria.
- `architecture/cutover-checklist.md` — operational promotion checklist.
- `architecture/execution-constitution-conformance-card.md` — conformance card against constitutional/runtime obligations.
- `architecture/support-target-and-adapter-strategy.md` — future support, portability, host/model adapter strategy.
- `architecture/actor-runtime-cognition-assurance-model.md` — future actor, runtime, cognition, and assurance model.
- `architecture/closure-certification-plan.md` — closure evidence, certification sequence, and archive-readiness plan.
- `architecture/promotion-targets.md` — durable target surfaces and proposed promotion placement.

## Resources

- `resources/frontier-governance-architecture-review.md` — full upstream review included as a source artifact.
- `resources/repository-baseline-audit.md` — live repository baseline and evidence map.
- `resources/coverage-traceability-matrix.md` — source review to packet motions traceability.
- `resources/evidence-plan.md` — evidence artifacts needed for implementation and closeout.
- `resources/decision-record-plan.md` — ADR/decision record plan for promotion.
- `resources/risk-register.md` — risk, tradeoff, and mitigation register.
- `resources/assumptions-and-blockers.md` — assumptions, limits, blockers, and open prerequisites.
- `resources/rejection-ledger.md` — rejected, deferred, and demoted ideas with reasons.


## navigation/source-of-truth-map.md

# Source of Truth Map

## Canonical authority hierarchy used by this packet

| Layer | Role | Current source(s) | Why it matters here |
|---|---|---|---|
| Constitutional kernel | Supreme repo-local governance regime | `/.octon/framework/constitution/**` | Prevents frontier-era simplification from weakening authority, fail-closed, evidence, disclosure, support-target, and runtime obligations. |
| Super-root topology | Class-root separation and proposal workspace rules | `/.octon/README.md`, `/.octon/octon.yml` | Establishes `framework` and `instance` as authored authority, `state` as control/evidence, `generated` as rebuildable, and `inputs` as non-authoritative. |
| Cross-subsystem placement | Structural SSOT and root invariants | `/.octon/framework/cognition/_meta/architecture/specification.md` | Determines where new context-pack, risk/materiality, runtime, assurance, and generated surfaces legally belong. |
| Proposal system | Temporary proposal contract | `/.octon/inputs/exploratory/proposals/README.md`, `/.octon/framework/scaffolding/governance/patterns/proposal-standard.md`, `architecture-proposal-standard.md` | Confirms this packet is proposal-local and not canonical after promotion. |
| Execution authorization | Engine-owned material-action boundary | `/.octon/framework/engine/runtime/spec/execution-authorization-v1.md`, execution request/grant/receipt schemas | Requires material actions to pass through `authorize_execution` and emit grants/receipts before side effects. |
| Run lifecycle | Atomic consequential execution unit | `/.octon/framework/engine/runtime/README.md`, `/.octon/octon.yml#runtime_inputs` | Keeps missions as continuity containers and runs as the executable, evidenced unit. |
| State/control/evidence | Mutable operational truth and retained proof | `/.octon/state/control/**`, `/.octon/state/evidence/**`, `/.octon/state/continuity/**` | Determines where approvals, leases, revocations, receipts, traces, replay pointers, rollback, and mission continuity must land. |
| Capability governance | Bounded tool/service surfaces | `/.octon/framework/capabilities/**`, packs, services, deny-by-default policy | Distinguishes tool-use enablement from bounded permissioning and capability admission. |
| Support claims | Bounded support universe | `/.octon/instance/governance/support-targets.yml`, `/.octon/framework/constitution/support-targets.schema.json` | Support must be tuple-admitted, proof-backed, and schema-valid. Current drift is a priority fix. |
| Agency | Actor taxonomy and delegation boundaries | `/.octon/framework/agency/_meta/architecture/specification.md`, `runtime/agents/registry.yml` | Establishes one accountable orchestrator, optional verifier, assistants, and teams as composition artifacts. |
| Orchestration | Workflow/run/mission contracts | `/.octon/framework/orchestration/**`, workflow manifest, mission surfaces | Separates governance/evidence workflows from token-era reasoning choreography. |
| Cognition/generated | Derived read models only | `/.octon/generated/cognition/**`, cognition umbrella spec | Ensures summaries, projections, and graph datasets never become memory, policy, or authority. |
| Assurance/lab/observability | Proof production and behavioral testing | `/.octon/framework/assurance/**`, `/.octon/framework/lab/**`, `/.octon/framework/observability/**` | Must evolve from taxonomy to automated support, run, replay, rollback, and benchmark proof. |

## Proposal-local authorities

| Packet file | Authority inside this packet | Boundary |
|---|---|---|
| `proposal.yml` | Lifecycle, scope, promotion target, non-goal, closure authority for this proposal | Not runtime/policy authority. |
| `architecture-proposal.yml` | Architecture subtype decision manifest | Not durable architecture until promoted. |
| `navigation/source-of-truth-map.md` | Manual precedence and boundary map for packet interpretation | Cannot override repo authority. |
| `architecture/target-architecture.md` | Proposed end-state design | Must be promoted into durable surfaces before becoming active. |
| `architecture/acceptance-criteria.md` | Proposal closeout criteria | Must be converted into validators/evidence in durable targets. |

## Derived projections and generated surfaces

Generated outputs remain rebuildable and non-authoritative. The packet may propose generated read-model refinements, but durable authority must live in `framework/**`, `instance/**`, or retained `state/**` control/evidence as appropriate. `/.octon/generated/proposals/registry.yml` remains discovery-only and cannot outrank `proposal.yml`.

## Retained evidence surfaces

Retained proof for implementation must land under `/.octon/state/evidence/**`, including run evidence, validation receipts, control-plane evidence, lab evidence, benchmark evidence, RunCards, HarnessCards, replay pointers, trace pointers, and disclosure artifacts.

## Explicitly excluded as authority

- This proposal packet after promotion.
- Raw `inputs/**` except as non-authoritative source material.
- `generated/**` outputs as policy, approval, runtime, or support authority.
- Host UI labels, comments, checks, browser state, or chat transcripts.
- Model memory, provider defaults, or frontier-model priors.


## proposal.yml

schema_version: "proposal-v1"
proposal_id: "octon-frontier-governance-target-state"
title: "Octon Frontier Governance Target-State Architecture"
summary: >-
  Manifest-governed architecture proposal packet that converts the repository-grounded
  frontier-governance architecture review into an implementation-driving target-state
  program for Octon as a minimum sufficient governance harness for frontier-model engineering.
proposal_kind: "architecture"
promotion_scope: "octon-internal"
promotion_targets:
  - ".octon/framework/constitution/CHARTER.md"
  - ".octon/framework/constitution/charter.yml"
  - ".octon/framework/constitution/support-targets.schema.json"
  - ".octon/framework/constitution/contracts/authority/risk-materiality-v1.schema.json"
  - ".octon/framework/constitution/contracts/runtime/context-pack-v1.schema.json"
  - ".octon/framework/constitution/contracts/runtime/rollback-plan-v1.schema.json"
  - ".octon/framework/constitution/contracts/runtime/browser-ui-execution-record-v1.schema.json"
  - ".octon/framework/constitution/contracts/runtime/api-egress-record-v1.schema.json"
  - ".octon/framework/constitution/contracts/assurance/benchmark-suite-v1.schema.json"
  - ".octon/framework/constitution/contracts/disclosure/run-card-v2.schema.json"
  - ".octon/framework/constitution/contracts/disclosure/harness-card-v2.schema.json"
  - ".octon/framework/cognition/_meta/architecture/specification.md"
  - ".octon/README.md"
  - ".octon/octon.yml"
  - ".octon/framework/overlay-points/registry.yml"
  - ".octon/instance/manifest.yml"
  - ".octon/instance/governance/support-targets.yml"
  - ".octon/instance/governance/policies/network-egress.yml"
  - ".octon/instance/governance/policies/execution-budgets.yml"
  - ".octon/instance/governance/policies/risk-materiality.yml"
  - ".octon/instance/governance/contracts/support-target-review.yml"
  - ".octon/instance/governance/support-dossiers/"
  - ".octon/framework/engine/runtime/spec/execution-authorization-v1.md"
  - ".octon/framework/engine/runtime/spec/execution-request-v2.schema.json"
  - ".octon/framework/engine/runtime/spec/execution-grant-v1.schema.json"
  - ".octon/framework/engine/runtime/spec/execution-receipt-v2.schema.json"
  - ".octon/framework/engine/runtime/spec/mission-control-lease-v1.schema.json"
  - ".octon/framework/engine/runtime/spec/control-directive-v1.schema.json"
  - ".octon/framework/engine/runtime/spec/circuit-breaker-v1.schema.json"
  - ".octon/framework/engine/runtime/adapters/host/"
  - ".octon/framework/engine/runtime/adapters/model/"
  - ".octon/framework/capabilities/README.md"
  - ".octon/framework/capabilities/runtime/services/manifest.runtime.yml"
  - ".octon/framework/capabilities/runtime/services/browser-session/contract.yml"
  - ".octon/framework/capabilities/runtime/services/api-client/contract.yml"
  - ".octon/framework/capabilities/packs/browser/manifest.yml"
  - ".octon/framework/capabilities/packs/api/manifest.yml"
  - ".octon/framework/orchestration/_meta/architecture/specification.md"
  - ".octon/framework/orchestration/runtime/workflows/manifest.yml"
  - ".octon/framework/agency/_meta/architecture/specification.md"
  - ".octon/framework/agency/runtime/agents/registry.yml"
  - ".octon/framework/lab/"
  - ".octon/framework/assurance/"
  - ".octon/framework/observability/"
  - ".octon/framework/assurance/runtime/_ops/scripts/validate-support-target-live-claims.sh"
  - ".octon/framework/assurance/scripts/validate-harness-card-claim.sh"
  - ".octon/generated/effective/capabilities/"
  - ".octon/generated/cognition/"
  - ".octon/generated/proposals/registry.yml"
status: "archived"
archive:
  archived_at: "2026-04-18"
  archived_from_status: "implemented"
  disposition: "implemented"
  original_path: ".octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state"
  promotion_evidence:
    - ".octon/instance/cognition/decisions/089-frontier-governance-target-state-revalidation.md"
    - ".octon/instance/cognition/decisions/090-support-target-vocabulary-reconciliation.md"
    - ".octon/instance/cognition/decisions/091-browser-api-live-claim-restaging.md"
    - ".octon/instance/cognition/decisions/092-frontier-governance-bounded-completion.md"
    - ".octon/instance/cognition/context/shared/migrations/2026-04-18-octon-frontier-governance-target-state/plan.md"
    - ".octon/state/evidence/migration/2026-04-18-octon-frontier-governance-target-state/evidence.md"
    - ".octon/state/evidence/disclosure/releases/2026-04-18-frontier-governance-bounded-complete/manifest.yml"
lifecycle:
  temporary: true
  exit_expectation: >-
    Promote accepted target-state changes into durable .octon authority, runtime, control,
    evidence, assurance, support-target, and generated-projection surfaces; verify that
    no durable promoted target depends on this proposal path; then archive this packet
    with retained promotion evidence or close it as rejected/superseded.
source_inputs:
  - id: "live-octon-repository"
    kind: "repository"
    uri: "https://github.com/jamesryancooper/octon"
    role: "primary source of truth"
  - id: "frontier-governance-architecture-review"
    kind: "conversation-source-artifact"
    path: "resources/frontier-governance-architecture-review.md"
    role: "required upstream analytical review included in full"
  - id: "proposal-standard"
    kind: "repo-authority"
    path: ".octon/framework/scaffolding/governance/patterns/proposal-standard.md"
    role: "base proposal packet contract"
  - id: "architecture-proposal-standard"
    kind: "repo-authority"
    path: ".octon/framework/scaffolding/governance/patterns/architecture-proposal-standard.md"
    role: "architecture subtype contract"
proposal_intent:
  target_state: >-
    A minimum sufficient governance harness for frontier-model engineering: one accountable
    orchestrator, deterministic context packs, engine-owned authorization, deny-by-default
    capability gates, retained evidence, replay, rollback, intervention, support-proof dossiers,
    and automated assurance.
  governing_distinction: >-
    Delete or demote cognition scaffolding whose reason for existence was weaker models; retain
    and strengthen governance scaffolding that proves authority, control, evidence, reversibility,
    and accountability for stronger frontier models.
non_goals:
  - "Do not make proposal-local files canonical runtime, policy, or generated authority."
  - "Do not create a generic agent framework, RAG product, prompt-management platform, or LLM gateway."
  - "Do not treat generated cognition, raw inputs, host UI, chat state, or model priors as authority."
  - "Do not claim browser, API, or multimodal live support before runtime services, replay evidence, and tuple-level support dossiers exist."
  - "Do not broaden support targets without schema-valid, proof-backed tuple admissions."
closure_conditions:
  - "All accepted durable promotion targets exist outside .octon/inputs/exploratory/proposals/**."
  - "Support-target mode, schema, charter language, and live support file are reconciled and validation-covered."
  - "Overlay registry, instance manifest, and .octon/README overlay description agree."
  - "Cognition runtime indexes only implemented authority-bearing surfaces or is corrected to derived-only generated read models."
  - "Every material execution path passes through engine-owned authorization and emits receipts."
  - "Context-pack, risk/materiality, rollback-plan, browser/UI record, API-egress record, and benchmark schemas are added or explicitly deferred with tracked decisions."
  - "RunCard/HarnessCard evidence is produced from retained evidence roots, not manual assertion."
  - "A frontier baseline benchmark suite compares raw frontier-model execution against Octon-governed execution."
  - "Durable targets contain no dependency on this proposal packet path after promotion."
related_proposals:
  - "octon-instruction-layer-execution-envelope-hardening"


## resources/assumptions-and-blockers.md

# Assumptions and Blockers

## Assumptions

- The default branch is `main`.
- Proposal packets remain non-canonical and temporary under `/.octon/inputs/exploratory/proposals/**`.
- Promotion scope for this packet is `octon-internal`; all promotion targets are under `.octon/**`.
- Existing root invariants remain binding: only `framework/**` and `instance/**` are authored authority; `state/**` is operational truth/evidence; `generated/**` is rebuildable; `inputs/**` is non-authoritative.
- The review included in `resources/frontier-governance-architecture-review.md` is the required upstream analytical source.
- Browser/API/multimodal support should not be live without runtime services, evidence, support dossiers, and validation.

## Blockers before implementation promotion

- Run Octon's local proposal validators against this packet.
- Run support-target schema validation after vocabulary reconciliation.
- Decide whether to rename `bounded-admitted-live-universe` or extend the schema to include it.
- Decide whether overlay registry or README is canonical where they currently diverge; update the other surface accordingly.
- Validate cognition runtime index against actual checked-out tree.
- Determine exact schema versioning path for execution request/grant/receipt changes.
- Confirm whether browser-session and api-client service contract files already exist in the current checkout but are not active in runtime manifest, or need to be added.
- Define acceptance thresholds for comparative frontier benchmarks.

## Known limits of this packet

- This packet does not include executable code patches.
- This packet does not run the runtime or validators.
- This packet does not prove browser/API support is live.
- This packet does not modify generated registry outputs; it expects registry regeneration after materialization.
- This packet proposes durable promotion targets that may require follow-up schema and implementation design.

## Open questions

1. Should `support_claim_mode` settle on `bounded-admitted-finite`, or should the schema add `bounded-admitted-live-universe` with exact semantics?
2. Should context-pack contracts live under `framework/constitution/contracts/runtime/**`, `framework/engine/runtime/spec/**`, or both with one referencing the other?
3. Should RunCard/HarnessCard contracts be under constitution assurance contracts, assurance runtime, or both?
4. What minimum browser/UI replay fidelity is acceptable for live support?
5. What minimum API egress trace/redaction/compensation evidence is acceptable for live support?
6. What raw frontier-model baseline tasks are representative enough to prove governance value?


## resources/coverage-traceability-matrix.md

# Coverage Traceability Matrix

## Source lineage

| Source | Packet role |
|---|---|
| Live Octon repo | Primary authority for current surfaces, proposal conventions, and placement constraints. |
| `resources/frontier-governance-architecture-review.md` | Full upstream review included verbatim and used as primary analysis basis. |
| Proposal standards | Packet structure and non-authority boundaries. |

## Finding-to-motion traceability

| Upstream review finding | Disposition | Packet motion | Promotion destination |
|---|---|---|---|
| Octon's constitutional core becomes more valuable as models strengthen. | Adopted | Preserve constitution, super-root split, run-first lifecycle, state/evidence, support, assurance. | Constitution, root docs, runtime specs. |
| Complexity without governance value is technical debt. | Adopted | Deletion/collapse matrix and workflow audit. | Orchestration manifest, agency/capability docs. |
| Support target mode/schema/charter drift is P0. | Adopted | Phase 0 authority truth alignment. | Support targets, schema, charter. |
| Overlay registry/README/instance manifest drift is P0. | Adopted | Add overlay drift validation and doc/manifest reconciliation. | Overlay registry, instance manifest, README. |
| Cognition runtime/index drift risks accidental memory/authority. | Adopted | Reconcile cognition runtime index and generated cognition guardrails. | Cognition spec/runtime index/generated docs. |
| Browser/API packs are valuable but ahead of active runtime manifest. | Adopted | Stage-only until services/evidence/support dossiers exist. | Capability packs, service manifest, browser/API contracts. |
| Network egress policy is too narrow for governed API/browser. | Adopted | Add connector leases, redaction, idempotency, compensation, trace pointers. | Network egress policy, API egress record. |
| Execution budgets are workflow-stage/provider-focused. | Adopted | Expand budgets to run/mission/model/tool/browser/API. | Execution budgets policy, grants/receipts. |
| Actor model should default to one orchestrator. | Adopted | Update agency spec/registry terminology. | Agency architecture spec, agents registry. |
| Capability terminology should be simplified but retained. | Adapted | Teach two conceptual classes while keeping existing dirs. | Capability README/practices. |
| Workflow catalog should be audited. | Adopted | Classify into core/optional/deprecated/remove. | Workflow manifest and practices. |
| Context packs should become first-class. | Adopted and expanded | Add context-pack schema and evidence receipts. | Runtime/constitution contracts, run evidence roots. |
| Risk/materiality classifier should be first-class. | Adopted and expanded | Add authority schema and instance policy. | Constitution contracts/authority, instance governance policy. |
| Rollback/recovery/intervention must strengthen. | Adopted | Add rollback-plan contract, recovery drills, intervention metrics. | Runtime contracts, lab/assurance, state evidence. |
| Assurance/lab/observability must become proof-producing. | Adopted | Add benchmark suite, RunCard/HarnessCard generation. | Assurance/lab/observability, state evidence. |
| Support adapters must be proof-backed, not broad gateways. | Adopted | Tuple-based support and adapter conformance. | Support targets, support dossiers, adapter manifests. |

## Disposition classes

| Disposition | Meaning | Count / examples |
|---|---|---|
| Adopted | Used directly in proposal. | Support drift, overlay drift, one orchestrator, generated cognition guardrail, context packs. |
| Adapted | Kept but reframed to fit repo placement. | Capability simplification, token budgets as degraded profiles, support classes as taxonomy. |
| Deferred | Recognized but not required for first closeout. | Full multimodal implementation beyond browser/API; broad external connectors beyond initial API egress. |
| Rejected | Not promoted because it weakens governance or invents greenfield scope. | Thin model wrapper, generated cognition authority, live browser/API without proof, model swarm default. |
| Split | Broken into independent implementation tracks. | Context pack, risk/materiality, rollback, browser/API, benchmark, support proof. |


## resources/decision-record-plan.md

# Decision Record Plan

## Purpose

Durable decisions produced by this packet should be recorded in repo-authoritative decision surfaces, not left inside the proposal packet.

## Proposed decision records

| Decision record | Proposed durable location | Purpose | Timing |
|---|---|---|---|
| Frontier governance target-state adoption | `.octon/instance/cognition/decisions/<next>-frontier-governance-target-state.md` | Accept/reject/adapt the packet's target-state architecture. | After review acceptance. |
| Support-target vocabulary reconciliation | `.octon/instance/cognition/decisions/<next>-support-target-vocabulary-reconciliation.md` | Record chosen support mode vocabulary and schema/file/charter migration. | Phase 0. |
| Overlay registry truth alignment | `.octon/instance/cognition/decisions/<next>-overlay-registry-truth-alignment.md` | Record canonical overlay source and doc/manifest update approach. | Phase 0. |
| Context-pack first-class contract | `.octon/instance/cognition/decisions/<next>-context-pack-contract.md` | Approve context-pack schema, evidence path, and generated-source guardrails. | Phase 1. |
| Risk/materiality classifier | `.octon/instance/cognition/decisions/<next>-risk-materiality-classifier.md` | Approve classifier dimensions and policy effects. | Phase 1. |
| Workflow simplification disposition | `.octon/instance/cognition/decisions/<next>-workflow-catalog-simplification.md` | Record workflow core/optional/deprecated/delete classifications. | Phase 2. |
| Browser/API stage-to-live criteria | `.octon/instance/cognition/decisions/<next>-browser-api-support-admission.md` | Record runtime/evidence/support requirements for live claims. | Phase 3. |
| Benchmark and proof-plane certification | `.octon/instance/cognition/decisions/<next>-frontier-benchmark-certification.md` | Record benchmark model and acceptance thresholds. | Phase 5. |

## Decision record requirements

Each decision should include:

- source proposal id;
- source review artifact path;
- accepted/deferred/rejected motions;
- affected durable surfaces;
- support-target effect;
- evidence produced;
- rollback/reversal path;
- closure status.

## Non-goal

Decision records must not cite this packet as ongoing runtime authority after promotion. They may cite it as historical lineage.


## resources/evidence-plan.md

# Evidence Plan

## Evidence objective

Implementation of this proposal must be proven by retained evidence, not by prose claims. Evidence belongs under `state/evidence/**`, generated projections remain rebuildable, and proposal files remain non-canonical.

## Evidence families

| Evidence family | Proposed retained location | Producer | Required for |
|---|---|---|---|
| Proposal validation receipt | `state/evidence/validation/proposals/` | proposal validator | Packet closeout. |
| Support-target validation receipt | `state/evidence/validation/governance/support-targets/` | support validator | Phase 0 closeout. |
| Overlay validation receipt | `state/evidence/validation/governance/overlay-points/` | overlay validator | Phase 0 closeout. |
| Cognition runtime validation receipt | `state/evidence/validation/cognition/` | cognition drift validator | Phase 0 closeout. |
| Context-pack receipt | `state/evidence/runs/<run-id>/context-pack.receipt.json` | context assembler | Consequential run. |
| Risk/materiality receipt | `state/evidence/runs/<run-id>/risk-materiality.receipt.json` | risk classifier | Material actions. |
| Grant bundle | `state/evidence/control/execution/` and run evidence root | authorization engine | Material actions. |
| Execution receipt | `state/evidence/runs/<run-id>/receipts/**` | runtime | Every material attempt. |
| Replay pointers | `state/evidence/runs/<run-id>/replay-pointers.yml` | runtime/replay store | Replayability. |
| Trace pointers | `state/evidence/runs/<run-id>/trace-pointers.yml` | telemetry sink | Debugging and assurance. |
| Rollback evidence | `state/evidence/runs/<run-id>/rollback/**` | recovery service | Material actions requiring rollback. |
| Browser/UI record | `state/evidence/runs/<run-id>/browser-ui/**` | browser service | Browser pack support. |
| API egress record | `state/evidence/runs/<run-id>/api-egress/**` | API service | API pack support. |
| Lab scenario evidence | `state/evidence/lab/scenarios/**` | lab runner | HarnessCard. |
| Benchmark evidence | `state/evidence/lab/benchmarks/**` | benchmark runner | Comparative proof. |
| RunCard | `state/evidence/runs/<run-id>/run-card.yml` | assurance generator | Run certification. |
| HarnessCard | `state/evidence/lab/harness-cards/**` | assurance generator | Support certification. |
| Promotion dependency scan | `state/evidence/validation/promotion-dependency-scan/` | promotion validator | Archive readiness. |

## Evidence completeness checks

A consequential run is evidence-complete only if it has:

- execution request;
- context pack;
- risk/materiality classification;
- grant or denial;
- receipt for each material attempt;
- side-effect record;
- rollback/compensation posture when required;
- replay pointers;
- trace pointers;
- evidence classification;
- disclosure artifact if externally visible or support-relevant;
- RunCard.

## Evidence quality rules

- Evidence must be retained, not generated.
- Evidence links must be machine-readable.
- Evidence must record denials and escalations, not only successes.
- Evidence must record human interventions as control/evidence artifacts.
- Evidence must record support tuple and capability pack set.
- Evidence must distinguish authoritative source from derived read model.

## Proof gaps to close

- Browser/API replay evidence.
- Connector egress evidence.
- Raw-vs-Octon frontier benchmark evidence.
- Support dossier completeness evidence.
- Recovery drill evidence.
- Context-pack freshness/generation lock evidence.


## resources/frontier-governance-architecture-review.md

# Octon frontier-governance architecture review

I inspected the live public repository on the default `main` branch and treated the repo’s own architecture, manifests, specifications, support declarations, and runtime surfaces as the source of truth. I did not run the local Rust/shell test suite or clone-build the runtime; implementation judgments below are based on the repository’s visible public files, manifests, schemas, and GitHub-rendered tree.

---

## 1. Executive judgment

Octon is **not primarily threatened by frontier models becoming stronger**. The strongest parts of Octon become **more** valuable as models become more autonomous, tool-capable, long-context, and consequential. Octon’s durable center is not “helping weak models reason.” Its durable center is **making consequential autonomous work authorized, bounded, observable, replayable, reversible, and evidentially defensible**.

That said, the repo also contains several surfaces that now look vulnerable to technical debt because they reflect the 2023–2025 era of token scarcity, workflow-heavy cognition scaffolding, multi-surface abstraction proliferation, or support-matrix over-declaration. The right move is **not to delete Octon’s governance architecture**. The right move is to make Octon more sharply frontier-native: fewer compensatory cognitive layers, fewer speculative/declarative support claims, more runtime enforcement, stronger proof automation, clearer context packaging, and harder conformance gates.

The repository’s own root README describes Octon as a **“governed autonomous engineering harness”** with a class-root split across `.octon/framework`, `.octon/instance`, `.octon/inputs`, `.octon/state`, and `.octon/generated`. That is the right shape for a frontier-governance harness. The same root material identifies `.octon/framework` and `.octon/instance` as authored authority, `.octon/state` as continuity/evidence/control truth, and `.octon/generated` as rebuildable effective views/registries. That separation is strategically sound and should be preserved. ([github.com](https://github.com/jamesryancooper/octon))

The repo’s constitution is also unusually explicit about Octon’s enduring purpose: consequential autonomous work must be scoped, authorized, fail-closed, observable, and reviewable; raw inputs, generated projections, host UI affordances, and chat surfaces must not become authority; and every compensating mechanism must have an owner, removal review, and retirement trigger. That is exactly the right anti-bloat principle for the frontier era. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/constitution/CHARTER.md))

The architectural problem is not the constitutional core. The problem is **drift and overbreadth around the core**:

| Explicit question | Direct answer |
|---|---|
| **1. What is most likely to become technical debt because it reflects an earlier model era?** | Token-budget/progressive-disclosure scaffolding, workflow catalogs that encode thinking rather than governance, cognition indexes that imply memory/graph surfaces ahead of implementation, broad support matrices not tied tightly enough to executable proof, and user-facing multi-actor terminology if it implies agent teams rather than governed execution roles. |
| **2. What becomes more strategically important as models become more capable?** | Authority routing, hard fail-closed policy, capability admission, run contracts, retained evidence, replay, rollback, intervention, leases, circuit breakers, support dossiers, behavioral benchmarks, and proof-backed disclosure. |
| **3. What should be deleted outright?** | Active discovery of experimental external adapters, live support claims not schema-valid/proof-backed, generated cognition as any kind of authority, token-only prompt-routing metadata as authored control, and workflows that merely choreograph reasoning instead of creating governance/evidence value. |
| **4. What should be simplified but retained?** | Workflows, agents/assistants/teams, commands/skills/tools/services, support targets, generated cognition, lab/observability taxonomies, and proposal/promotion surfaces. |
| **5. What should be promoted into first-class architecture?** | Risk/materiality classification, context-pack contracts, intervention/lease/control-directive operations, rollback/recovery proof, browser/API/multimodal execution records, and benchmark suites comparing Octon-governed execution against raw frontier-model baselines. |
| **6. What is missing for long-running, high-consequence operation?** | More executable lifecycle around mission leases, run queues, slice boundaries, checkpoint/resume, autonomy budgets, circuit-breaker reset, safing mode, recovery windows, and automated evidence closure. Specs exist; implementation/proof needs to catch up. |
| **7. What is missing for browser/UI/API/multimodal execution under governance?** | Browser/API contracts exist, but the active runtime service manifest does not yet admit browser/API runtime services. Octon needs executable browser-session, API-client, UI replay, event-ledger, connector, egress, and multimodal provenance services before claiming those as live support. |
| **8. What is missing for recovery, rollback, and intervention quality?** | Rollback contracts enforced before action, compensability gates, recovery drill suites, replay-to-recovery tests, safing-mode tests, intervention latency metrics, and evidence that control directives/circuit breakers work in live runs. |
| **9. What is missing for proof, assurance, and behavioral benchmarking?** | Automated benchmark suites, raw-model baselines, governance-compliance graders, replay/rollback scoring, support-claim conformance tests, and generated RunCard/HarnessCard closure with machine-verifiable evidence links. |
| **10. What is the right future actor model?** | One accountable orchestrating agent by default, optional bounded specialists, optional independent verifier for separation of duties. Teams should be coordination/configuration, not runtime actors. |
| **11. What is the right future context/cognition/retrieval model?** | Frontier-native context packs assembled from authoritative surfaces, plus generated read models that are explicitly derived, rebuildable, freshness-checked, provenance-labeled, and never authoritative. Retrieval remains justified for dynamic/external/too-large corpora, not as “memory.” |
| **12. What is the right future runtime-native substrate?** | Run manager, policy/authority engine, capability gateway, context assembler, state/evidence store, telemetry/replay store, intervention/lease controller, rollback/recovery service, host/model adapters, browser/API/multimodal services, and assurance/benchmark runner. |
| **13. What should Octon benchmark itself against?** | Same frontier model without Octon, same model with a thin tool wrapper, and existing agent frameworks. Metrics should include success, unauthorized-action prevention, evidence completeness, replayability, rollback success, intervention quality, cost/latency, and false-block rate. |
| **14. What is the minimum sufficient complexity architecture?** | Constitution/authority; mission/objective/run contracts; capability/adapters; runtime enforcement; state/evidence/replay; intervention/recovery; assurance/lab; generated read models/context packs. Everything else must justify itself against those layers. |
| **15. What repo surfaces should change first?** | Support-target schema drift, overlay-point drift, cognition runtime/index drift, browser/API runtime-manifest gap, network-egress/budget policy narrowness, active experimental adapter discovery, workflow catalog bloat, and token-era manifest rationale. |

---

## 2. Premise validation and limits

The premise is **partly valid**. Frontier models now have materially larger context windows, stronger tool use, stronger multimodal ability, and better native long-horizon execution. OpenAI’s current model documentation lists GPT-5.4 as a flagship reasoning/coding model with a 1M-token context window, 128K max output, and built-in support for functions, web search, file search, and computer use. Anthropic’s current Claude documentation lists 1M-token context windows for several current Claude models. Google’s Gemini documentation describes current multimodal models and computer-use capabilities. ([platform.openai.com](https://platform.openai.com/docs/models))

That means some old tooling categories are under real pressure:

- Prompt tricks and brittle ReAct loops are less defensible.
- Multi-agent role play as a substitute for model competence is less defensible.
- Retrieval layers that exist only because context windows were tiny are less defensible.
- Workflow engines that simulate reasoning structure are less defensible.
- Prompt/version management as a core moat is less defensible.

But the premise is **not fully valid** when applied to governance harnesses. The official current OpenAI docs still treat agent orchestration, evals, traces, guardrails, context management, retrieval, and fine-tuning as live engineering concerns, not dead categories. OpenAI’s orchestration guide specifically says to start with one agent and add specialists only when they improve capability isolation, policy isolation, prompt clarity, or trace legibility; its eval guidance emphasizes traces, graders, datasets, tool-call assessment, handoff assessment, and safety-policy checks; and its accuracy guide still treats RAG and fine-tuning as valid optimization levers while warning that long-context models can still get “lost in the middle.” ([developers.openai.com](https://developers.openai.com/api/docs/guides/agents/orchestration))

For Octon, the correct frontier-era distinction is:

| Becoming less necessary | Becoming more necessary |
|---|---|
| Cognition scaffolding | Governance scaffolding |
| Prompt craft | Durable operational contracts |
| Multi-agent decomposition for reasoning | Accountable actor boundaries and separation of duties |
| RAG as memory substitute | Provenance-bound context packaging and retrieval for dynamic/large/external data |
| ReAct loop frameworks | Governed tool/capability invocation |
| LLMOps as provider abstraction | Evidence, support dossiers, replay, observability, disclosure |
| Workflow as thinking recipe | Workflow as authority/evidence gate |

Blindly following the “tooling is obsolete now” thesis would damage Octon if it caused deletion of run contracts, capability grants, support targets, assurance, evidence, replay, adapters, or fail-closed policy. Those are not compensatory scaffolds. They are how a frontier-model harness remains legitimate when the model is strong enough to do real damage.

---

## 3. Current-state repository audit

### 3.1 Core constitutional shape: strong

Octon’s class-root model is the right root abstraction. The `.octon/README.md` states that `.octon` is the single authoritative super-root, that only `.octon/framework` and `.octon/instance` are authored authority, that `.octon/inputs` are non-authoritative exploratory inputs, that `.octon/state` contains continuity/evidence/control truth, and that `.octon/generated` contains rebuildable projections and effective views. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon))

This is exactly the separation a frontier-governance harness needs:

- **Authority**: durable authored rules, contracts, specs.
- **Control truth**: mutable current operational decisions, approvals, exceptions, revocations, run state.
- **Evidence**: retained receipts, traces, replay pointers, validation outputs, disclosure artifacts.
- **Derived views**: generated summaries, registries, projections, read models.
- **Exploratory inputs**: non-authoritative ideation and raw materials.

The constitution reinforces that split. It says Octon exists to make consequential autonomous work scoped, authorized, fail-closed, observable, and reviewable; it explicitly rejects raw inputs, host UI/chat, generated projections, and model priors as authority; and it requires one accountable orchestrator by default. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/constitution/CHARTER.md))

### 3.2 Execution authorization: strategically central

The engine/runtime material is one of the repo’s strongest surfaces. The runtime README describes run-first operator surfaces such as `octon run start`, `inspect`, `resume`, `checkpoint`, `close`, `replay`, and `disclose`; it says consequential execution binds a canonical control root and evidence root before side effects; and it explicitly retires compatibility artifacts outside the canonical run lifecycle. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/engine/runtime))

The execution-authorization spec is also correctly shaped. It requires material execution to pass through `authorize_execution(request) -> GrantBundle`, includes service invocation, executor launch, repo mutation, publication, protected CI checks, and durable side effects as material paths, and requires no side effect before grant. It also requires support-matrix and capability-pack admission before grant. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/engine/runtime/spec/execution-authorization-v1.md))

The execution-request, grant, receipt, and policy-digest schemas are mature design primitives. They include risk tier, side-effect flags, workflow mode, mission context, oversight mode, reversibility class, decision outcomes, granted capabilities, effective policy mode, receipts, rollback posture, compensation, recovery windows, and breaker state. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/engine/runtime/spec/execution-request-v2.schema.json))

This is not obsolete. It is the heart of Octon’s future.

### 3.3 State and evidence: strong, but must become more automated

The state root is clean: `continuity`, `control`, and `evidence`. The control README identifies execution runs, approvals, exceptions, revocations, missions, extensions, and locality quarantine as mutable operational truth. The evidence README identifies run receipts, checkpoints, replay manifests, traces, disclosure artifacts, lab evidence, authority decisions, validation receipts, migration provenance, and publication receipts as retained evidence. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/state))

The design is strong. The next frontier-era need is less taxonomy and more automation: every consequential path should automatically produce the required receipts, run cards, replay pointers, rollback posture, and closure evidence.

### 3.4 Agency model: mostly right, with terminology risk

Octon’s current agency architecture is better than a typical multi-agent framework. The agency spec says to prefer simple, high-signal instructions over deeply nested indirection; it keeps agents, assistants, and teams but removes `subagents` as a first-class artifact; it treats teams as configuration/coordination rather than runtime actors; and it requires exactly one actor ID, no circular delegation, singular mission ownership, and no implicit privilege escalation. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/_meta/architecture/specification.md))

The registry defines a default orchestrator as the single accountable owner and an optional verifier only when independent verification or separation of duties is materially needed. The orchestrator contract says delegation is optional and justified only for separation of duties, context isolation, risk reduction, or bounded parallel work. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/runtime/agents/registry.yml))

That is the correct direction. The risk is terminology. “Agents,” “assistants,” and “teams” can be interpreted as a multi-agent cognition topology, which is exactly the pattern frontier models reduce the need for. Octon should keep the underlying governance semantics, but make the user-facing model clearer: **accountable orchestrator, bounded specialist, independent verifier, composition profile**.

### 3.5 Capabilities: right boundary, but too many nouns

The capability subsystem correctly separates commands, skills, tools, and services and makes capability discovery/admission subject to manifests, registries, contracts, allowed-tools packs, and deny-by-default policy. It also identifies governed packs for repo, git, shell, browser, API, and telemetry, with browser/API packs failing closed until admitted. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/capabilities))

The service design is governance-aware: services are domain capabilities with typed contracts, permission profiles, validators, evidence paths, and deny-by-default exception leases. Bare shell/write access is rejected unless mediated through policy. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/capabilities/runtime/services))

The weakness is conceptual proliferation. Commands, skills, tools, services, packs, adapters, and workflows all have legitimate roles, but the documentation should collapse the conceptual model into two simple categories:

1. **Instruction-level operator contracts**: commands and skills.
2. **Invocation-level capability contracts**: tools and services.

Everything else should be explained as packaging, admission, discovery, or UI projection.

### 3.6 Browser/API capability declarations: valuable but ahead of runtime

The browser and API packs are correctly specified as governed, replayable, evidence-bearing, boundary-sensitive capability packs. The browser pack requires authority decisions, external replay, event ledgers, RunCards, DOM/screenshot/session topology, negative tests, and fail-closed limitations. The API pack requires outbound API/connector governance, egress, replay, disclosure, request/response traces, external indexes, negative tests, and boundary experiments. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/packs/browser/manifest.yml))

However, the active runtime service manifest currently lists filesystem snapshot/discovery/watch, key-value storage, and execution flow services. It does **not** list browser-session or API-client as active runtime services, even though browser-session and API-client contracts exist. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/runtime/services/manifest.runtime.yml))

That is a critical repo-grounded finding: Octon’s browser/API governance design is good, but its declared frontier surface appears ahead of the executable runtime manifest. Until the runtime manifest, conformance tests, replay artifacts, and evidence bundles catch up, browser/API should be treated as **stage/escalate**, not broadly live.

### 3.7 Orchestration: governance-valid, but catalog-heavy

The orchestration spec is strong where it is contract-first and fail-closed. It requires canonical `workflow.yml`, stage assets, authority ordering, required fields, scope validation, README drift checks, manifest consistency, and no live references to proposal paths. Runtime workflows must declare authorization blocks, action types, requested capabilities, side-effect flags, scopes, review requirements, and executor profiles. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/orchestration/_meta/architecture/specification.md))

But the workflow catalog is broad and visibly influenced by token-budget/procedural scaffolding. The workflow manifest includes many meta, audit, foundation, mission, project, ideation, and task workflows, with comments about token budget and routing. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/orchestration/runtime/workflows/manifest.yml))

The correct rule is: **keep workflows that encode authority, staging, evidence, review, rollback, or publication. Demote workflows that only encode how a model should think.**

### 3.8 Cognition: correct umbrella principle, but implementation drift

The cognition umbrella spec is exactly right on authority: generated cognition contains derived summaries, graph datasets, and projections only; generated outputs are never source of truth; raw inputs cannot become runtime/policy dependencies; material execution resolves through engine-owned authorization; and retained receipts must live under state/evidence, not generated. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/cognition/_meta/architecture/specification.md))

But the cognition runtime surface appears drifted. The cognition runtime README/index describes runtime areas such as decisions, analyses, knowledge, migrations, evidence, evaluations, and projections, while the actual runtime directory visible in GitHub only shows a small `context/reference` surface. Generated cognition has summaries/projections/distillation, which is fine as derived material, but the authored cognition runtime appears to over-declare surfaces not present in the tree. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/cognition))

This should be fixed quickly because cognition/memory drift is exactly where old-era LLM scaffolding can become accidental authority.

### 3.9 Assurance/lab/observability: essential, but must become proof-producing

Assurance is well-framed as the legitimacy layer for quality, governance, trust, enforceable policy, auditable outcomes, evidence, attestations, logs, gates, and proof planes. Lab owns behavioral proof, scenario design, replay, shadow-run method, fault rehearsals, probes, and adversarial discovery. Observability owns normalized measurement, intervention accounting, drift incidents, failure taxonomy, and report-bundle conventions, subordinate to constitution and run roots. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/assurance))

This is not obsolete. But it must become more executable. The frontier-era bar is not “we have a taxonomy for assurance.” The bar is “we can run a supported scenario suite, compare against a raw frontier-model baseline, produce retained evidence, and issue or deny a HarnessCard.”

### 3.10 Portability/support: good intent, concrete drift

The support-target surface is valuable because it prevents vague portability claims. But it currently has a concrete schema/manifest mismatch. The support-target file declares `support_claim_mode: bounded-admitted-live-universe`, while the schema enum allows only `bounded-admitted-finite` or `global-complete-finite`. The constitution charter also references `global-complete-finite-product`. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/support-targets.yml))

That is not merely cosmetic. In a governance harness, support-claim vocabulary is an authority surface. If the live support file, schema, and charter disagree, the system should fail closed or force an explicit migration.

The support-target file also declares broad host adapters, model adapters, workload classes, context classes, locales, and capability packs, but then admits a finite list of specific tuples. The tuple approach is better than a cartesian support universe; Octon should make admitted tuples the operational truth and demote broad matrices to aspirational taxonomy unless dossier-backed. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/support-targets.yml))

### 3.11 Overlay points: another drift surface

The `.octon/README.md` says overlay points are only policies, contracts, agency-runtime, and assurance-runtime. But the overlay registry and instance manifest list additional overlay points such as exclusions, adoption, retirement, capability-packs, and governance-decisions. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon))

That is fixable, but it matters. Overlay points are authority-shaping surfaces. They need a single source of truth.

---

## 4. What Octon should remove

| Remove | What it currently does | Why it is questionable now | What would be lost | Replacement / safe path |
|---|---|---|---|---|
| **Active experimental external model adapter discovery** | The repo includes an `experimental-external` model adapter alongside supported adapters. | Support-targets say retired/experimental surfaces cannot be live support, and fail-closed policy denies unsupported behavior/support claims. Keeping experimental adapters in ordinary discovery invites accidental widening. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/engine/runtime/adapters/model/experimental-external.yml)) | A placeholder for future external-provider experiments. | Move to `inputs/exploratory`, `retired`, or a quarantined experimental registry not used by runtime discovery. Require explicit support-target admission before activation. |
| **Any live support claim not schema-valid and dossier-backed** | Support targets declare a bounded admitted live universe, but schema and charter vocabulary disagree. | Governance harnesses cannot tolerate fuzzy support-claim semantics. The schema mismatch must block publication or be migrated. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/support-targets.yml)) | Marketing breadth and aspirational portability language. | Use finite admitted tuples as operational truth. Add schema-valid support modes and proof-backed HarnessCards. |
| **Generated cognition as authority or memory** | Generated cognition contains summaries/projections/distillation. | Octon’s own spec says generated cognition is derived only and never source of truth. Frontier context reduces the need for generated “memory” as a cognitive crutch. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/cognition/_meta/architecture/specification.md)) | Fast summaries and projections if they are over-deleted. | Keep generated cognition only as rebuildable, freshness-checked, provenance-labeled read models and context-pack inputs. |
| **Workflow units that only choreograph model reasoning** | Workflow catalog includes many task/meta/audit/foundation workflows. | Stronger models can internally plan and decompose. Workflows that merely encode “how to think” are complexity debt. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/orchestration/runtime/workflows/manifest.yml)) | Familiar procedural recipes. | Retain workflows only when they encode authorization, evidence, stage gates, rollback, publication, or review. Move purely procedural guides to practices or optional packs. |
| **Authored token-budget/progressive-disclosure routing as control logic** | Skill/workflow docs include token budget/routing rationale and manifest/index split for token overhead. | 1M-context frontier models weaken token-scarcity as an architectural driver. Token optimization should be generated/runtime policy, not authored governance logic. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/_meta/architecture/specification.md)) | Some efficiency for smaller/local models. | Move token/cost handling into context-pack budgets and execution-budget policy. Keep degraded profiles for smaller models. |
| **Legacy compatibility shims after migration** | Runtime notes mention compatibility wrappers for workflow runs. | Compatibility is useful temporarily, but permanent dual paths become authority ambiguity. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/engine/runtime)) | Backward compatibility. | Keep wrappers only as migration bridges with expiry criteria and validation that canonical run receipts are still produced. |

Deletion principle: **delete cognition compensation; preserve governance enforcement**.

---

## 5. What Octon should scale back or collapse

### 5.1 Collapse the actor vocabulary

Retain:

- Orchestrator.
- Specialist assistant.
- Independent verifier.
- Team/composition profile.

Scale back:

- Any user-facing implication that Octon is a multi-agent swarm framework.
- “Team” as anything more than reusable composition/configuration.
- Any nested delegation model.

The current repo already moves this way by removing `subagents` as first-class artifacts and by making one orchestrator the default. That should become the headline actor model. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/_meta/architecture/specification.md))

### 5.2 Collapse capability terminology into two conceptual classes

Keep the existing directories for compatibility, but teach and validate them as:

1. **Operator-facing instruction contracts**: commands and skills.
2. **Runtime-facing invocation contracts**: tools and services.

Packs, registries, and manifests are packaging/admission layers, not new conceptual primitives.

This reduces cognitive overhead without weakening permissioning. The capability subsystem’s true value is deny-by-default capability control, service contracts, allowed-tools packs, evidence paths, and exception leases. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/capabilities))

### 5.3 Collapse workflow catalog into governance-critical core plus optional packs

Retain a small canonical workflow core:

- Run start/close/replay/disclose.
- Support-target admission.
- Capability-pack admission.
- Proposal promotion.
- Release/readiness validation.
- Recovery/rollback drill.
- Mission create/complete.
- Browser/API high-risk action path.
- HarnessCard/RunCard generation.

Move foundation recipes, generic application tasks, ideation flows, and task playbooks into optional packs or practice guides unless they directly enforce governance.

### 5.4 Collapse support matrix semantics into admitted tuples

The broad support universe is useful as taxonomy, but the operational truth should be a finite admitted tuple list with proof. The support-target file already contains tuple admissions; Octon should make that the hard boundary. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/support-targets.yml))

### 5.5 Collapse cognition runtime to what exists, or build what it claims

Today the cognition runtime index appears to list surfaces not visible in the actual runtime directory. Either implement those surfaces with clear authority rules, or remove them from the runtime index and keep them under generated/read-model spaces. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/cognition))

---

## 6. What Octon should retain

### 6.1 The five-class super-root

Retain as-is. This is Octon’s strongest architectural invariant.

- `.octon/framework`: portable authored core.
- `.octon/instance`: repo-specific durable authored authority.
- `.octon/inputs`: exploratory/additive/non-authoritative inputs.
- `.octon/state`: continuity/evidence/control truth.
- `.octon/generated`: rebuildable read models and effective views.

This split directly addresses the governance risks of frontier autonomy. ([github.com](https://github.com/jamesryancooper/octon))

### 6.2 Constitutional precedence and fail-closed rules

Retain as-is, but enforce harder. The fail-closed policy denies raw input runtime dependencies, generated-as-source-of-truth, host UI/chat authority, missing support targets, missing grants/receipts, and unsupported behavior claims. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/constitution/obligations/fail-closed.yml))

### 6.3 Engine-owned authorization

Retain and build out. `authorize_execution` should become the unavoidable gateway for all material actions. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/engine/runtime/spec/execution-authorization-v1.md))

### 6.4 Run-first runtime

Retain. The future execution unit should be the run, not the workflow or chat session. Missions provide continuity; runs provide atomic consequential execution. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/engine/runtime))

### 6.5 Mission-scoped reversible autonomy

Retain. The `.octon/README.md` already states that long-running/always-running agents must be mission-backed, seed-before-active, and must not fall back to external UI/chat/in-memory control planes. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon))

### 6.6 Capability packs and service contracts

Retain. Frontier models make tool use more powerful; therefore capability gating becomes more important, not less. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/capabilities))

### 6.7 Host/model adapters as non-authoritative boundaries

Retain, but narrow claims. Host/model adapters are useful if they define projection boundaries, conformance criteria, contamination/reset posture, and support-tier limits. They are not useful as generic vendor-switching abstractions. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/engine/runtime/adapters/host))

### 6.8 Assurance, lab, observability

Retain and automate. Evals are not obsolete for governance; they become the evidence that Octon’s control plane works. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/assurance))

---

## 7. What Octon should strengthen

### 7.1 Support-claim enforcement

Make support declarations schema-valid, tuple-based, and proof-backed. The current support-target mode mismatch should be treated as a release blocker until resolved. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/support-targets.yml))

### 7.2 Runtime implementation behind declared contracts

The repo has strong specs for grants, receipts, control leases, directives, circuit breakers, and mission autonomy. Those should move from “well-designed schemas” to “runtime-enforced invariants with retained proof.” ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/engine/runtime/spec/mission-control-lease-v1.schema.json))

### 7.3 Browser/API/multimodal execution

Browser and API packs are first-class frontier-era requirements, but they need executable runtime services, conformance suites, replay artifacts, and support dossiers before live support claims. The current contract surfaces are promising; the active runtime manifest must catch up. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/packs/browser/manifest.yml))

### 7.4 Network egress governance

The current network-egress policy appears narrowly scoped to a local LangGraph HTTP runner. That is not enough for governed API/browser operation. Octon needs connector-target leases, egress allowlists, redaction policy, request/response hashing, replay pointers, idempotency classification, compensation obligations, and external-effect disclosure. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/policies/network-egress.yml))

### 7.5 Execution budgets

Current execution budgets appear framed around provider/workflow-stage limits. Frontier-native Octon needs run-level and mission-level budgets covering model tokens, tool calls, browser steps, API calls, wall-clock time, retries, evidence storage, and human-intervention thresholds. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/policies/execution-budgets.yml))

### 7.6 Context-pack construction

Long-context models reduce retrieval pressure, but they increase the importance of deterministic context assembly. Octon should define first-class context packs with authority labels, provenance, freshness, source hashes, generated/authoritative separation, token budgets, and evaluation receipts.

### 7.7 Proof automation

Assurance/lab/observability should produce machine-checkable evidence. RunCards and HarnessCards should be generated only when run receipts, replay pointers, support claims, conformance results, and disclosure obligations are complete. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/constitution/obligations/evidence.yml))

### 7.8 Drift detection

Add validators for:

- Support-target file vs schema vs charter.
- Overlay registry vs README vs instance manifest.
- Runtime service manifest vs capability-pack admissions.
- Cognition runtime index vs actual tree.
- Generated effective views vs source timestamps.
- Adapter claims vs support dossiers.
- Workflow README/generated output drift.

The repo already has fail-closed principles; it needs more concrete “doctor” checks.

---

## 8. What Octon should add

### 8.1 First-class risk/materiality classifier

Add a durable risk/materiality surface under governance/constitution, for example:

- `framework/constitution/contracts/authority/risk-materiality-v1.schema.json`
- `instance/governance/policies/risk-materiality.yml`

It should classify action materiality across code mutation, external side effects, data exposure, identity/credential risk, financial/legal risk, public release, API egress, browser action, and irreversible state changes.

### 8.2 Context-pack contract

Add:

- `framework/engine/runtime/spec/context-pack-v1.schema.json`
- `state/evidence/runs/<run-id>/context-pack.json`
- `state/evidence/runs/<run-id>/context-pack.receipt.json`

Each context pack should record:

- Authoritative sources.
- Generated sources.
- Excluded sources.
- Freshness checks.
- Source hashes.
- Token counts.
- Model context limit.
- Known omissions.
- Authority labels.
- Retrieval/search steps, if any.
- Whether generated cognition was used only as a read model.

### 8.3 Browser/UI execution record

Add a first-class browser/UI execution record schema that captures:

- Session topology.
- DOM snapshots or references.
- Screenshots or visual state pointers.
- Accessibility tree, where available.
- User-visible action log.
- External-effect classification.
- Replay manifest.
- Redaction policy.
- Human-intervention markers.
- Consent/approval lease.

The browser pack already gestures at these requirements; they should become executable schemas and retained evidence. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/packs/browser/manifest.yml))

### 8.4 API connector and egress lease model

Add a connector registry with target-specific governance:

- Allowed domains/services.
- Auth mode.
- Data classes.
- Idempotency class.
- Rate/cost limits.
- Compensation plan.
- Replay/redaction requirements.
- Support target admission.
- Human approval thresholds.

### 8.5 Recovery and rollback drill suite

Add lab scenarios for:

- Failed tool call mid-run.
- Browser action before final submit.
- API partial failure.
- Repo mutation rollback.
- Conflicting control directive.
- Mission pause/resume.
- Circuit breaker trip/reset.
- Stale generated context rejection.
- Support-target denial.
- Human intervention at safe boundary.

### 8.6 Frontier baseline benchmark harness

Add benchmark definitions comparing:

1. Raw frontier model with same repo context.
2. Raw model plus thin tool wrapper.
3. Octon-governed execution.
4. Octon-governed execution with verifier.
5. Octon under degraded/local model profile.

Metrics should include task success, unauthorized action attempts prevented, false-denial rate, evidence completeness, replayability, rollback success, intervention latency, cost, wall-clock time, and disclosure quality.

### 8.7 Contamination/reset evidence

Model adapters already mention contamination/reset posture. Add retained reset evidence for long-running missions and external-model sessions, especially when context persists across runs. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/engine/runtime/adapters/model/frontier-governed.yml))

---

## 9. Target-state governance harness architecture for frontier models

### 9.1 What Octon fundamentally is

Octon should be:

> **A control plane and evidence harness for consequential frontier-model engineering work.**

Its job is to make strong models safe and legitimate enough to use in real repositories, workflows, browsers, APIs, and eventually multimodal environments.

### 9.2 What Octon is not

Octon should not be:

- A generic multi-agent framework.
- A RAG/memory product.
- A prompt management platform.
- A generic LLM gateway.
- A replacement for the model’s native reasoning.
- A workflow engine for simulating thought.
- A UI or host projection that becomes authority.

### 9.3 Minimum enduring layers

The minimum sufficient future architecture is:

1. **Constitution and authority**  
   Charter, fail-closed rules, precedence, evidence obligations, support-claim rules.

2. **Intent and execution control**  
   Mission, objective, run contract, slice, lease, approval, exception, revocation, control directive.

3. **Capability and adapter governance**  
   Packs, services, tools, host/model adapters, support-target admissions, egress policy, execution budgets.

4. **Runtime enforcement**  
   Authorization engine, grant issuance, capability gateway, run manager, checkpointing, replay, telemetry, receipt emission.

5. **State and evidence**  
   Control truth, retained evidence, continuity, RunCards, HarnessCards, disclosure bundles.

6. **Recovery and intervention**  
   Rollback plans, compensation, safing mode, circuit breakers, safe interruption boundaries, mission pause/resume.

7. **Assurance and lab**  
   Conformance tests, scenario suites, behavioral benchmarks, adversarial probes, recovery drills, raw-model baselines.

8. **Generated read models and context packs**  
   Derived projections, summaries, registries, context packs, freshness receipts, never authority.

Everything outside these eight layers should be optional, generated, or retired unless it carries direct governance value.

---

## 10. Recommended actor / runtime / cognition / assurance model

### 10.1 Actor model

Recommended actor model:

```text
Human / policy authority
        |
        v
Accountable orchestrator
        |
        +-- optional specialist assistant(s)
        |
        +-- optional independent verifier
        |
        v
Engine-owned authorization and capability gateway
```

Rules:

- Exactly one accountable orchestrator per consequential run.
- Assistants are stateless specialists, not independent authorities.
- Verifier exists only for separation of duties, high materiality, or support-claim proof.
- Teams are reusable composition profiles, not runtime actors.
- No subagents as first-class artifacts.
- No implicit privilege escalation through delegation.

This aligns with Octon’s current agency direction and OpenAI’s current orchestration guidance to start with one agent and add specialists only for material isolation/trace/policy benefits. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/_meta/architecture/specification.md))

### 10.2 Runtime model

Recommended runtime model:

1. Human/model proposes objective.
2. Context pack is assembled from authoritative and derived sources with provenance.
3. Orchestrator drafts run contract.
4. Risk/materiality classifier assigns required posture.
5. `authorize_execution` grants, denies, stages, or escalates.
6. Capability gateway executes only granted actions.
7. Runtime emits receipts, telemetry, replay pointers, checkpoints.
8. Intervention/lease/circuit-breaker layer may pause, narrow, revoke, or safing-mode the run.
9. Closeout emits RunCard and required disclosure.
10. Assurance/lab can replay, grade, and benchmark.

### 10.3 Cognition/context/retrieval model

Recommended model:

- Treat frontier-model context as the default path.
- Assemble deterministic **context packs**, not ad hoc prompt stuffing.
- Use generated cognition only as a derived index/read model.
- Use retrieval only when data is dynamic, external, too large, legally scoped, or when exact source provenance matters.
- Never allow generated summaries, graph projections, or retrieval results to become authority.
- Evaluate context-pack sufficiency and “lost in the middle” failure modes. Long context is powerful but not automatically reliable. ([developers.openai.com](https://developers.openai.com/api/docs/guides/optimizing-llm-accuracy))

### 10.4 Assurance model

Recommended assurance model:

- Structural validation: manifests, schemas, drift checks.
- Governance validation: grants, denials, support targets, capability admissions.
- Behavioral validation: scenario success/failure behavior.
- Recovery validation: rollback, resume, safing, compensation.
- Evidence validation: receipts, replay pointers, disclosure bundles.
- Comparative validation: raw model vs Octon-governed model.
- Regression validation: support target remains true after changes.

---

## 11. Portability and support-target strategy

Octon should adopt a **frontier-native core, bounded-degradation strategy**.

### 11.1 Frontier-native tier

Optimize first for:

- 1M-context frontier models.
- Native tool/computer use.
- Multimodal inputs.
- Long-horizon execution.
- Strong instruction following.
- Strong repo ingestion.

This tier should use context packs, not fragmented token-era retrieval scaffolding.

### 11.2 Degraded/local tier

Support smaller/local/repo-bound models through:

- More aggressive context compaction.
- Smaller workflow slices.
- Stronger verifier requirements.
- Reduced support claims.
- Narrower capability packs.
- Higher human review thresholds.

### 11.3 Support claims must be tuple-based

The live support universe should be:

```text
(model adapter, host adapter, workload class, context class, locale, capability pack)
```

Only admitted tuples with proof should be live. Broad taxonomies can exist, but they must not imply support. The existing support-target file already points in this direction with finite tuple admissions; Octon should make that the sole operational truth. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/support-targets.yml))

### 11.4 Adapter claims must be evidence-backed

Host adapters and model adapters should declare:

- Support tier.
- Capability limits.
- Conformance suite.
- Known limitations.
- Contamination/reset posture.
- Evidence bundle.
- Disclosure obligations.

The current adapter docs already emphasize non-authoritative adapters and bounded support claims; the next step is stricter proof gating. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/engine/runtime/adapters/host))

---

## 12. File- and surface-level change map

| Surface | Current repo evidence | Change |
|---|---|---|
| `.octon/instance/governance/support-targets.yml` | Declares `bounded-admitted-live-universe`. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/support-targets.yml)) | Rename to schema-valid mode or extend schema. Prefer `bounded-admitted-finite` with admitted tuples as operational truth. |
| `.octon/instance/governance/support-targets.schema.json` | Allows only `bounded-admitted-finite` and `global-complete-finite`. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/constitution/support-targets.schema.json)) | Align with live file or fail validation. |
| `.octon/framework/constitution/charter.yml` | References `global-complete-finite-product`. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/constitution/charter.yml)) | Align support-universe vocabulary across charter, schema, support-targets, generated docs. |
| `.octon/README.md` overlay section | Says only four overlay points are overlay-capable. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon)) | Update to match overlay registry or narrow registry. |
| `.octon/framework/overlay-points/registry.yml` and `.octon/instance/manifest.yml` | List more overlay points than README. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/overlay-points/registry.yml)) | Make overlay registry canonical; regenerate README from it. |
| `.octon/framework/cognition/runtime/index.yml` | Lists many cognition runtime paths. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/cognition/runtime/index.yml)) | Either implement missing dirs or trim index to actual live surfaces. |
| `.octon/framework/cognition/runtime/` | Visible tree only shows small `context/reference` surface. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/cognition/runtime)) | Collapse cognition runtime to actual authority-bearing files; keep summaries/projections under generated. |
| `.octon/generated/cognition/**` | Contains distillation/projections/summaries. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/generated/cognition)) | Keep, but label as derived context-pack input only; never authority. |
| `.octon/framework/capabilities/runtime/services/manifest.runtime.yml` | Active services are filesystem, watch, KV, execution flow. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/runtime/services/manifest.runtime.yml)) | Add browser-session/API-client only when executable implementations, conformance, replay, and evidence exist. |
| Browser/API pack manifests | Browser/API packs require replay/evidence/fail-closed governance. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/packs/browser/manifest.yml)) | Promote to runtime only after service manifest and support dossiers are complete. |
| `.octon/instance/governance/policies/network-egress.yml` | Allows local LangGraph HTTP runner only. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/policies/network-egress.yml)) | Add governed connector leases for API/browser egress, or keep API pack stage-only. |
| `.octon/instance/governance/policies/execution-budgets.yml` | Workflow-stage provider budgets. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/instance/governance/policies/execution-budgets.yml)) | Expand to run/mission/model/tool/browser/API budgets with frontier context limits. |
| `.octon/framework/engine/runtime/adapters/model/experimental-external.yml` | Experimental adapter present. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/engine/runtime/adapters/model/experimental-external.yml)) | Move out of active discovery or quarantine until admitted. |
| `.octon/framework/orchestration/runtime/workflows/manifest.yml` | Large workflow catalog with token-budget/routing framing. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/orchestration/runtime/workflows/manifest.yml)) | Audit each workflow: governance gate, optional pack, or delete. |
| `.octon/framework/capabilities/_meta/architecture/specification.md` | Token-overhead/progressive-disclosure rationale. ([raw.githubusercontent.com](https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/_meta/architecture/specification.md)) | Reframe around context-pack budgeting and degraded profiles, not token-era architecture. |
| `.octon/framework/lab/**` | Lab scenario/replay/shadow/fault/probe design surfaces. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/lab)) | Add executable frontier benchmark suites and raw-model baselines. |
| `.octon/framework/assurance/**` | Assurance proof planes and gates exist. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/assurance)) | Generate RunCards/HarnessCards only from complete retained evidence. |
| `.octon/framework/engine/runtime/spec/**` | Rich control, lease, directive, breaker, grant, receipt schemas. ([github.com](https://github.com/jamesryancooper/octon/tree/main/.octon/framework/engine/runtime/spec)) | Add context-pack, rollback-plan, browser-action-record, API-egress-record, and risk-materiality schemas. |

---

## 13. Priority-ordered transition roadmap

### Phase 0 — Truth alignment and fail-closed cleanup

1. Fix support-target mode/schema/charter mismatch.
2. Fix overlay-point drift.
3. Reconcile cognition runtime index with actual tree.
4. Demote browser/API live support until runtime manifest and conformance evidence exist.
5. Move experimental external adapter out of active discovery.
6. Add a drift gate that blocks release when these authority surfaces disagree.

### Phase 1 — Minimum frontier-native run core

1. Add context-pack schema and evidence receipts.
2. Add risk/materiality classifier.
3. Update execution budgets for run/mission/model/tool/browser/API.
4. Expand egress policy to governed connector leases.
5. Require rollback posture before material action.
6. Ensure every consequential action routes through `authorize_execution`.

### Phase 2 — Simplification pass

1. Audit workflow catalog.
2. Delete or demote thinking-only workflows.
3. Collapse actor terminology in docs.
4. Collapse capability conceptual model in docs.
5. Move token-era optimization language into generated/runtime budget policy.
6. Define “minimum sufficient Octon” profile.

### Phase 3 — Browser/API/multimodal runtime

1. Add browser-session and API-client to runtime service manifest only with executable implementations.
2. Add replay/event-ledger schemas.
3. Add API connector registry.
4. Add egress leases and redaction policy.
5. Add support dossiers for admitted browser/API tuples.
6. Add conformance tests and failure-mode tests.

### Phase 4 — Recovery, rollback, and intervention

1. Implement mission control leases.
2. Exercise control directives.
3. Exercise circuit breakers.
4. Add safing-mode tests.
5. Add rollback/compensation drill suites.
6. Add intervention-quality metrics.

### Phase 5 — Assurance and benchmark automation

1. Add raw frontier-model baseline benchmarks.
2. Add Octon-governed comparative runs.
3. Add governance-compliance graders.
4. Add replayability and rollback scoring.
5. Automate RunCard and HarnessCard generation.
6. Publish support claims only from retained proof bundles.

### Phase 6 — Portability hardening

1. Define frontier-native tier.
2. Define degraded/local tier.
3. Require tuple-level support evidence.
4. Narrow adapter declarations to proven scope.
5. Add contamination/reset receipts for long-running model contexts.
6. Add CI enforcement for support-target drift.

---

## 14. Acceptance criteria for the target state

Octon reaches the target state when all of the following are true:

1. **Support truth**  
   Every support claim is schema-valid, tuple-admitted, and linked to a retained support dossier.

2. **Authority clarity**  
   No runtime/policy path reads raw inputs, generated cognition, host UI, chat state, or model priors as authority.

3. **Run enforceability**  
   No material side effect occurs without an execution request, grant/denial, run root, evidence root, receipt obligations, and rollback posture.

4. **Context legitimacy**  
   Every consequential run has a context pack with source hashes, authority labels, freshness checks, generated/authoritative separation, token/cost accounting, and known omissions.

5. **Capability gating**  
   Tools/services/browser/API actions execute only through admitted packs and granted capabilities.

6. **Browser/API proof**  
   Browser and API actions produce replayable records, egress leases, event logs, redaction metadata, and compensation/recovery posture.

7. **Intervention quality**  
   Pause, narrow, revoke, safing, resume, and circuit-breaker paths are tested and produce retained evidence.

8. **Rollback quality**  
   Supported high-consequence scenarios have tested rollback or compensation drills.

9. **Assurance automation**  
   RunCards and HarnessCards are generated from evidence, not manually asserted.

10. **Benchmark honesty**  
   Octon is benchmarked against the same frontier model without Octon and shows governance value: fewer unauthorized actions, better evidence completeness, better replayability, better recovery, and acceptable overhead.

11. **Actor simplicity**  
   A run has one accountable orchestrator, optional specialists, and optional verifier. No hidden teams, subagents, or second control plane.

12. **Generated safety**  
   Generated read models can improve context quality but cannot authorize, approve, publish, or override durable control/evidence.

---

## 15. Risks, tradeoffs, and likely blind spots

### Risk: over-simplification

The main risk in reacting to frontier models is deleting governance surfaces because they look like old LLM tooling. Workflows, adapters, evals, and retrieval are not automatically obsolete. They become obsolete only when they encode cognition compensation rather than authority, evidence, permissioning, recovery, or proof.

### Risk: long context creates false confidence

1M-token context reduces retrieval pressure but does not remove context-selection risk, lost-in-the-middle risk, stale-source risk, or authority-mixing risk. Octon should not replace RAG over-engineering with giant ungoverned context dumps. It needs context packs.

### Risk: support conservatism may feel less impressive

Moving from broad support matrices to admitted tuples may make Octon look smaller. That is the right tradeoff. A governance harness should prefer support honesty over unsupported breadth.

### Risk: runtime implementation burden

Browser/API/multimodal execution under governance is hard. Replay, redaction, external-effect classification, compensation, and support proofs are expensive. But these are exactly the surfaces that matter as models become more capable.

### Risk: taxonomy without automation

Assurance, lab, and observability can become taxonomy-heavy. They must become proof-producing, benchmark-running, and release-blocking.

### Risk: model churn

Frontier model capabilities will keep changing. Adapter facts must be treated as observed runtime/support facts, not permanent truths.

### Risk: human intervention as hidden control plane

Octon already prohibits hidden human intervention. As long-running autonomy grows, this needs stronger enforcement: every human pause, override, approval, revocation, or out-of-band correction must be recorded as control/evidence.

---

## 16. Final recommendation

Octon should **not** become a thinner agent wrapper around the best frontier model. That would destroy its strongest advantage.

Octon should also **not** preserve every current surface merely because it exists. The repo’s own constitution says compensating mechanisms need owner, removal review, and retirement triggers. That principle should now be applied aggressively.

The best target-state is:

> **Octon is the minimum sufficient governance harness for frontier-model engineering: one accountable orchestrator, deterministic context packs, engine-owned authorization, deny-by-default capability gates, retained evidence, replay, rollback, intervention, support-proof dossiers, and automated assurance.**

The most important first changes are:

1. Fix support-target schema/charter/live-file drift.
2. Fix overlay-point drift.
3. Reconcile cognition runtime claims with actual implemented surfaces.
4. Demote browser/API live support until runtime services and proofs exist.
5. Move experimental external adapters out of active support discovery.
6. Collapse token-era workflow/skill routing rationale into runtime context/budget policy.
7. Add first-class context-pack, risk/materiality, browser/API trace, rollback-plan, and benchmark schemas.
8. Benchmark Octon against raw frontier-model baselines.

In short: **retain the constitutional core, run-first engine, authority/evidence split, and assurance ambition; delete or demote old cognition scaffolding; and build the missing runtime/proof substrate for high-consequence frontier-model operation.**


## resources/rejection-ledger.md

# Rejection Ledger

## Rejected or demoted ideas

| Idea | Disposition | Reason | Safer replacement |
|---|---|---|---|
| Make Octon a thin wrapper around the best frontier model | Rejected | Destroys Octon's governance advantage and ignores authority/evidence/recovery needs. | Governance harness with engine-owned authorization and proof. |
| Treat frontier-model capability as reason to delete evals/observability | Rejected | Stronger models create higher consequence; assurance becomes more important. | Automated assurance, lab scenarios, benchmarks, RunCards/HarnessCards. |
| Treat generated cognition as memory/authority | Rejected | Violates generated contract and risks accidental policy/control truth. | Derived read models feeding context packs with provenance. |
| Use multi-agent swarms by default | Rejected | Overfits older weak-model decomposition and creates control ambiguity. | One accountable orchestrator with optional specialists/verifier. |
| Keep every workflow because it exists | Rejected | Complexity without governance value is technical debt. | Workflow audit: retain core governance, demote optional practices, delete thinking-only. |
| Claim browser/API live support immediately | Rejected | Runtime service manifest and evidence must catch up first. | Stage-only until executable services, replay, egress, dossiers, tests. |
| Use support matrices as broad live claims | Rejected | Broad taxonomy without tuple proof weakens support honesty. | Finite admitted tuples with support dossiers. |
| Preserve experimental external adapter in active discovery | Rejected as live support | Experimental adapter can invite accidental widening. | Quarantine or stage-only with explicit validation. |
| Solve context only by stuffing huge prompts | Rejected | Long context does not eliminate source, freshness, authority, omission, or lost-in-middle risks. | Deterministic context packs and evaluation. |
| Store intervention state in chat/UI comments | Rejected | Creates hidden control plane. | Canonical control directives, leases, approvals, exceptions, revocations, evidence. |

## Deferred ideas

| Idea | Deferred until | Reason |
|---|---|---|
| Full multimodal execution beyond browser/API | After browser/API runtime proof | Avoid speculative surface expansion. |
| Broad external connector marketplace | After connector lease and egress record are proven | Avoid support explosion. |
| Global support universe | After finite admitted tuples and support dossiers are robust | Current priority is support honesty. |
| Deep graph cognition layer | After generated cognition guardrails and context-pack model are proven | Avoid accidental memory/authority. |


## resources/repository-baseline-audit.md

# Repository Baseline Audit

## Audit scope

This baseline summarizes repository evidence used by the packet. It is not a substitute for running the repository's validators. It records the visible live public repository posture at packet authoring time.

## Proposal system evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/inputs/exploratory/proposals/README.md` | Proposals are non-canonical implementation aids; active proposals live under `/.octon/inputs/exploratory/proposals/<kind>/<proposal_id>/`; required files include `proposal.yml`, one subtype manifest, `README.md`, navigation files, and optional support. | Packet path and file set follow this convention. |
| `.octon/framework/scaffolding/governance/patterns/proposal-standard.md` | Defines proposal manifest contract, lifecycle, required files, promotion target rules, registry contract, and non-canonical rule. | `proposal.yml` uses `proposal-v1`, `architecture`, `octon-internal`, active `draft`, temporary lifecycle, and `.octon/**` promotion targets. |
| `.octon/framework/scaffolding/governance/patterns/architecture-proposal-standard.md` | Requires `architecture-proposal.yml`, `architecture/target-architecture.md`, `architecture/acceptance-criteria.md`, and `architecture/implementation-plan.md`. | Packet includes these required files and additional architecture/resource artifacts. |

## Super-root and authority evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/README.md` | Defines `.octon` as single authoritative super-root; only `framework/**` and `instance/**` are authored authority; `inputs/**` is non-authoritative; `state/**` is continuity/evidence/control; `generated/**` is rebuildable. | Target architecture preserves class-root separation. |
| `.octon/octon.yml` | Root manifest with profiles, fail-closed policies, runtime input roots, adapter roots, capability roots, evidence roots, and execution governance. | Promotion targets include root manifest only for hooks needed by accepted new surfaces. |
| `.octon/framework/cognition/_meta/architecture/specification.md` | Structural SSOT; generated outputs are never source of truth; material execution resolves through engine authorization; runtime evidence belongs under `state/evidence/**`. | Context/cognition model must keep generated outputs derived only. |

## Execution/runtime evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/engine/runtime/README.md` | Runtime exposes run-first CLI surfaces and binds run control/evidence roots before side effects. | Run remains atomic execution unit. |
| `.octon/framework/engine/runtime/spec/execution-authorization-v1.md` | Material execution must pass through `authorize_execution`; no material side effect before grant; receipt emission mandatory. | Engine-owned authorization is strengthened, not removed. |
| `execution-request-v2.schema.json`, `execution-grant-v1.schema.json`, `execution-receipt-v2.schema.json` | Request/grant/receipt schemas already include risk, side effects, workflow mode, autonomy context, decision, capabilities, rollback/compensation handles, and evidence links. | Extend these with context-pack, materiality, rollback, browser/API, egress, and benchmark references. |

## Agency evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/agency/_meta/architecture/specification.md` | Defines agents, assistants, teams; removes `subagents` as first-class artifact; teams are composition, not runtime actor. | Actor simplification aligns with existing direction. |
| `.octon/framework/agency/runtime/agents/registry.yml` | Default orchestrator plus optional verifier. | Target actor model uses one accountable orchestrator plus optional bounded specialists/verifier. |

## Capability evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/capabilities/README.md` | Defines commands, skills, tools, services; browser/API packs fail closed until repo-local admission. | Keep governance but simplify conceptual model. |
| `.octon/framework/capabilities/runtime/services/manifest.runtime.yml` | Active services listed as filesystem snapshot/discovery/watch, KV, and execution flow. | Browser/API services are not active in manifest and should not be live claims until implemented/proved. |
| `.octon/framework/capabilities/packs/browser/manifest.yml` | Requires authority decision, replay, runtime event ledger, RunCard, support target, DOM/screenshot/session topology. | Browser pack has strong design, needs runtime proof. |
| `.octon/framework/capabilities/packs/api/manifest.yml` | Requires egress, replay, disclosure, request/response trace pointers, compensation. | API pack has strong design, needs egress/connector/runtime proof. |

## Support/adapter evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/instance/governance/support-targets.yml` | Declares support modes, support universe, tuple admissions, host/model adapters, conformance criteria, support dossiers. Uses `bounded-admitted-live-universe`. | P0 drift with schema; admitted tuples should be operational support truth. |
| `.octon/framework/constitution/support-targets.schema.json` | Allows `bounded-admitted-finite` and `global-complete-finite`. | Schema/live file mismatch must be reconciled. |
| `.octon/framework/engine/runtime/adapters/model/experimental-external.yml` | Experimental model adapter with experimental tier hints. | Should be quarantined or stage-only, not active support. |

## Overlay evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/framework/overlay-points/registry.yml` | Lists overlay points including policies, contracts, adoption, retirement, exclusions, capability-packs, decisions, agency runtime, assurance runtime. | README overlay list must match registry/manifest or registry should be narrowed. |
| `.octon/instance/manifest.yml` | Enables the overlay points listed in registry. | Instance manifest must remain aligned with registry and docs. |

## Governance policy evidence

| Path | Observed role | Packet implication |
|---|---|---|
| `.octon/instance/governance/policies/network-egress.yml` | Allows local LangGraph HTTP runner only. | Insufficient for governed API/browser egress. Add connector leases or keep API stage-only. |
| `.octon/instance/governance/policies/execution-budgets.yml` | Applies cost guardrails to OpenAI/Anthropic workflow stages. | Expand to run/mission/tool/browser/API/model budgets. |

## Baseline limitations

- This packet generation did not run Octon's local validators or build runtime crates.
- Some repository files are minified single-line YAML/JSON in raw view; judgments use visible content and prior review evidence.
- Implementation must re-run repository-local validation before promotion.


## resources/risk-register.md

# Risk Register

| Risk | Description | Impact | Likelihood | Mitigation | Owner surface |
|---|---|---:|---:|---|---|
| Over-simplification | Deleting governance surfaces because they resemble old tooling. | High | Medium | Require every deletion to classify whether surface is cognition scaffolding or governance scaffolding. | Deletion matrix, ADR. |
| Under-simplification | Preserving workflows/actor/cognition bloat without governance value. | High | High | Workflow audit and removal triggers. | Orchestration manifest. |
| Support truth drift | Schema/file/charter mismatch persists. | High | High | P0 validator and release blocker. | Support targets/schema/charter. |
| Browser/API overclaim | Browser/API support treated as live before runtime/evidence exists. | High | Medium | Stage-only posture and support dossier gate. | Capability packs, service manifest. |
| Generated authority leakage | Generated cognition or effective projections become policy/approval truth. | High | Medium | Generated authority ban and context-pack labels. | Cognition spec, validators. |
| Context false confidence | Long context leads to ungoverned prompt dumps. | Medium/High | High | Context-pack contract with source hashes/freshness/omissions. | Context-pack schema. |
| Benchmark theater | Benchmarks test output quality but not governance. | Medium | Medium | Include authorization/evidence/recovery/support metrics. | Lab/assurance. |
| Runtime burden | Browser/API/recovery implementation exceeds near-term capacity. | Medium | High | Stage rollout; do not claim live support until proof exists. | Implementation plan. |
| Adapter churn | Frontier providers/hosts change rapidly. | Medium | High | Treat adapter facts as observed support facts tied to dossiers. | Adapter manifests/support dossiers. |
| Hidden human control plane | Human interventions happen in chat/UI without control evidence. | High | Medium | Require intervention/control directive artifacts. | State/control/evidence. |
| Validator brittleness | New validators block useful work due to false positives. | Medium | Medium | Stage validators in advisory then hard-enforce with fixtures. | Assurance runtime. |
| Proposal dependency leak | Durable targets cite proposal files as authority after promotion. | High | Low/Medium | Promotion dependency scan before closure. | Closure certification. |


