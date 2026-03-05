---
title: Architecture and Repository Structure
description: Architecture orientation for Harmony methodology with provider-agnostic policy and canonical references.
owner: "cognition-owner"
audience: internal
scope: methodology-governance
last_reviewed: 2026-03-05
canonical_links:
  - "/AGENTS.md"
  - "/.harmony/agency/governance/CONSTITUTION.md"
  - "/.harmony/agency/governance/DELEGATION.md"
  - "/.harmony/agency/governance/MEMORY.md"
  - "/.harmony/cognition/practices/methodology/authority-crosswalk.md"
---

# Architecture and Repository Structure

This file is a methodology-facing architecture synopsis. Canonical architecture authority remains under `/.harmony/cognition/_meta/architecture/`.

## Canonical Sources

- `/.harmony/cognition/_meta/architecture/overview.md`
- `/.harmony/cognition/_meta/architecture/monorepo-layout.md`
- `/.harmony/cognition/_meta/architecture/repository-blueprint.md`
- `/.harmony/cognition/_meta/architecture/runtime-architecture.md`
- `/.harmony/cognition/_meta/architecture/runtime-policy.md`
- `/.harmony/cognition/_meta/architecture/contracts-registry.md`
- `/.harmony/cognition/_meta/architecture/layers.md`
- `/.harmony/cognition/_meta/architecture/slices-vs-layers.md`
- `/.harmony/cognition/_meta/architecture/governance-model.md`

## Structural Baseline

- Agent-first, system-governed modular monolith.
- Vertical feature slices with explicit ports/adapters boundaries.
- Thin control plane for policy, observability, contracts, and rollout controls.
- Clear separation between runtime surfaces (apps/agents/runtimes) and import surfaces (packages/contracts).

## Flag and Runtime Policy

- Flag resolution must be deterministic, fail-closed, and auditable.
- Evaluate risky behavior server-side and avoid re-implementing policy across runtimes.
- Provider-specific integrations are implementation details, not normative methodology requirements.

## Scaling Guidance (Solo to Small Team)

- Keep WIP small and changes reversible.
- Require explicit review ownership for elevated-risk surfaces.
- Maintain manual promotion authority with rollback-ready posture for high-risk releases.

For implementation details and examples, see stack profiles under `/.harmony/scaffolding/practices/examples/stack-profiles/` as non-normative guidance.
