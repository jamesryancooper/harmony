---
title: Data Handling and Retention
description: Practical guidance for classification, retention/erasure, environment data policies, backups, and encryption.
---

# Data Handling and Retention

Status: Draft stub (fill policy durations and owners)

## Two‑Dev Scope

- Classification: stick to four levels (Public, Internal, Confidential, Restricted). Maintain a single table (owner, systems, flows) per slice.
- Retention: define 2–3 pragmatic durations (e.g., logs, analytics, primary records) and revisit quarterly. Avoid per‑field policies.
- Non‑prod data: do not copy prod data. If an exception is required, use a masked snapshot with documented scope and expiry.
- Backups & drills: weekly backups; quarterly restore drill. One named owner; keep runbooks short (≤ 10 steps).

## Pillars Alignment

- Speed with Safety: Pre‑defined retention, erasure, and restore runbooks make operational changes fast and reversible while protecting user data.
- Simplicity over Complexity: A single, clear classification model and explicit retention durations avoid bespoke policies per slice.
- Quality through Determinism: Deterministic policies, auditable backups, and tested erasure/restore procedures ensure reproducible outcomes.
- Guided Agentic Autonomy: Agents may propose classification mappings or retention updates, but human approval is required; GuardKit redaction defaults apply to logs/traces.

See `docs/harmony/methodology/README.md` for Harmony’s five pillars.

## Classification and Locations

- Map PII/PHI to systems; record owners; document flows per slice.

## Retention and Erasure

- Define retention by data type; document deletion/erasure requests; test procedures.

## Environment Data Policy

- Avoid production data in non‑prod; if required, mask/anonymize; document exceptions.

## Backups and Restore Drills

- Periodic backups; test restores; encrypt at rest/in transit; document RPO/RTO.

## Related Docs

- Security baseline: `docs/harmony/security-and-privacy.md`
- Knowledge Plane: `docs/harmony/architecture/knowledge-plane.md`
- Methodology overview: `docs/harmony/methodology/README.md`
- Implementation guide: `docs/harmony/methodology/implementation-guide.md`
- Layers model: `docs/harmony/methodology/layers.md`
- Improve layer: `docs/harmony/methodology/improve-layer.md`
- Architecture overview: `docs/harmony/architecture/overview.md`
- Runtime policy: `docs/harmony/architecture/runtime-policy.md`
- Governance model: `docs/harmony/architecture/governance-model.md`
