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
