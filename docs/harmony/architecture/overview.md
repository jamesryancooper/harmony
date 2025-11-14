---
title: Harmony Structural Paradigm (HSP) Overview
description: Modular-monolith architecture with vertical slices, deterministic quality gates, and a guided MAPE‑K autonomic loop with human‑in‑the‑loop governance for a small, fast team.
---

# Harmony Structural Paradigm (HSP)

HSP‑v1: The Harmony Hexa‑Modulith with Vertical Slices and a Thin Control Plane.

Related docs: [repository blueprint](./repository-blueprint.md), [monorepo layout](./monorepo-layout.md), [governance model](./governance-model.md), [runtime policy](./runtime-policy.md), [observability requirements](./observability-requirements.md), [knowledge plane](./knowledge-plane.md), [kaizen subsystem](./kaizen-subsystem.md), [tooling integration](./tooling-integration.md), [agent roles](./agent-roles.md), [MAPE-K modeling](./mape-k-loop-modeling.md)

The Harmony Structural Paradigm (HSP) is the architectural blueprint for our Harmony-driven monorepo. It combines proven software patterns with an AI-guided, self-improvement loop while enforcing four non‑negotiable pillars:

- Speed with Safety
- Simplicity over Complexity
- Quality through Determinism
- Guided Agentic Autonomy

HSP is optimized for a small team (2 developers, scaling to ~6) to build and evolve a SaaS platform quickly, safely, and predictably.

HSP aligns process and tooling end‑to‑end across all lifecycle stages (Spec → Plan → Implement → Verify → Ship → Operate → Learn) while upholding the four pillars above. The toolkit is designed to cover each stage with thin, predictable interfaces and fail‑closed governance.

### Terminology: Slices vs Layers

- Runtime code is organized by vertical feature slices with hexagonal (ports/adapters) boundaries. We do not use classic n‑tier layering for application calls.
- “layer” refers to cross‑cutting governance/control‑plane concerns (e.g., Kaizen, quality gates, observability) that span slices, not runtime call layers.
- See also: [slices vs layers](./slices-vs-layers.md) and [layers overview](./layers.md).

### Alignment Coverage (Stamp)

- Lifecycle: Each stage is covered by at least one kit (e.g., SpecKit/PlanKit for Spec/Plan; AgentKit for Implement; EvalKit/TestKit for Verify; PatchKit for Ship; ObservaKit for Operate; Dockit for Learn).
- Pillars: All four Harmony pillars are reinforced in practice (e.g., Speed with Safety via flags/rollback and CI gates; Quality through Determinism via contracts/tests/observability; Simplicity over Complexity via monolith‑first/vertical slices; Guided Agentic Autonomy via the governed MAPE‑K loop).
- Optional kits extend quality and learning without changing core decisions (e.g., A11yKit for accessibility checks; PostmortemKit for structured incident learning).

### Non‑negotiables satisfied

- Monolith‑first with clear, reversible extraction paths (vertical slices; ports/adapters)
- Contract‑first APIs (OpenAPI/JSON Schema) validated via Pact and Schemathesis in CI
- Hexagonal separation (pure domain inward; adapters outward)
- Trunk‑based development with small PRs, Vercel Previews, and manual promote/rollback
- Simplicity and low cognitive load over premature distribution

## Objectives

- Enable rapid delivery without compromising stability or security.
- Keep the system simple to reason about and operate.
- Make behavior deterministic and reproducible end-to-end.
- Harness AI agents for acceleration within clearly governed boundaries.

### Self‑Improvement (Kaizen/Autopilot) Layer

An in‑repo Kaizen layer runs beside normal development to propose tiny, reversible improvements. It detects opportunities (metrics, gates, traces, docs hygiene), evaluates them against written policy (ASVS/SSDF, risk rubric, change‑type gates), and opens PRs with evidence. Autopilot is limited to Trivial/Low‑risk hygiene (e.g., docs, stale‑flags, span/log scaffolding); Copilot PRs for Medium/High‑risk or behavioral changes always require human approval. Non‑negotiables apply: no direct pushes, no bot approvals, pinned AI configs, and full provenance. See `docs/harmony/architecture/kaizen-subsystem.md` for technical design and operations, and `docs/harmony/architecture/tooling-integration.md` for the workflow wiring.

