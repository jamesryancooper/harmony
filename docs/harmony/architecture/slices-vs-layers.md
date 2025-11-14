---
title: Terminology — Slices vs Layers
description: Clarifies that runtime code is organized by vertical feature slices; “layers” refers only to cross-cutting governance/control planes.
---

# Terminology: Slices vs Layers

- Runtime code is organized by vertical feature slices with hexagonal (ports/adapters) boundaries. We do not use classic n‑tier layering for application calls.
- “Layer” refers to cross‑cutting governance/control‑plane concerns (e.g., Kaizen, quality gates, observability, security) that span slices.
- Prefer ports/adapters within each slice to keep the domain core technology‑agnostic and testable.

See also: [overview](./overview.md), [layers overview](./layers.md), [monorepo layout](./monorepo-layout.md), and [repository blueprint](./repository-blueprint.md).
