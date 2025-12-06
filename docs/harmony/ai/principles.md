---
title: Harmony Principles
description: Concise, actionable principles that codify Harmony’s defaults — pillars, core/agentic principles, anti‑principles, and guardrails that guide everyday decisions.
---

# Harmony Principles

Status: Draft stub (confirm team‑specific thresholds and examples)

## Two‑Dev Scope

Default to the smallest viable process, design, and tooling that enforces the principles without burden. Prefer repo‑wide defaults, lightweight reviews, and short‑lived branches; escalate ceremony only for High‑risk changes.

## Pillars Alignment

This document codifies Harmony’s five pillars and how they translate into day‑to‑day decisions. For deeper operational mapping and examples across the lifecycle, see `docs/harmony/methodology/README.md`.

## Purpose

- Provide a compact, quotable set of principles that guide design and delivery.
- Connect day‑to‑day decisions to the five pillars and governance model.
- Keep choices simple, deterministic, testable, and reversible.

## Pillars (non‑negotiable)

1) Speed with Safety — ship small, reversible changes behind flags; practice promote/rollback.
2) Simplicity over Complexity — prefer a modular monolith with vertical slices and hexagonal boundaries.
3) Quality through Determinism — contract‑first, typed boundaries, measurable gates, reproducible outcomes.
4) Guided Agentic Autonomy — agents operate within deterministic, observable, reversible bounds with HITL.
5) Evolvable Modularity — contract‑driven Hexagonal boundaries and a modular monolith keep capabilities loosely coupled and tech choices reversible, so edges (databases, models, providers, surfaces) can be swapped, scaled, or retired as plug‑and‑play adapters when new technologies arrive instead of forcing rewrites.

## Core Principles

- Monolith‑first modulith: organize by vertical feature slices; keep domain pure; adapters implement ports.
- Contract‑first: define OpenAPI/JSON Schema up front; run Pact + Schemathesis in CI; avoid breaking changes.
- Small diffs, trunk‑based: short‑lived branches, tiny PRs, preview deploys, fast review.
- Flags by default: decouple deploy from release; default OFF; fail‑closed on resolution errors; clean up stale flags.
- Determinism: pin versions and AI configs; require idempotency keys for mutating operations; avoid non‑deterministic IO in tests.
- Observability as a contract: structured logs, distributed traces, and metrics with PR/build/trace correlation in the Knowledge Plane.
- Security & privacy baseline: least privilege; secrets via VaultKit only; GuardKit redaction at write boundaries; no PII/PHI in logs/traces.
- Accessibility baseline: run automated a11y checks in CI; treat failures as evaluation/policy violations.
- Documentation is code: spec‑first one‑pagers; ADRs for significant decisions; link artifacts in KP.
- Reversibility: expand/contract migrations; feature kill‑switches; rehearsed rollback.
- Ownership & boundaries: CODEOWNERS per slice; enforce import/architecture rules in CI.
- Learn continuously: blameless postmortems; Kaizen proposes tiny, evidence‑based improvements.

## Agentic Principles (AI‑Toolkit alignment)

- No silent apply: standard loop is Plan → Diff → Explain → Test; humans approve material changes.
- Determinism & provenance: pin provider/model/version; low temperature; record prompt hashes and parameters; capture run/trace IDs.
- Idempotency: all mutating kit calls accept and honor `idempotency_key`.
- Guardrails: agents respect policy and boundaries; produce evidence (plans, diffs, tests, reports) for review.
- HITL checkpoints: bots can open PRs; they never self‑approve or push to protected branches.

## Anti‑Principles (what we avoid)

- Early microservices or choreography that increases complexity without clear, measured need.
- Long‑lived branches, big‑bang PRs, or merges without green gates.
- Flaky tests and unbounded retries; non‑deterministic builds.
- Leaking secrets/PII into logs/traces or external services.
- Heavy/long‑running logic at the Edge; keep correctness paths on server runtimes.
- Implicit cross‑slice coupling and “reach‑in” imports across boundaries.

## Defaults and Guardrails

- Release posture: manual promote to production; instant rollback by re‑promote prior preview.
- Risk rubric: scale reviewers/tests by risk; two‑person rule for high‑risk (auth/payments/core flows).
- Waivers: time‑boxed, documented, and auditable with follow‑ups.
- Coverage & budgets: set thresholds per repo/slice; treat regressions as policy failures unless waived.
- API behavior: stable error envelope; pagination strategy is repo‑wide; timeouts and bounded retries.

## How To Use These

- Reference in PR templates and design notes; cite specific principles when making trade‑offs.
- When a principle conflicts, favor the five pillars and governance safety.
- If you need an exception, file a short waiver per governance and set an expiry.

## Related Docs

- Methodology overview: `docs/harmony/methodology/README.md`
- Architecture overview: `docs/harmony/architecture/overview.md`
- Governance model: `docs/harmony/architecture/governance-model.md`
- Runtime policy: `docs/harmony/architecture/runtime-policy.md`
- Observability requirements: `docs/harmony/architecture/observability-requirements.md`
- Knowledge Plane: `docs/harmony/architecture/knowledge-plane.md`
- API guidelines: `docs/harmony/api-design-guidelines.md`
- ADR policy: `docs/harmony/adr-policy.md`
- Implementation guide: `docs/harmony/methodology/implementation-guide.md`
- Layers model: `docs/harmony/methodology/layers.md`
- Improve layer: `docs/harmony/methodology/improve-layer.md`
- Slices vs layers: `docs/harmony/architecture/slices-vs-layers.md`
- Repository blueprint: `docs/harmony/architecture/repository-blueprint.md`
