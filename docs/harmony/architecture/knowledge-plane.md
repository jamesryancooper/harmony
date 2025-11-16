---
title: Knowledge Plane
description: Unified, queryable engineering knowledge linking specs, contracts, code, tests, builds, telemetry, SBOM, and provenance.
---

# Knowledge Plane: Linking Specifications, Contracts, Tests, Traces, and SBOM

Related docs: [tooling integration](./tooling-integration.md), [observability requirements](./observability-requirements.md), [governance model](./governance-model.md)

The Knowledge Plane is the unified, queryable body of system knowledge across requirements, design contracts, code artifacts, tests, build outputs, runtime telemetry, and compliance. It provides a single source of truth and end-to-end traceability so that both developers and AI agents can reason about intent versus behavior and drive informed decisions.

## Objectives

- Establish a single source of truth for intended and actual behavior.
- Provide end-to-end traceability from requirements to runtime signals.
- Enable impact analysis for change, risk, and compliance.
- Support agents and humans with fast, reliable queries over linked knowledge.

## Scope

The Knowledge Plane indexes and links the following domains:

- Specifications and policies
- Design contracts and interfaces
- Code modules and build artifacts
- Tests, coverage, and results
- Runtime traces, logs, and metrics
- SBOM components and vulnerability/license posture
- Provenance/history and decision records

## Core Concepts

- Specification (Spec): Statement of behavior, constraints, or policy.
- Contract: Interface definitions (e.g., OpenAPI, module interfaces), schemas, design decisions.
- Code Module: Implementation units that realize specs and contracts.
- Test Case: Unit/integration/e2e tests validating specs and contracts.
- Build Artifact: Outputs from CI/CD (images, packages, reports).
- Trace/Log/Metric: Runtime telemetry for operations and SLOs.
- SBOM Component: Third-party dependency with version/licensing.
- Link/Edge: Typed relationship across entities enabling traceability.

## Data Model and Relationships

Represent relationships in a knowledge graph (e.g., Neo4j/RDF) or equivalent index. Typical nodes and edges:

- Nodes: Spec, Contract, CodeModule, TestCase, BuildArtifact, Trace, Metric, LogEvent, SbomComponent, Policy, ADR, Requirement, PullRequest, PipelineRun, Deployment, FeatureFlagChange.
- Edges (examples):
  - CodeModule IMPLEMENTS Spec
  - TestCase VERIFIES Spec
  - TestCase COVERS CodeModule
  - CodeModule DEPENDS_ON SbomComponent
  - Trace OBSERVES CodeModule
  - Trace VIOLATES Policy
  - ADR INFORMS Contract
  - BuildArtifact PRODUCED_BY CodeModule
  - BuildArtifact ASSOCIATED_WITH PullRequest
  - PipelineRun PRODUCES BuildArtifact
  - PullRequest TRIGGERED PipelineRun
  - Deployment DEPLOYS BuildArtifact
  - Trace CORRELATES_WITH PullRequest
  - Trace CORRELATES_WITH PipelineRun
  - FeatureFlagChange AFFECTS Spec|Feature

Example Cypher query (illustrative):

```cypher
// Find failing tests and their impacted specs and modules
MATCH (t:TestCase {status: 'fail'})-[:VERIFIES]->(s:Spec)
OPTIONAL MATCH (t)-[:COVERS]->(m:CodeModule)
RETURN t.id AS test, s.id AS spec, collect(distinct m.name) AS modules
ORDER BY test;
```

Example (PR ↔ build ↔ trace linking):

```cypher
// Given a PR number, find recent traces produced by its builds/deployments
MATCH (pr:PullRequest {id: $pr})
OPTIONAL MATCH (pr)-[:TRIGGERED]->(run:PipelineRun)-[:PRODUCES]->(b:BuildArtifact)
OPTIONAL MATCH (d:Deployment)-[:DEPLOYS]->(b)
OPTIONAL MATCH (tr1:Trace)-[:CORRELATES_WITH]->(pr)
OPTIONAL MATCH (tr2:Trace)-[:CORRELATES_WITH]->(run)
RETURN pr.id AS pr,
       collect(distinct run.id) AS runs,
       collect(distinct b.name) AS artifacts,
       collect(distinct d.env) AS envs,
       collect(distinct tr1.id) + collect(distinct tr2.id) AS traces
```

