---
title: Migration Playbook (30/60/90)
description: Phased adoption path to HSP with monorepo layout, contracts, observability, flags, and CI control-plane gates.
---

# Migration Playbook (30/60/90)

This playbook provides a concise, phased path to adopt the Harmony Structural Paradigm (HSP) as a modular monolith with vertical slices, contract-first interfaces, a thin control plane, and manual promote/instant rollback. It aligns with existing guidance and remains provider‑agnostic.

Related docs: [overview](./overview.md), [monorepo layout](./monorepo-layout.md), [repository blueprint](./repository-blueprint.md), [governance model](./governance-model.md), [runtime policy](./runtime-policy.md), [observability requirements](./observability-requirements.md), [tooling integration](./tooling-integration.md), [kaizen subsystem](./kaizen-subsystem.md), [knowledge plane](./knowledge-plane.md)

## Scope & Assumptions

- Team size: starts at 2, scales to ~6.
- Monorepo layout `apps/* + packages/*` with feature slices; optional Knowledge/Observability/Runtime folders.
- Tech choices are illustrative; follow contracts and patterns regardless of stack.

References for details: monorepo layout, repository blueprint, runtime policy, observability, tooling integration, governance, kaizen loop, and knowledge plane.

## Day 0–30 — Foundation

Outcomes

- Repository structure in place; first feature slice created end‑to‑end.
- Observability bootstrap wired; feature flag provider registered with defaults OFF.
- Contract‑first posture established; basic CI running.

Checklist

- Repo structure
  - Create canonical layout per monorepo guidance; add `apps/ai-console`, `apps/api`, `apps/web` as applicable.
  - Under `packages/<feature>/`, add `domain/`, `adapters/`, `api/`, `tests/`, and `docs/spec.md` (brief slice spec: scope, acceptance, contracts, risk/flag plan).
- Contracts first
  - Centralize JSON Schema/OpenAPI in slice `api/` (and optionally re‑export via `packages/contracts`).
  - Add initial contract tests in CI: consumer/provider contracts and negative/fuzz tests for public HTTP APIs.
  - Use SpecKit and PlanKit to capture specs and break down work (BMAD); link specs and plans to contracts.
- Observability bootstrap
  - Initialize OpenTelemetry for logs/metrics/traces; propagate W3C trace context.
  - Correlate `trace_id` with CI/PR annotations for provenance.
  - Enforce redaction baseline (no PII/PHI in logs/spans).
- Accessibility baseline
  - Enable automated accessibility checks for any user‑facing surfaces; start with CI linting/scans and add targeted tests for critical flows. Treat violations as policy/evaluation failures.
  - Optional: use `docs/harmony/architecture/a11ykit.md` to centralize CI accessibility checks and surface results as policy/evaluation gates with Knowledge Plane provenance.
- Feature flags
  - Register a server‑side flags provider. Default new flags OFF; fail‑closed on resolution errors.
  - Guard risky/new paths behind flags; add a kill switch for any new integration.
- Caching posture
  - Default dynamic reads to `no-store`. When enabling caches, use explicit keys/TTL and add tests/validation.
- Deploy flow
  - Enable preview deployments for `apps/*`. Keep production promotion manual with a rehearsed instant rollback path.
  - Adopt PatchKit for small, well‑formed PRs and NotifyKit for lightweight approvals/notifications (Slack/email) to reinforce HITL checkpoints.
 - Knowledge and retrieval (optional on Day 1)
  - If helpful for developers, stand up QueryKit + IndexKit over first‑party docs/specs for cited Q&A; defer SearchKit (external sources) until needed.
 - Documentation
  - Introduce Dockit early to generate ADR stubs and keep docs synchronized with changes.

Deliverables

- Skeleton feature slice with spec, contracts, and tests.
- CI with build/test + minimal contract checks; preview deployments enabled.
- Observability baseline (trace propagation and PR correlation).

## Day 31–60 — Control Plane & Governance

Outcomes

