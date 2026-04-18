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
