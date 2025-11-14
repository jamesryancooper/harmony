---
title: Domain Modeling Guide
description: Applying DDD within Harmony’s modulith — bounded contexts, aggregates, invariants, events, and transaction boundaries.
---

# Domain Modeling Guide

Status: Draft stub (capture product domain choices)

## Two‑Dev Scope

- Architectural simplicity: avoid event sourcing/CQRS and distributed transactions. Keep a single primary datastore per slice.
- Events: use in‑process domain events only; postpone buses/streams until scale demands.
- Boundaries: prefer a small number of aggregates with clear invariants; keep cross‑context calls minimal and synchronous.
- Multitenancy: choose one model (typically pooled) and document it; avoid complex isolation patterns until justified.

## Pillars Alignment

- Speed with Safety: Vertical slices and bounded contexts reduce blast radius, enabling small, reversible changes with clear ownership.
- Simplicity over Complexity: Prefer a modular monolith and in‑process domain events before adding infrastructure or choreography.
- Quality through Determinism: Explicit invariants and contracts (DTOs/schemas) make behavior testable and reproducible across adapters.
- Guided Agentic Autonomy: Agents can scaffold ports/adapters from contracts; humans verify invariants and approve domain changes.

See `docs/harmony/methodology/README.md` for Harmony’s four pillars.

## Scope

- Structure slices as bounded contexts; keep domain pure; adapters implement ports.

## Core Guidance

- Aggregates: define invariants and transaction boundaries; avoid chatty cross‑aggregate calls.
- Events: use explicit domain events for cross‑context interactions where useful; prefer simple in‑process publication initially.
- Data ownership: a slice owns its schema; share via contracts/DTOs.
- Multitenancy: choose model (pooled/partitioned) and document per slice.

## Enforcement

- Enforce boundaries via lint/dependency checks; see repository blueprint.

## Related Docs

- Comparative landscape: `docs/harmony/architecture/comparative-landscape.md`
- Repository blueprint: `docs/harmony/architecture/repository-blueprint.md`
- Overview: `docs/harmony/architecture/overview.md`
- Methodology overview: `docs/harmony/methodology/README.md`
- Implementation guide: `docs/harmony/methodology/implementation-guide.md`
- Layers model: `docs/harmony/methodology/layers.md`
- Improve layer: `docs/harmony/methodology/improve-layer.md`
- Slices vs layers: `docs/harmony/architecture/slices-vs-layers.md`