- CI acts as the control plane with fail‑closed gates.
- PR template enforces risk/rollback/provenance fields.
- Kaizen loop established with Knowledge Plane correlation.

Checklist

- CI/CD gates (fail‑closed)
  - Build/Test gates green on protected branches.
  - Static analysis: add CodeQL/Semgrep (or equivalents); treat new high findings as errors.
  - Security: SBOM/license and secrets scanning; block on new critical issues.
  - Contracts: run consumer/provider contracts and schema‑based negative/fuzz tests in CI; block merges on failures unless waived.
  - Coverage/perf: set thresholds and report regressions.
  - Accessibility: require a baseline a11y gate for key pages/components; track regressions and allow scoped waivers per governance only when justified.
- PR template & provenance
  - Require: Risk class, rollback plan, `trace_id`, contracts changed (with links), and flags plan.
  - Auto‑annotate PRs with `{build_id, commit_sha, pr_number, trace_context}`.
- Knowledge Plane linkage
  - Ingest CI results, coverage, deployments, and observability summaries; maintain PR↔Build↔Deploy↔Trace correlation.
- Kaizen subsystem
  - Establish a weekly Plan→Agent→Verify→PR cadence for small improvements; require DORA non‑regression for merges.
  - Scaffold `kaizen/` with `policies/`, `evaluators/`, `codemods/`, `agents/`, and `reports/`; add `.github/workflows/kaizen.yaml` with docs/flags hygiene jobs.
  - Autopilot tasks: docs hygiene (lint/links/titles), stale‑flag diff PRs, observability span/log scaffolding on changed paths.
  - Copilot tasks (review required): contract drift fixes (OpenAPI/JSON Schema via `oasdiff`), perf budget nudges with budget evidence, targeted threat‑model test PRs.
- Rollout/rollback drills
  - Practice manual promote and instant rollback; document runbooks.
 - Scheduling and ops
  - Introduce ScheduleKit for periodic/background jobs (e.g., nightly index rebuilds, SBOM sync) with deterministic behavior and observability.

Deliverables

- Branch protection + required checks; PR template live.
- Knowledge Plane correlation endpoints populated from CI/CD.
- Kaizen pipeline operating on a fixed cadence.

## Day 61–90 — Evolution & Hardening

Outcomes

- Event seams where appropriate; flags cleaned up; dashboards and alerts matured.
- Clear criteria for extraction paths (only if justified by boundaries and SLOs).

Checklist

- Domain events & seams
  - Introduce internal events where they reduce coupling; keep handlers idempotent.
  - Document event contracts; link to tests and consumers.
- Reliability and SLOs
  - Define SLIs (latency, error rate, availability) and p95/p99 budgets for key flows; wire canary metrics and gating rules. Track trends with BenchKit and surface regressions in CI dashboards.
  - Add auto‑rollback triggers based on error/latency thresholds.
  - Establish a lightweight, structured postmortem process (blameless) for material incidents; capture findings/actions in ADRs and the Knowledge Plane. Prefer checklists and templates for consistency. Optionally introduce a PostmortemKit to standardize templates and KP updates when incident volume warrants additional structure.
- Extraction evaluation
  - If a slice hits autonomy/SLO/team boundary pressure, evaluate extraction to a BFF or Self‑Contained System while preserving domain ports/contracts.
  - Keep modulith as system of record until boundaries are stable.
- Cleanup & governance
  - Retire stale flags; archive temporary toggles.
  - Record decisions/ADRs for material changes.
- Observability maturity
  - Finalize dashboards and alerts; ensure PR/promote/rollback events are captured for timelines.
  - Introduce focused performance benchmarking only when justified by product needs; prefer a lightweight BenchKit approach. Avoid premature perf frameworks in the first 60 days.
 - UI surfaces for approvals/search are optional; rely on PRs/CLI/Slack early. Consider a UIKit only when HITL workflows outgrow existing channels.
 - Localization and seeding (optional)
   - Introduce i18nKit for localization workflows and SeedKit for deterministic seed data only when product needs justify them; keep disabled by default for small teams.
 - Compliance and models
   - Enable ComplianceKit to assemble evidence packs (tests, policy checks, trace links) for each PR/release.
   - Adopt ModelKit to document and gate approved models/prompts in production; record prompt hashes and model versions for determinism.
 - Refactors and dependencies
   - Use CodeModKit for larger, mechanical refactors and DepKit to automate safe dependency upgrades behind the same CI gates.

