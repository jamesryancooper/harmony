---
title: Foundational Planes Integration
description: Integration contract for Governance, Runtime, Continuity, and Knowledge planes, retained at a legacy path for compatibility.
---

# Foundational Planes Integration

This file is retained at `three-planes-integration.md` for link compatibility.
The canonical model is now a **foundational four-plane model**.

Harmony separates concerns into four foundational planes while keeping explicit
integration points.

## Plane Roles

| Plane | Core Question | Primary Surface |
|---|---|---|
| Governance Plane | What is allowed, required, and enforced? | `.harmony/*/governance/` with cognition governance as cross-cutting policy anchor |
| Runtime Plane | What runs and performs work? | `.harmony/*/runtime/` (plus executable runtime authority in `.harmony/engine/runtime/`) |
| Continuity Plane | What happened and what is next? | `.harmony/continuity/{log.md,tasks.json,entities.json,next.md}` |
| Knowledge Plane | What is the system and how does it behave? | cognition runtime knowledge contracts, evidence indexes, architecture links, and telemetry references |

## Optional Publishing Surface (Non-Foundational)

`/.harmony/cognition/_meta/architecture/artifact-surface/` is an optional
artifact architecture surface. It is not a foundational plane for Harmony
governance/execution semantics.

## Integration Contract

### Governance -> Runtime

- Runtime actions MUST respect governance controls (deny-by-default, ACP gates,
  risk-tier contracts, waiver semantics).
- Governance changes that alter execution policy SHOULD be reflected in runtime
  procedures and enforcement artifacts.

### Runtime -> Continuity

- Material runtime execution outcomes SHOULD be captured in `log.md`.
- Active and blocked execution work MUST be represented in `tasks.json` and
  surfaced in `next.md`.
- Durable run receipts/digests SHOULD be stored in `continuity/runs/` and must
  follow retention classes from `continuity/runs/retention.json`.

### Continuity -> Knowledge

- Active tasks in `tasks.json` should reference relevant specs, contracts, or architecture docs when available.
- Entity records in `entities.json` should link to authoritative technical knowledge sources.

### Knowledge -> Continuity

- Architectural decisions and verification outcomes should be captured in continuity history (`log.md`) and future actions (`next.md`).
- Breaking or risky system changes should update task metadata (risk, blockers, required approvals).

### Optional Publishing Surface -> Continuity/Knowledge

- Publication/content work SHOULD still flow through continuity state when it is
  active execution work.
- Published artifacts MAY be indexed by knowledge/evidence systems but do not
  redefine foundational plane ownership.

## Data Flow

```text
Governance policy/controls
            |
            v
 Runtime execution + outcomes -----> Continuity state
            |                               |
            v                               v
      Knowledge updates <----------- decision/task linkage
```

## Consistency Requirements

- `next.md` must only reference active, unblocked tasks from `tasks.json`.
- `entities.json` ownership should align with task ownership when work is entity-specific.
- `log.md` entries should provide enough context to understand why task/entity state changed.
- `runs/` artifacts should map to a retention class and must not replace active
  task-state tracking surfaces.
- Governance contracts and runtime behavior MUST NOT diverge without explicit
  migration records.

## Governance Hooks

- ACP policy gates and risk-tiering are enforced through workflow and policy docs, while continuity captures the resulting execution trail.
- Post-change verification should be represented by both evidence in knowledge artifacts and status progression in `tasks.json`.

## Anti-Patterns

- Treating continuity files as optional notes instead of operational state.
- Recording decisions only in prose without updating structured continuity state.
- Allowing task progression without corresponding log entries.
- Treating artifact surface architecture as a foundational control/runtime
  plane in Harmony.

## Related Docs

- `.harmony/continuity/_meta/architecture/continuity-plane.md`
- `.harmony/cognition/runtime/knowledge-plane/knowledge-plane.md`
- `.harmony/cognition/governance/README.md`
- `.harmony/cognition/practices/README.md`
- `.harmony/cognition/_meta/architecture/artifact-surface/README.md` (optional artifact architecture)
- `.harmony/START.md`