## Correlation Storage (Best Determination)

- Source of truth: graph nodes and edges as defined above (PullRequest, PipelineRun, BuildArtifact, Deployment, Trace, FeatureFlagChange).
- Materialized view: maintain a compact `pr_correlation` collection keyed by `pr_number` for fast retrieval via API. Each item stores `build_id(s)`, `trace_context(s)`, artifact links, and latest deployment facts.
- Ingestion: CI posts correlation payloads (PR/build/trace) to `POST /kp/correlation` which updates both the graph and the materialized view; deployments append environment/version edges and update the view.

### API: Correlation Ingestion (Mandatory Schema)

All PR/build ↔ trace correlation payloads MUST conform to the following schema to ensure uniform ingestion and provenance:

Endpoint: `POST /kp/correlation`

Required fields:

- `pr_number` (integer)
- `commit_sha` (string, 7–40 hex chars)
- `repo` (string, `owner/name`)
- `branch` (string)
- `build_id` (string) — CI run identifier
- `run_id` (string) — optional secondary CI id; required if platform provides distinct run and build ids
- `trace_id` (string) — root trace id if available
- `traceparent` (string) — W3C traceparent if available
- `timestamp` (RFC3339 string)

Optional fields:

- `artifact_ids` (array of string)
- `deployment_id` (string)
- `env` (string: dev|staging|prod|…)
- `version` (string) — semver or image digest
- `links` (object) — `{ pr: url, build: url, traces: [url], deployment: url }`

Example payload:

```json
{
  "pr_number": 123,
  "commit_sha": "a1b2c3d4",
  "repo": "harmony/monorepo",
  "branch": "feature/checkout",
  "build_id": "gh-1234567890",
  "run_id": "gh-run-0987654321",
  "trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
  "traceparent": "00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01",
  "timestamp": "2025-11-12T08:30:00Z",
  "artifact_ids": ["web-image@sha256:..."],
  "deployment_id": "vercel-deploy-abc",
  "env": "preview",
  "version": "apps/web@1.2.3",
  "links": {
    "pr": "https://github.com/harmony/monorepo/pull/123",
    "build": "https://github.com/harmony/monorepo/actions/runs/123456",
    "traces": ["https://apm/traces/4bf92..."],
    "deployment": "https://vercel.com/.../deployments/abc"
  }
}
```

Validation:

- Reject payloads missing required fields; respond with 400 and a list of missing/invalid fields.
- Deduplicate by `(pr_number, commit_sha, build_id)`; treat duplicates as idempotent updates.
- Normalize unknown fields (ignored) and coerce `timestamp` to UTC.

## Storage and Ingestion

- Documentation: Markdown in `docs/specs`, `docs/policies`, ADRs, diagrams.
- Contracts: OpenAPI/JSON Schema, interface definitions, DB schemas.
- CI/CD feeds: Test results, coverage reports, build manifests.
- Observability: OpenTelemetry traces/metrics/logs (aggregated/significant events).
- SBOM: SPDX or CycloneDX JSON generated at build time.

Ingestion goals:

- Normalize inputs to entities/edges and update the graph/index.
- Maintain provenance (source, commit, pipeline run, timestamp).
- Support incremental updates on code changes and pipeline runs.

### Retrieval and Ingestion Posture (Pragmatic Adoption)

