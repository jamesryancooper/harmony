---
title: Harmony Monorepo Architecture
description: Canonical apps/* + packages/* layout and responsibilities, mapping HSP decisions to workspace conventions.
---

# Harmony Monorepo Architecture

Related docs: [overview](./overview.md), [repository blueprint](./repository-blueprint.md), [slices vs layers](./slices-vs-layers.md)

This document specifies the canonical Harmony Monorepo structure and the responsibilities of each major component. Harmony standardizes on an `apps/*` + `packages/*` workspace layout. This packaging does not change the architectural decisions (vertical slices with hexagonal boundaries); it maps them to workspace conventions for speed and ergonomics.

> Terminology note: “layer” refers to cross‑cutting control/governance planes (e.g., Kaizen, policy gates, observability) that span slices. Runtime code remains organized by vertical feature slices with hexagonal boundaries, not by n‑tier layers. See also: [slices vs layers](./slices-vs-layers.md).

## Directory Topology (Canonical)

```text
HarmonyMonorepo
├─ apps/                     # Deployable applications and UIs (thin adapters)
│  ├─ ai-console             # Next.js app (controllers, server actions)
│  ├─ api                    # HTTP ports (OpenAPI), BFFs, webhooks
│  ├─ ai-gateway (optional)  # Optional Python gateway behind a stable HTTP port
│  └─ web                    # Astro/docs/marketing
├─ packages/                 # Reusable libraries organized by feature slices
│  ├─ <feature>/             # Vertical feature slice (single workspace package)
│  │  ├─ domain              # Pure domain/use-cases (functional core)
│  │  ├─ adapters            # DB/HTTP/cache integrations (outbound adapters)
│  │  ├─ api                 # Inbound API surface (interfaces/contracts)
│  │  ├─ tests               # Unit/integration/contract tests for the slice
│  │  └─ docs/spec.md        # Brief slice spec (scope, contracts, risks)
│  └─ common/                # Cross-cutting helpers and canonical DTOs
│     ├─ util                # Cross-cutting helpers (minimal)
│     └─ models              # Canonical DTOs/value objects
├─ kaizen/                   # Kaizen/Autopilot layer (policies, evaluators, agents, reports)
│  ├─ policies/
│  ├─ evaluators/
│  ├─ codemods/
│  ├─ agents/
│  └─ reports/
├─ platform/
│  ├─ knowledge-plane        # Specs, policies, sbom, traces (authoritative)
│  ├─ observability          # OTel bootstrap, dashboards, rules
│  └─ runtime                # Flags, rollout descriptors, policy hooks
├─ agents/
│  ├─ planner
│  ├─ builder
│  └─ verifier
├─ ci-pipeline/
│  ├─ workflows              # CI pipelines (build/test/scan)
│  └─ gates                  # Policy/contract/coverage gates
├─ .github/
│  └─ workflows/
│     └─ kaizen.yaml         # Scheduled & on-demand Kaizen jobs (docs/flags hygiene)
└─ docs/
```

## Apps (Deployables)

- Purpose: Thin adapters at the system edge (web UI, HTTP/BFFs, CLIs). They orchestrate requests and delegate to feature modules in `packages/*`.
- ai-console/web: Controllers, server actions, and pages should remain thin. Heavy logic belongs in `packages/<feature>/domain`.
- api: Implements HTTP ports for features; references generated contracts in `packages/*` and returns DTOs.
- ai-gateway (optional): If required for specialized AI/runtime workloads, implement as a separate process (e.g., Python) behind a stable HTTP contract so the modulith’s domain and ports remain unchanged.

### Framework Defaults and Runtime Guidance

- Next.js (App Router) controllers are thin; prefer Server Actions only for orchestration. Place heavy or long‑running work behind stable use‑cases in `packages/<feature>/domain`.
- Edge vs Node: use Edge only for read‑mostly and flag evaluation paths; route heavy/AI and IO‑intensive work to Node runtimes.
- Background/scheduled work: prefer `next/after` (or equivalent) to defer non‑critical processing out of request lifecycles.
- Caching: opt‑in with explicit, stable keys. Do not rely on implicit caches for correctness.
- Dynamic reads: default to `no-store` unless proven safe; treat caching as an explicit decision backed by tests and observability.
- Previews: trunk‑based development with small PRs; each PR produces a Vercel Preview deployment for rapid, safe review before promotion.

## Packages (Feature Modules)

- Purpose: Encapsulate product-facing capabilities as vertical slices. Each `packages/<feature>` workspace package contains subfolders for domain, adapters, api, and tests.
- domain: Core business rules/use-cases (pure, technology-agnostic). Depends on nothing outward.
- adapters: Integrations (DB, queues, external APIs) that implement ports; depend inward on domain abstractions.
- api: Public interfaces/contracts for inbound calls (interfaces, OpenAPI/JSON Schema where applicable).
- tests: Feature-specific unit, contract, and integration tests.
 - docs/spec.md: A concise slice spec including scope, acceptance checks, risk/flag plan, and contract references.
 - Boundary validation: Perform request/response validation at module boundaries using JSON Schema; reject invalid inputs explicitly and log with trace context. Guard risky or new flows behind feature flags with safe defaults.

## Common

- **util:** Cross-cutting helpers (e.g., string utilities, date helpers, resilience operators) shared across services. Keep these stateless and dependency-light.
- **models:** Canonical data contracts and DTOs consumed by multiple services. Any change should be reviewed for downstream impact.

## Platform

- **knowledge-plane:** Governs system intelligence assets.
  - **specs:** Formal specifications that capture decision logic and interface contracts.
  - **policies:** Constraint definitions and enforcement logic used by agents and pipelines.
  - **sbom:** Software Bill of Materials snapshots for provenance tracking.
  - **traces:** Observability artifacts feeding the knowledge plane.
- **observability:** Telemetry collectors, alerting rules, and dashboards (OpenTelemetry traces/logs/metrics; PR/trace linkage).
- **runtime:** Execution scaffolding, runtime policies, feature flags, and rollout descriptors that unify service execution environments (manual promote/rollback).

## Agents

- **planner:** Strategic reasoning and backlog refinement logic.
- **builder:** Code-generation or automation tasks responsible for implementing planned work.
- **verifier:** Validation logic, QA harnesses, or autonomous reviewers that guard merge criteria.

## CI Pipeline

- **workflows:** Pipeline definitions (e.g., GitHub Actions, Turborepo tasks) that orchestrate builds, tests, and deployments.
- **gates:** Policy-as-code checks applied to the workflows, such as coverage thresholds, static analysis requirements, contract tests (OpenAPI/JSON Schema with Pact/Schemathesis), and manual approvals.

## Documentation

- **docs:** Source-of-truth documentation, including ADRs, runbooks, and user-facing guides. Mirror structural changes from the monorepo here to keep architectural knowledge discoverable.

## Alternative: Services/* Layout Mapping

For teams that prefer a `services/*` directory, you can map the canonical structure without changing architectural decisions:

- `services/<Feature>/domain` ≈ `packages/<feature>/domain`
- `services/<Feature>/infra` ≈ `packages/<feature>/adapters`
- `services/<Feature>/api` ≈ `packages/<feature>/api`
- `services/<Feature>/tests` ≈ `packages/<feature>/tests`
- Apps correspond to adapters/ports at the system edge and remain thin.

Guideline: keep the domain/runtime boundaries identical regardless of folderization. Enforce boundaries with Turborepo-friendly tooling (e.g., ESLint rules like `eslint-plugin-boundaries`/`no-restricted-imports`, and `dependency-cruiser` checks in CI) so `domain` never depends on `adapters`.

## Optional: Cells for Tenancy/Scale

When scale or isolation requirements arise (e.g., per‑tenant/region deployments), adopt cell‑style boundaries: replicate the same apps/* + packages/* slice per cell behind stable external contracts. Keep repository cohesion and shared policy/observability. See `docs/harmony/architecture/overview.md: Evolution Path` for guidance.
## Kaizen/Autopilot Layer

- Purpose: Continuously propose small, reversible improvements to docs, tests, observability, and guardrails.
- Scope: Autopilot for Trivial/Low risk changes (e.g., docs hygiene, stale‑flag cleanup, span/log scaffolding); Copilot PRs for anything touching runtime behavior or contracts.
- Inputs: CI results, DORA/SRE metrics, OTel traces/logs, risk rubric.
- Outputs: PRs with evidence (plan/diff/tests/trace), weekly reports, and policy updates.
- Safety: No direct pushes or approvals; AI configs pinned; HITL enforced by branch protections and review.

Operational notes:

- Bot identity and labels: use a dedicated bot (e.g., `@repo-improve-bot`) and standard labels (`autopilot`, `copilot`, `needs-owner`, `risk:low|med|high`, `docs`, `observability`, `contracts`, `perf`, `flags`).
- Default schedule: weekdays at 12:00 America/Chicago (18:00 UTC); configurable via workflow `on.schedule`.
- Reviews required: even Autopilot PRs require at least one human review; bots never approve protected branches.
- Non‑negotiables: no direct pushes; pinned/versioned AI configs; evidence artifacts attached to every PR.

- Policy locations: configure risk and gates in `kaizen/policies/risk.yml` and `kaizen/policies/gates.yml`.

Workflow skeleton (GitHub Actions): see `tooling-integration.md` for a sample `kaizen.yaml` job wiring. Governance policy and risk rubric live in `governance-model.md`.

Note: Treat the Kaizen layer as an orthogonal, cross‑cutting control/management plane that watches all slices and proposes reversible hygiene; owners review and merge. Paths referenced as `kaizen/*`.
