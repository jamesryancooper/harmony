# Sandbox Environments (infra/sandbox)

This directory documents **reference sandbox setups** for running Harmony components (apps, agents, and platform runtimes) together with supporting services such as databases, queues, and observability.

The goals of these sandboxes are to:

- Provide an **easy local and CI experience** for end‑to‑end testing.
- Mirror production topology closely enough to exercise contracts, flags, and runtime behavior.
- Integrate cleanly with the **Sandbox Flow** (`docs/methodology/sandbox-flow.md`) and **Containerization Profile** (`docs/architecture/containerization-profile.md`).

> Note: The exact `docker compose` file names and contents may evolve. This README describes the intended patterns so teams can adjust or extend recipes while remaining aligned with Harmony.

---

## 1. Minimal Dev Sandbox

**Purpose:** Run a minimal but representative Harmony stack locally or in CI for feature and integration testing.

**Typical services:**

- One or more **apps** from `apps/*` (for example, `apps/api`, `apps/ai-console`, or `apps/web`).
- The **platform flow runtime** from `platform/runtimes/flow-runtime/**`.
- **Datastores** (e.g., relational DB, key-value store) as containers or emulators.
- **Queue/bus** (e.g., NATS or Redis) for asynchronous workflows.
- An **OpenTelemetry collector** for traces, logs, and metrics.

**Usage pattern (example):**

- A `dev-sandbox.compose.yaml` file defines services for:
  - `api` (image built from `apps/api`).
  - `console` (image built from `apps/ai-console` or `apps/web`).
  - `flow-runtime` (image built from `platform/runtimes/flow-runtime/**`).
  - `db`, `queue`, and `otel-collector`.
- Local or CI commands typically resemble:

  - `docker compose -f infra/sandbox/dev-sandbox.compose.yaml up`

**Alignment with docs:**

- Container boundaries and image conventions follow the **Containerization Profile**.
- This sandbox is a physical realization of the **preview/runtime sandbox** concepts in the **Sandbox Flow**.

---

## 2. Agent Sandpit Sandbox

**Purpose:** Provide a focused environment for **Planner/Builder/Verifier/Orchestrator** agents and Kaizen flows, without requiring full app surfaces.

**Typical services:**

- Selected **agents** from `agents/*` (planner, builder, verifier, orchestrator).
- The **platform flow runtime**.
- Minimal backing services:
  - Datastore(s) needed for agent workflows.
  - Queue/bus if the runtime requires it.
  - OTel collector to capture traces for flows and agent runs.

**Usage pattern (example):**

- An `agent-sandpit.compose.yaml` file defines services for:
  - `planner`, `builder`, `verifier`, `orchestrator`.
  - `flow-runtime`.
  - Supporting infrastructure (DB, queue, OTel).
- Typical commands:

  - `docker compose -f infra/sandbox/agent-sandpit.compose.yaml up`

**Alignment with docs:**

- Agents call platform runtimes via **generated clients and contracts** (`contracts/ts`, `contracts/py`), as described in `runtime-architecture.md` and `monorepo-polyglot.md`.
- This sandbox is especially useful for validating:
  - New flow definitions.
  - Kaizen jobs and evaluators.
  - Agent orchestration flows, before they are exercised via app surfaces.

---

## 3. CI and Knowledge Plane Integration

When used in CI, sandbox compose files SHOULD:

- Be invoked from jobs that:
  - Build images according to the **Containerization Profile**.
  - Run integration, contract, and smoke tests against the sandbox services.
- Emit OTel traces, logs, and metrics that:
  - Include standard attributes (service name, environment, version).
  - Are correlated with CI runs and PRs via trace IDs, as described in `tooling-integration.md` and `knowledge-plane.md`.
- Produce artifacts (test reports, SBOMs, compose logs) that can be attached to PRs or ingested into the Knowledge Plane for audit.

---

## 4. Extending Sandbox Recipes

Teams MAY add or customize compose files to cover additional scenarios, for example:

- Performance or load‑testing sandboxes.
- Multi‑tenant or cell‑style sandboxes that mirror specific deployment cells.
- Specialized sandboxes for experiments (e.g., new runtime families).

When extending recipes:

- Keep image and configuration conventions aligned with the **Containerization Profile**.
- Keep the **Sandbox Flow** in mind: sandbox environments exist to make validation deterministic, auditable, and reversible—not to bypass gates.


