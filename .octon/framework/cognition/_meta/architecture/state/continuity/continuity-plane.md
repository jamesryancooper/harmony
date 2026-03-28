---
title: Continuity Plane
description: Continuity architecture aligned to the active `.octon/state/continuity/repo/` contract (`log.md`, `tasks.json`, `entities.json`, `next.md`).
---

# Continuity Plane

The Continuity Plane preserves operational memory so work can resume safely across sessions, agents, and humans.
It supports reliable agent execution by preserving deterministic evidence, maintaining observability for debugging, and keeping handoffs evolvable as the system changes.

## Core Question

What happened, what is active now, and what should happen next?

## Canonical Storage Contract

```text
.octon/state/continuity/repo/
├── log.md
├── tasks.json
├── entities.json
└── next.md
```

The four top-level files are the authoritative handoff contract for active
continuity state. Retained operational evidence is authoritative under
`.octon/state/evidence/**`.

## File Responsibilities

### `.octon/state/continuity/repo/log.md`

- Append-first chronological activity history.
- Records: decisions made, commands run, outcomes, blockers, and handoff notes.
- Purpose: auditable timeline and context reconstruction.

### `.octon/state/continuity/repo/tasks.json`

- Structured queue of active and deferred work.
- Canonical statuses: `pending`, `in_progress`, `blocked`, `completed`, `cancelled`.
- Active work (`pending`, `in_progress`, `blocked`) requires ownership, blocker state, acceptance criteria, and knowledge links.
- Purpose: machine-readable task state for routing and prioritization.

### `.octon/state/continuity/repo/entities.json`

- Structured entity index (services, modules, missions, domains, workflows, or other tracked units).
- Includes ownership, lifecycle state, related tasks, and knowledge links.
- Purpose: shared object model for continuity-aware planning.

### `.octon/state/continuity/repo/next.md`

- Short, actionable next steps.
- Must reference active unblocked task IDs from `tasks.json`.
- Purpose: fast handoff surface for the next execution session.

### `.octon/state/continuity/runs/<run-id>/handoff.yml`

- Mutable resumability and handoff state for a bound run.
- Canonical home for operator-facing continuation metadata such as the last
  checkpoint, retained receipt, and next safe action.
- Must stay derived from, and subordinate to,
  `/.octon/state/control/execution/runs/<run-id>/**` and
  `/.octon/state/evidence/runs/<run-id>/**`.

### `.octon/state/evidence/decisions/{repo,scopes/<scope-id>}/`

- Append-oriented historical lineage and capability-policy decision evidence.
- No longer the canonical home for per-run authority decisions or grant
  bundles, which live under `/.octon/state/evidence/control/execution/**`.
- Lifecycle governed by `/.octon/state/evidence/decisions/repo/retention.json`.
- Not a source of active task state.

### `.octon/state/evidence/runs/`

- Append-oriented run evidence artifacts (receipts, digests, policy traces).
- Material-run evidence includes:
  - instruction-layer manifests (`instruction-layer-manifest.json`)
  - receipt telemetry fields (`instruction_layers`, `context_acquisition`, `context_overhead_ratio`)
- Lifecycle governed by `/.octon/state/evidence/runs/retention.json`.
- Not a source of active task state.

## Lifecycle Rules

| Artifact | Mutability | Rule |
|---|---|---|
| `log.md` | Append-first | Add new entries; avoid destructive edits. |
| `tasks.json` | Mutable | Update status/ownership/blockers and knowledge links as work changes. |
| `entities.json` | Mutable | Keep IDs stable; align owner/related_tasks with task state. |
| `next.md` | Mutable | Keep concise, executable, and coherent with active unblocked tasks. |
| `runs/<run-id>/handoff.yml` | Mutable | Keep resumability and handoff fields aligned with the canonical run control and retained evidence roots. |
| `decisions/` | Append-oriented lineage | Apply retention classes and lifecycle actions from `decisions/retention.json`; do not treat as canonical per-run authority. |
| `runs/` | Append-oriented evidence | Apply retention classes and lifecycle actions from `runs/retention.json`. |

## Cross-Subsystem Integration

- Cognition provides durable context and decisions consumed during planning.
- Orchestration workflows update continuity state while executing tasks.
- Quality gates validate changes while continuity artifacts preserve execution traceability.
- Scope-local work may use `state/continuity/scopes/<scope-id>/**` when the
  declared scope is the primary continuity home.

## Operational Expectations

- Every material session should append at least one meaningful `log.md` entry.
- `tasks.json` and `next.md` must be coherent: `next.md` should point to active, unblocked items.
- `entities.json` should reflect ownership and lifecycle before handoff.
- Continuity JSON artifacts must satisfy canonical schema contracts under `_meta/architecture/schemas/`.
- Decision evidence directories under `state/evidence/decisions/**` must map
  to a declared retention class.
- Run evidence directories under `state/evidence/runs/**` must map to a
  declared retention class.
- Post-cutover run evidence should support context-overhead classification (`within-target`, `warn`, `soft-fail`, `hard-fail`).

## Anti-Patterns

- Storing active work state outside the canonical four-file contract.
- Treating retained evidence as mutable task state.
- Letting `next.md` diverge from `tasks.json`.
- Backfilling large historical edits into `log.md` without clear correction notes.
- Using legacy task fields such as `blocked_by` instead of canonical `blockers`.
- Leaving `next.md` in placeholder state while active unblocked tasks exist.

## Related Docs

- `.octon/framework/cognition/_meta/architecture/state/continuity/three-planes-integration.md`
- `.octon/instance/cognition/context/shared/knowledge/knowledge.md`
- `.octon/framework/cognition/governance/README.md`
- `.octon/framework/cognition/practices/README.md`
- `.octon/instance/bootstrap/START.md`