#### Cross‑Cutting Nature

- Spans all areas/slices: proposes hygiene across docs, tests, observability, contracts, flags, and CI.
- Policy + evidence driven: opens PRs with proof; never ships changes itself.
- Targets quality attributes, not features: governs how we build/run (consistency, safety), not user‑visible behavior.

Boundaries

- Domain logic or UX changes belong to the owning slice; Kaizen may suggest but owners decide.
- Higher‑risk refactors or anything changing runtime semantics escalate to owners (Copilot track + required reviews).
- During incidents/freezes, operate in suggest‑only mode (issues over PRs).

Quick Rubric (Does it fit Autopilot?)

- Small and reversible; evidence‑driven; policyable; does not change runtime semantics.

## Pillars and Design Practices

### Speed with Safety

- Prefer a modular monolith: a single deployable application, logically partitioned into feature modules for fast iteration and low coordination overhead.
- Gate every change with automated tests and human review prior to release.
- Use feature flags to decouple deploy from user release, enabling progressive rollout and instant rollback.
- Employ AI assistance (Planner/Builder/Verifier agents) to accelerate coding and maintenance, with explicit approval checkpoints to prevent unsafe changes.
- Favor trunk-based development with small PRs and preview environments to accelerate feedback while preserving safety through policy gates.

### Simplicity over Complexity

- Adopt a monolith‑first approach with clear internal modularity; avoid premature microservices.
- Organize by vertical slices (feature‑focused folders) rather than strictly layered architecture to localize change and reduce cognitive load.
- Eliminate unnecessary distributed coordination (e.g., cross‑service RPC) for a small team; add distribution only when demanded by scale or boundaries.
- Keep shared tooling thin: maintain ToolKit as a minimal wrapper over deterministic actions; if scope grows, prefer specialized sub‑kits to retain clarity and single purpose.

### Quality through Determinism

- Separate pure domain logic from side effects using Hexagonal Architecture (Ports & Adapters) to make behavior predictable and testable.
- Ensure reproducible builds (locked dependencies, deterministic build steps) and run automated tests on every change.
- Prefer deterministic design choices: stable ordering, time control, functional core, explicit side effects.
- Apply deep testing techniques where useful (simulation, property‑based tests) to surface defects early.
- Define and enforce API/data contracts (OpenAPI/JSON Schema). Add consumer‑provider contract tests (e.g., Pact) and schema‑based fuzzing (e.g., Schemathesis) in CI to detect regressions early.
- Instrument with OpenTelemetry for traces/logs/metrics and link trace IDs to PRs/releases for provenance.
- Treat accessibility as a first‑class quality concern: integrate automated a11y checks into CI and handle violations as policy/evaluation failures. Prefer deterministic, reproducible checks and record evidence/provenance.
- AI determinism: pin provider/model/version, prefer low temperature (≤ 0.3), record prompt hashes and idempotency/cache keys for reproducibility.

### Guided Agentic Autonomy

- Introduce an autonomic improvement loop with AI agents that Plan, Build, and Verify changes under strict governance.
- Keep humans in control of high‑impact decisions via human‑in‑the‑loop (HITL) checkpoints.
- Require provenance and transparency: log agent actions and rationales; require approvals for potentially risky actions.
- Favor fail‑closed behavior: unapproved or failing changes never reach production.
- Establish a thin control plane (flags, policies, contracts, observability) so agents operate within guardrails and achieve deterministic outcomes.

## Architecture Summary

HSP pairs a Modular Monolith with Vertical Slices and an AI‑driven MAPE‑K loop.

### Modular Monolith with Vertical Slices