- Start minimal for small teams: index first‑party specs/contracts/tests and core CI/CD artifacts before introducing external document search or complex pipelines.
- Optional external sources (docs, wikis) should be added only when they materially improve planning/verification; keep ingestion deterministic and auditable.
- Prefer incremental adoption over premature complexity; ensure each new source has clear value and failure handling.
- Maintain a small set of golden Q&A pairs for retrieval quality using DatasetKit; evaluate grounded answers with EvalKit (citation/entailment checks) and track regressions over time.
- Treat new corpora as feature rollouts: gate enablement behind FlagKit and monitor via ObservaKit; default to OFF and fail‑closed.

#### Retrieval Pipeline Kit Boundaries (When Used)

- IngestKit: normalize and ingest first‑party (and optional external) documents into canonical forms with provenance.
- SearchKit (optional): fetch selected external documentation sources; use only when external knowledge materially improves outcomes.
- IndexKit: build and update indexes over ingested content; ensure deterministic rebuilds and versioned snapshots.
- QueryKit: evaluate queries against indexes with deterministic behavior and recorded evidence.
- PromptKit (optional): cross-cutting **prompt template registry and compiler**. Defines template/variable/variant contracts and context slots (e.g., `{retrieved_docs}`) for prompts consumed by AgentKit/FlowKit/QueryKit, but does **not** own retrieval, indexing, or observability. Prompts may live in a shared library (for example `packages/prompts/**`) and are compiled by PromptKit into canonical prompts with `prompt_hash` and metadata.
- Small‑team default: begin with IngestKit + IndexKit over first‑party sources; introduce SearchKit/PromptKit only as needs emerge.
- GuardKit: apply redaction at ingest and emit boundaries (logs/traces) to prevent PII/PHI leakage in grounded answers and evidence packs; never substitute redaction for proper secret handling (see VaultKit).
- ObservaKit: record retrieval operations (sources, doc ids, token counts) at low cardinality for auditability; include a query/run `trace_id` linking to PRs/builds when applicable.
- EvalKit + DatasetKit: evaluate retrieval and answer quality against golden sets; require citations or entailment as configured.
- FlagKit: gate the use of new sources or corpora and roll out gradually with monitoring.

#### LLMOps vs PromptKit in the Knowledge Plane

- **ContextOps (RAG)** in Harmony is the domain of **IngestKit, IndexKit, SearchKit, and QueryKit**: they ingest, normalize, index, and retrieve knowledge with provenance, and they expose deterministic retrieval behavior to agents and flows.
- **PromptKit** sits at the **template boundary** only: it defines how retrieved context is shaped and inserted into prompts (slots and schemas) and compiles those prompts deterministically; it does not make retrieval decisions or manage indexes.
- **LLMOps observability and evaluation** are the responsibility of **ObservaKit (telemetry), EvalKit (LLM evaluation), DatasetKit (goldens), PolicyKit (governance), CacheKit (idempotency/memoization), and ModelKit/CostKit (routing/cost)**. PromptKit supplies prompt-level metadata (`prompt_hash`, template id/version, variant) so these kits can correlate evaluations and runtime behavior back to specific templates.

## Linking Strategy

- Spec ↔ Code: Annotate code/tests with spec IDs (e.g., `// requires: SPEC-001`).
- Tests ↔ Spec: Map tests to the behaviors they verify; capture results and coverage.
- Code ↔ SBOM: Track dependency imports and versions; link to affected modules.
- Observability ↔ Feature/Spec: Propagate feature/module/spec tags in spans/logs.

Example annotations:

```ts
// requires: SPEC-001 (Checkout under 2s)
export function calculateTotalWithTax(...) { /* ... */ }

// verifies: SPEC-001
test('total includes tax', () => { /* ... */ })
```

## Query and Traceability

The Knowledge Plane enables common queries:

- Which tests verify Spec X? Latest status and coverage?
- What specs does Module Y implement? Are all verified?
- If we remove Component Z, what specs/tests/modules are impacted?
- What policies are violated by current traces for Feature F?

Traceability matrix (conceptual) links Spec → Design → Code → Tests → Runtime → Compliance to support impact analysis and audits.

## SBOM Integration

