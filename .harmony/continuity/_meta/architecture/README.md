# Continuity Plane Documentation

This directory defines the continuity model used by the active `.harmony/` harness.

## Core Question

What happened, what is in progress, and what should happen next?

## Canonical Continuity Contract

Continuity is represented by four canonical files:

```text
.harmony/continuity/
├── log.md        # Chronological activity log (append-first history)
├── tasks.json    # Structured active work queue
├── entities.json # Structured tracked entities and ownership/state metadata
└── next.md       # Immediate next actions and handoff-ready priorities
```

## Document Map

| Document | Description |
|---|---|
| `continuity-plane.md` | Continuity model, data contracts, and lifecycle rules |
| `three-planes-integration.md` | Canonical foundational plane integration contract (nine-plane model; legacy filename retained for compatibility) |
| `runs-retention.md` | Retention classes and lifecycle rules for `continuity/runs/` evidence artifacts |
| `schemas/` | Canonical field-level schema contracts for continuity JSON artifacts |

## Lifecycle Rules

| Artifact | Mutability | Rule |
|---|---|---|
| `.harmony/continuity/log.md` | Append-first | Add entries; do not rewrite history except to correct factual errors. |
| `.harmony/continuity/tasks.json` | Mutable | Keep machine-readable task state current with blockers and ownership. |
| `.harmony/continuity/entities.json` | Mutable | Keep tracked entities current; preserve stable IDs and ownership semantics. |
| `.harmony/continuity/next.md` | Mutable | Keep focused and short; must be executable without extra context. |
| `.harmony/continuity/runs/` | Append-oriented evidence | Govern by retention classes in `runs/retention.json`; do not use for active task state. |

## Related Docs

- `.harmony/cognition/runtime/knowledge/knowledge.md`
- `.harmony/cognition/governance/README.md`
- `.harmony/cognition/practices/README.md`
- `.harmony/START.md`
