---
title: Agents
description: Accountable execution roles for planning, orchestration, and independent verification.
---

# Agents

Agents are the accountable execution roles in the agency subsystem.

## Responsibilities

- Keep one explicit accountable owner for default execution
- Plan and sequence work within granted scope
- Delegate only when bounded context isolation, concurrency, or independence helps
- Escalate one-way-door decisions to humans
- Keep memory and execution discipline grounded in runtime artifacts, not persona prose

## Discovery

Use `registry.yml` for actor routing metadata and `AGENT.md` for execution contracts.
`SOUL.md` is optional and non-authoritative when present.

## Contract Layers

Each agent directory requires one execution contract and may include one optional identity overlay:

| File | Responsibility |
|---|---|
| `AGENT.md` | Operational policy: scope, delegation, escalation, output contract |
| `SOUL.md` | Optional identity overlay only; it must not add authority or runtime policy |

Cross-agent overlays in `agency/governance/`:

- `governance/CONSTITUTION.md`
- `governance/DELEGATION.md`
- `governance/MEMORY.md`

Precedence: root `AGENTS.md` -> `CONSTITUTION.md` -> `DELEGATION.md` -> `MEMORY.md` -> agent `AGENT.md`.

## Layout

```text
agents/
├── registry.yml
├── _scaffold/template/AGENT.md
├── _scaffold/template/SOUL.md
└── <id>/
    ├── AGENT.md
    └── SOUL.md (optional)
```