Deliverables

- Evented seams (where justified), SLOs with alerts, runbooks updated.
- ADR(s) documenting any boundary/extraction decisions.

## Success Metrics

- Deployment: small PRs with previews; manual promote; rehearsed rollback.
- Quality: contract test pass rates; test flake rate trending down; zero PII in logs.
- Flow: DORA non‑regression week‑over‑week.
- Governance: waivers rare, scoped, and auto‑expiring; required PR fields present.

---

## Appendix — One‑Week Quick Start (2‑person team)

This condensed track jump‑starts the first slice in one week. It aligns with the broader 30/60/90 plan above.

Day 1–2

- Create structure: adopt the canonical `apps/* + packages/*` layout; add `packages/{features,domain,adapters,contracts,kits,ui}`, `infra/{ci,otel}`, and `docs/{architecture,specs,policy}`.
- Bootstrap observability: add `infra/otel/instrumentation.ts`; propagate W3C trace context; ensure `trace_id` appears in PR annotations.
- Flags: register the server‑side flags provider in `apps/ai-console/instrumentation.ts` and `apps/api/src/server.ts`; default new flags OFF and fail‑closed.

Day 3

- Contracts first: centralize OpenAPI/JSON Schema in `packages/contracts` (or slice `api/`) and enable basic contract tests in CI (Schemathesis + Pact where applicable).
 - Tooling plane: scaffold minimal kits (`observakit`, `flagkit`, `policykit`, `evalkit`, `testkit`, `patchkit`) as stubs; wire spans and PR correlation.
 - Optional: add an `a11ykit` (or CI‑native equivalent) to centralize accessibility checks when UI surfaces are present.

Day 4

- Slice a feature: create `packages/features/<slice>/{domain,adapters,ui,tests,docs/spec.md}`; call domain via Ports; adapters implement Ports; keep UI controllers thin (Server Actions/route handlers).
- Caching: keep dynamic paths `no-store` by default; enable caching only with explicit keys/TTL and tests.

Day 5

- CI as control plane: enable fail‑closed gates (build/test, static analysis, SBOM/secrets/license, contract tests, Policy/Eval/Test). Add PR template fields (risk, `trace_id`, contract diffs, flags/rollback plan).
- Promote and rollback: use Preview deployments → manual promote; rehearse instant rollback.

## Risks & Mitigations

- Flaky tests slow adoption → prioritize stabilization and parallelize suites; add retries only where justified.
- Over‑caching causes nondeterminism → keep no‑store defaults; add tests/observability before enabling caches.
- Flag sprawl → enforce removal policy (e.g., retire flags older than 90 days unless justified).
- Tooling lock‑in → keep provider‑agnostic contracts; swap providers behind adapters.
- ToolKit over‑scoping → keep ToolKit a thin wrapper over deterministic actions; if custom logic grows, split into specialized sub‑kits (e.g., HTTPKit) to maintain clarity and single‑purpose focus.

## Cross‑References

- Monorepo Layout: `docs/harmony/architecture/monorepo-layout.md`
- Repository Blueprint: `docs/harmony/architecture/repository-blueprint.md`
- Runtime Policy: `docs/harmony/architecture/runtime-policy.md`
- Observability Requirements: `docs/harmony/architecture/observability-requirements.md`
- Tooling Integration: `docs/harmony/architecture/tooling-integration.md`
- Governance Model: `docs/harmony/architecture/governance-model.md`
- Kaizen Subsystem: `docs/harmony/architecture/kaizen-subsystem.md`
- Knowledge Plane: `docs/harmony/architecture/knowledge-plane.md`
