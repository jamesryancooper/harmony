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
