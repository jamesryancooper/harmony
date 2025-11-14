---
title: Structural Repository Blueprint and Module Boundaries
description: Canonical repo layout, module boundaries, and contracts for a vertically sliced, modular monolith with a thin control plane.
---

# Structural Repository Blueprint and Module Boundaries

Related docs: [overview](./overview.md), [monorepo layout](./monorepo-layout.md), [tooling integration](./tooling-integration.md)

This document specifies the repository layout, module boundaries, and inter-component contracts for a vertically sliced, modular monolith. Harmony standardizes on an `apps/*` + `packages/*` layout. It aims to maximize clarity for a small team while preserving encapsulation and determinism, enabling safe evolution toward more distributed architectures if warranted.

## Objectives

- Provide a clear, navigable repository structure.
- Enforce strict module boundaries with published interfaces and events.
- Maintain determinism and testability within a single deployable unit.
- Enable straightforward scaling and a future path to service extraction.

## High-Level Structure

Organize by feature (vertical slice) in `packages/*`; enforce hexagonal (ports/adapters) boundaries within each feature. Keep shared code minimal and establish explicit apps (thin adapters), platform, agents, CI, and docs areas. A thin control plane (flags, policy, contracts, observability) lives in-repo as libraries and CI gates, not as a separate runtime.

```plaintext
.
├── apps/                     # Deployables (thin adapters: UI/BFF/API)
│   ├── ai-console/
│   ├── api/
│   └── web/
│
├── packages/                 # Feature modules (bounded contexts)
│   ├── <feature>/            # Single workspace package per feature
│   │   ├── domain/           # Core business logic (use cases, entities)
│   │   ├── adapters/         # Outbound adapters (DB, external services)
│   │   ├── api/              # Inbound contracts/interfaces (OpenAPI/JSON Schema)
│   │   └── tests/            # Unit & integration tests for this feature
│   └── common/               # Cross-cutting primitives
│       ├── util/
│       └── models/
│
│   # Centralized contract and control-plane libraries (optional but recommended)
│   ├── contracts/            # Central JSON Schema/OpenAPI; re-export slice contracts
│   └── kits/                 # Control-plane libs (observability, flags, policy, eval, test, patch)
│
├── kaizen/                   # Kaizen/Autopilot layer (policies, evaluators, agents, reports)
│   ├── policies/
│   ├── evaluators/
│   ├── codemods/
│   ├── agents/
│   └── reports/
│
├── platform/                 # Cross-cutting platform services
│   ├── knowledge-plane/      # Specs, traces, SBOM, policies, data catalog
│   ├── observability/        # Logging, metrics, tracing, instrumentation (OpenTelemetry)
│   └── runtime/              # Feature flags, global policies, rollout rules (manual promote/rollback)
│
├── agents/                   # Agent system: planner, builder, verifier
│   ├── planner/
│   ├── builder/
│   └── verifier/
│
├── ci-pipeline/              # CI/CD workflows and policy gates
│   ├── workflows/
│   └── gates/
│
├── .github/
│   └── workflows/
│       └── kaizen.yaml       # Scheduled & on-demand Kaizen jobs (docs/flags hygiene)
│
└── docs/                     # Architecture docs, ADRs, handbooks, guides
```

Supporting artifact:

- `repo_structure.json`: machine-readable structure for tools and agents.

## Feature Modules

Each feature in `packages/<feature>` is a bounded context that encapsulates its domain, interface, infrastructure, and tests. Within a feature package:

- `domain/` is the inner hexagon; it never depends on `api/` or `adapters/`.
- `api/` and `adapters/` act as adapters. They depend inward on `domain/`.
- `tests/` co-locates unit, integration, and contract tests with the feature code.
 - Optional: co-locate a brief spec (`docs/spec.md`) and slice-level JSON Schemas; re-export externally via `packages/contracts` for uniform CI contract testing.

Hexagonal Architecture and dependency direction ensure deterministic, testable modules. The domain core is technology-agnostic and stable; adapters can change with minimal ripple.

Example flow (InventoryManagement):