- Single repository and deployable artifact containing all services and features.
- Feature modules encapsulate end‑to‑end capability (UI, domain logic, data access) for local reasoning and parallel work.
- Internal boundaries follow Hexagonal Architecture to isolate business rules from infrastructure.
- Domain‑Driven Design (DDD) principles define bounded contexts to prevent model drift and “big ball of mud” coupling.
- Enforce internal module boundaries and stable coupling rules to prevent cross‑slice entanglement; design seams to allow reversible extraction when warranted.
  See also: `docs/harmony/architecture/repository-blueprint.md`, `docs/harmony/architecture/monorepo-layout.md`, and `docs/harmony/architecture/feature-unit-taxonomy.md` (non‑normative examples) for structure, boundaries, enforcement details, and illustrative feature mappings.

### Autonomic Loop (MAPE‑K)

MAPE‑K: Monitor → Analyze → Plan → Execute, backed by a shared Knowledge base.

- Planner Agent: analyzes knowledge (requirements, code health, telemetry) and proposes improvements or features.
- Builder Agent: implements proposed changes in a controlled sandbox (branches/PRs).
- Verifier Agent: tests/evaluates against specifications and policies.
- Human Gatekeepers: review and approve at defined checkpoints (e.g., before merge to `main`).
- Fail‑closed posture: only approved, passing changes are eligible to ship.
- Provenance: associate runs, PRs, and releases with trace IDs and run records for auditability.

### Knowledge Plane

- Unified catalog linking specifications, design contracts, test cases, SBOM, traces, and logs.
- Provides traceability and context for developers and agents.
- Enables retrieval‑augmented planning and verification (e.g., align a code fix to its requirement and tests).

### Thin Control Plane

- Responsibilities scoped to governance and safety while remaining lightweight:
  - Flags and progressive rollout with manual promote/rollback.
  - Policy and evaluation gates in CI (align to ASVS/SSDF where applicable).
  - Contract‑first interfaces (OpenAPI/JSON Schema) verified via contract tests.
  - Observability via OpenTelemetry with PR/trace linkage for provenance.

## Development and Release Flow

- Propose change (human or Planner Agent) with traceable rationale tied to specs.
- Implement change in a branch or PR (human or Builder Agent).
- Verify with automated tests and policy checks (Verifier Agent + CI).
- Human review and approval gate; deploy behind feature flags.
- Gradually enable via flags; monitor telemetry; promote rollout on healthy signals.
- Prefer trunk‑based flow with small, reviewable PRs and preview deployments to shorten feedback loops.

## Determinism and Reliability

- Reproducible CI builds with locked dependencies and deterministic steps.
- Deterministic tests; failures indicate real defects, not flukes.
- Avoid flakiness: control time, concurrency, and non‑deterministic IO where feasible.
- Enforce module boundaries and coupling rules to keep vertical slices independent and predictable over time.

## Governance and Safety

- HITL checkpoints for merges, production promotion, and other high‑risk actions.
- Full provenance of agent actions and approvals.
- Feature flags to decouple release from deploy; default to safe rollouts and instant rollback.
- CI policy gates enforce security and quality controls (e.g., alignment with ASVS/SSDF), contract compliance, and observability baselines.

## Team Scope and Scaling

- Designed for 2 developers initially; scales to ~6 with clear module boundaries and automation.
- Emphasizes local reasoning, parallel work on vertical slices, and minimal coordination.

### Evolution Path

- When boundaries strain or scale demands increase, evolve predictably:
  - Extract hot or independently evolving slices behind stable contracts using the Strangler pattern (e.g., to a BFF or Self‑Contained System) while the modulith remains the system of record.
  - Introduce plugin‑style seams for optional capabilities without polluting the domain core.
  - For scale or tenancy isolation, adopt cell‑style boundaries (per tenant/region) while preserving repo cohesion.
  - Only if necessary, split into services with unchanged external contracts and CI policy gates once boundaries are proven.

## Deliverables (Roadmap)

- Comparative analysis of alternative paradigms and trade‑offs.
- Repository structure blueprint (`repo_structure.json`).
- Detailed MAPE‑K loop design and guardrails.
- Knowledge Plane data model and workflows.
- Agent roles, HITL governance model, and risk controls.
- Continuous improvement (Kaizen) subsystem.
- Operational policies and failure‑mode analysis.
- Scoring rubric and risk analysis supporting HSP adoption.

This blueprint is intended to be immediately actionable for a small team and to scale with the team and product as they grow, maintaining speed with safety and clarity.