- Generate SBOM in SPDX/CycloneDX at build.
- Ingest into the graph; attach metadata: version, license, usage by modules.
- Monitor vulnerability feeds; mark components affected (e.g., `CVE-2025-12345`).
- Drive Planner actions (e.g., dependency upgrade plans) based on SBOM posture.

## Observability Linking

- Tag spans/logs with `feature`, `module`, `specId` where feasible.
- Promote significant traces (e.g., SLO violations) into the knowledge graph.
- Map trace IDs to high-level operations and the specs/policies they exercise.

## Security and Access Control

- Restrict access to the Knowledge Plane (services/agents/devs with authz).
- Redact or avoid ingesting PII; enforce data minimization for telemetry.
- Treat SBOM and vulnerability posture as sensitive; limit external exposure.

### Redaction vs. Secret Management

- Secrets: retrieval and usage must go through a dedicated secrets manager with audited access; do not embed secrets in KP content.
- Redaction: apply redaction at write boundaries (logs/traces/metrics/doc ingestion) and prefer structured suppression (fields/tags) over ad‑hoc filters.
- Provenance: record that redaction rules were applied (rule/category IDs) without ever emitting the sensitive values.

## Tooling and Integration

- Test reporting: e.g., Allure or similar, augmented with spec links.
- Observability: OpenTelemetry exporters + analytics store.
- Requirements: Markdown/issue trackers with stable IDs; API access for sync.
- Agent API/DSL: Expose a query surface (e.g., `KP.query('spec coverage for Inventory')`).

## Usage by Agents and Team

- Planner: Performs impact analysis; correlates failures to specs/modules; prioritizes SBOM upgrades.
- Builder: Retrieves relevant specs/contracts/examples; updates links after changes.
- Verifier: Ensures spec coverage; detects gaps/flakiness; validates runtime behavior against policies.
- Developers: Use dashboards/reports for coverage, vulnerabilities, and traceability during planning and code review.

## Operational Considerations

- Versioning: Timestamp and version every entity; preserve history.
- Consistency checks: Periodic jobs to flag unlinked specs/tests/modules.
- CI hooks: Update links on PRs; fail checks on policy/coverage regressions.
- Scalability: Start lightweight; plan for growth to thousands of nodes/edges.

## Failure Modes and Mitigations

- Stale or incomplete links → Automate linking in CI; agent-suggested PRs; review checklists.
- Incorrect knowledge → Versioned entries; periodic review; reconcile conflicts with current state.
- Security exposure → Internal-only deployment; least-privilege; avoid raw sensitive data ingestion.

## Alignment with Harmony Principles

- Quality through Determinism: Anchor system behavior in explicit specs, contracts, tests, and policies; surface discrepancies via telemetry and verification.
- Guided Autonomy: Equip agents with authoritative, queryable knowledge to plan, build, and verify changes safely and transparently.
- MAPE‑K: Treat the Knowledge Plane as the shared knowledge base (K) supporting monitor, analyze, plan, and execute loops.

## Retrieval/RAG Adoption Guidance

- Keep the retrieval pipeline minimal by default for small teams. Start with essential ingestion and indexing only; introduce additional components on demand.
- Defer optional capabilities like broad external search until product needs justify them. Favor a simple Ingest → Index → Query path first; add Search (external) only if the app must integrate external knowledge sources.
- Manage prompts close to agent configurations initially; a dedicated prompt‑templating layer (cross‑cutting; see `docs/harmony/architecture/slices-vs-layers.md`) can be added later if prompt complexity or reuse demands it.
- Preserve determinism: record document versions, index parameters, and query options to ensure repeatable planning and verification.

## Appendix

Example developer queries:

```text
1) Which tests validate SPEC-001 and when did they last pass?
2) What specs and policies are associated with module checkout/total.ts?
3) Which modules depend on library X@1.2 and are impacted by CVE-2025-12345?
4) Show traces that violated checkout P95<200ms in the last 24h.
```

Reference: System traceability concepts are described by industry sources such as Edge Delta: <https://edgedelta.com/company/blog/what-is-system-traceability>.