- `apps/api` receives `PUT /inventory/stock` (controller).
- Controller invokes `packages/inventory/domain` use case which executes business rules.
- Persistence via `packages/inventory/adapters/SqlInventoryRepository`.
- `packages/inventory/tests` contains unit tests for rules and integration tests for the slice.

## Shared Code: `common/`

Use `packages/common/*` only for genuinely cross-cutting utilities or shared primitives (e.g., value objects like `Money`, date helpers). Keep it small to avoid accidental coupling. Treat it like any other module with explicit APIs.

## Platform Services: `platform/`

- `knowledge-plane/`: Manages specifications, traces, SBOM, policies, and data catalogs. Serves as a knowledge hub for humans and agents.
- `observability/`: Centralizes logging, metrics, tracing, and instrumentation standards. Ensures consistent trace context propagation.
- `runtime/`: Hosts feature flag definitions and rollout policies. Can include global middleware and rate limiting.

## Agent System: `agents/`

Houses Planner, Builder, and Verifier agents. Keep agent logic and resources (prompts, rules) separate from product features to simplify governance and auditing. Shared agent utilities can live under `agents/common/` if needed.

## CI/CD and Policy: `ci-pipeline/`

- `workflows/`: Build, test, and deploy pipelines (e.g., GitHub Actions).
- `gates/`: Quality gates and policy enforcement (linting, coverage, security scans, architecture checks).

Version all CI configuration in-repo to enable reviewability and repeatability.

## Workflow Defaults

- Trunk-based development with small, reviewable PRs.
- Every PR produces a Vercel Preview deployment for human and automated verification.
- Manual promote/rollback is the default; progressive delivery guarded by feature flags.
- Contract-first checks (Pact/Schemathesis) and observability baselines (OTel) are required preconditions to merge/deploy, with PR ↔ build ↔ trace correlation recorded.

## Documentation: `docs/`

Keep architecture docs, ADRs, and handbooks alongside the code. Use them to feed the Knowledge Plane and guide both developers and agents.

## Module Boundaries and Contracts

Strictly enforce boundaries to preserve encapsulation, maintainability, and future extractability.

- No direct cross-module access: A module must not reach into another module’s internals or data stores.
- Published interfaces only: Modules expose a small, stable API surface (service classes or functions) for others to call.
- Clear data ownership: Each module owns its data schema and is the sole writer. Reads go through the owner’s interface or sanctioned data products.
- Communication patterns:
  - Synchronous calls use published interfaces (in-process, via DI).
  - Asynchronous events are emitted on an in-process event bus; schemas are documented.
- Dependency injection: Resolve cross-module references via interfaces; avoid concrete type coupling.

Contracts include method signatures, DTOs, and event schemas. For external HTTP ports, specify OpenAPI/JSON Schema and validate via consumer-driven contract tests (e.g., Pact) and negative/fuzz testing (e.g., Schemathesis) in CI. Version and document all contracts. Store interface docs and event catalogs in the Knowledge Plane for discoverability and provenance.

## Contract Examples

Function call (Orders → Inventory):

```ts
interface InventoryService {
  ReserveStock(productId: string, qty: number): boolean;
}
```

- Behavior: Return `true` if stock reserved; `false` if unavailable.
- Consumer responsibility: Abort order creation when `false`.
- Knowledge Plane: Link interface, invariants, and tests validating expected behavior.

Event (Billing → Subscribers):

```json
{
  "event": "PaymentCompleted",
  "userId": "<uuid>",
  "orderId": "<uuid>",
  "amount": 123.45
}
```

- Semantics: Fire-and-forget; idempotent handlers recommended.
- Subscribers: Orders (mark paid), Analytics (revenue).
- Versioning: Additive changes preferred; use versioned names if breaking.

Data product via Knowledge Plane (Analytics):

- Example: `analytics_summary` dataset published daily for reporting.
- Purpose: Decouple analytical queries from feature database schemas.

## Safeguards and Enforcement

Use multiple levels of enforcement to sustain architectural integrity:

- Static analysis and architecture tests (e.g., ArchUnit-like rules) to forbid disallowed imports or references.
- Example tooling: in JS/TS monorepos with Turborepo, enforce slice/boundary rules using ESLint (`eslint-plugin-boundaries`, `no-restricted-imports`) and `dependency-cruiser` (CI task in the Turbo pipeline). In JVM stacks, Spring Modulith provides similar checks. Choice of tool is an implementation detail; the architectural rule is invariant.
- Next.js runtime guardrails (Edge vs Node): codify a CI lint/check to prevent accidental heavy/AI/IO work in Edge runtimes. Enforce that Edge routes/actions only perform read‑mostly, low‑latency work and forbid usage of flagged modules/patterns (e.g., long CPU tasks, large model calls, filesystem/network patterns that exceed Edge constraints). Implement via ESLint custom rule(s) plus static detectors in CI.
- Code review standards: Require cross-module calls to use published interfaces or events.
- Contracts as code: Interface docs, consumer-driven contract tests, and invariants validated in CI.

## Observability and Determinism

- Propagate trace context across module calls and events for diagnosability (OpenTelemetry). Link trace IDs to PRs/builds for auditability.
- Design for deterministic behavior; tests should be reliable and fast.
- Capture module dependencies and event flows in the Knowledge Plane to aid humans and agents.

## Control Plane Responsibilities (Thin)

- Feature flags and progressive rollout defaults; manual promote/rollback.
- Policy/evaluation gates in CI that enforce architectural rules and risk thresholds (align with ASVS/SSDF where applicable).
- Contract-first validation (OpenAPI/JSON Schema) with Pact/Schemathesis checks.
- Observability baselines and trace linking to PRs/releases.

These controls live as repo-local libraries, workflows, and checks to keep the monolith simple while enabling guided autonomy and safety.

Kaizen touchpoints: the `kaizen/` area hosts policies/evaluators/agents and produces PRs with evidence; `.github/workflows/kaizen.yaml` schedules and runs safe hygiene jobs under normal branch protections and HITL review.

Ownership patterns (cross‑cutting Kaizen):

- CODEOWNERS: `/kaizen/**` → platform/quality.
- Allow Kaizen PRs to touch `docs/**`, `.github/**`, `infra/**`, and per‑slice scaffolds (read‑only suggest/PR); owners review and merge.

## Blueprint Visualization (Textual)

- Feature A (e.g., Billing)
  - Domain, API, Infra, Tests
  - Exports: `BillingService`, event `InvoiceGenerated`
- Feature B (e.g., Inventory)
  - Domain, API, Infra, Tests
  - Exports: `InventoryService`, event `StockLow`
- Feature C (e.g., Orders)
  - Depends on `InventoryService` via DI; emits `OrderPlaced`; handles `PaymentCompleted`
- common/: Shared primitives and utilities
- platform/: Knowledge Plane, Observability, Runtime
- agents/: Planner, Builder, Verifier
- ci-pipeline/: Workflows, Gates (including architecture checks)

## Failure Modes and Mitigations

- Boundary violations: Detect via architecture tests and enforce in review.
- Contract mismatch: Document interfaces; validate with consumer-driven tests and runtime assertions.
- Integration failures: Handle exceptions at boundaries; use global error handling and observability.
- Monolith scaling: Prefer async processing and simple vertical scaling; extract services selectively only when warranted by scale or isolation needs.

## Evolution Path

The modular monolith design intentionally preserves an option to extract services later. Because modules interact only via interfaces or events and own their data, extraction is feasible without large refactors. Do not prematurely distribute; evolve when justified by operational or organizational needs.

- For tenancy/scale isolation, consider cell‑style boundaries (per tenant/region deployments) that replicate the same slice layout behind stable contracts while preserving repo cohesion and shared policy/observability.

## Agent Enablement

The consistent structure makes it easy for agents to:

- Locate relevant features and cross‑cutting layers for changes.
- Map specifications in the Knowledge Plane to code and tests.
- Diagnose failures by correlating test paths (e.g., `services/<Feature>/tests/...`) with feature ownership.

## Summary

This blueprint defines a vertically sliced, hexagonal-structured monolith with explicit module contracts and strong enforcement. It optimizes for clarity, determinism, and safe evolution, supporting both developer productivity and agent autonomy.
