---
title: Create Mission
description: Scaffold a new mission from template.
access: human
version: "1.2.0"
depends_on: []
checkpoints:
  enabled: true
  storage: ".octon/state/control/workflows/checkpoints/"
parallel_steps: []
---

# Create Mission

Scaffold a new mission with `octon-mission-v2` authority plus seeded mission
control and continuity surfaces.

## Usage

```text
/create-mission <slug>
```

## Prerequisites

- Mission slug must be lowercase with hyphens (e.g., `auth-overhaul`)
- No existing mission with the same slug

## Failure Conditions

- Mission slug is invalid -> STOP, report the required slug format
- Mission already exists -> STOP, use the existing mission or choose a new slug
- Mission scaffold template is missing -> STOP, restore the mission template before continuing

## Steps

1. **Validate slug** — Check format and uniqueness
2. **Copy template** — Copy `missions/_scaffold/template/` to `missions/<slug>/`
3. **Initialize mission.yml** — Update canonical mission identity, lifecycle,
   mission class, owner reference, risk ceiling, allowed action classes,
   safe subset, schedule hints, success criteria, and failure conditions
4. **Initialize mission.md** — Keep bounded narrative context subordinate to
   `mission.yml`
5. **Initialize tasks.json** — Set mission identifier
6. **Initialize log.md** — Add creation entry with date
7. **Seed mission control truth** — Materialize lease, mode, intent,
   directives, schedule, autonomy-budget, circuit-breakers, and subscriptions
   under `state/control/execution/missions/<slug>/` by running
   `framework/orchestration/runtime/_ops/scripts/seed-mission-autonomy-state.sh`
8. **Seed mission continuity** — Materialize `next-actions.yml` and
   `handoff.md` under `state/continuity/repo/missions/<slug>/`
9. **Update registry** — Add mission to `active` list in `registry.yml`
10. **Confirm** — Report success and next steps

## Output

A new mission directory ready for work:

```text
missions/<slug>/
├── mission.yml    # Canonical mission object
├── mission.md     # Narrative context subordinate to mission.yml
├── tasks.json     # Empty task list
├── log.md         # Creation entry logged
└── context/       # Mission-local context
```

## Required Outcome

- [ ] `missions/<slug>/` exists with initialized mission artifacts
- [ ] Mission control state exists and starts paused with healthy autonomy burn
- [ ] Mission registry is updated
- [ ] Operator receives the next-step guidance after creation

## Next Steps After Creation

1. Edit `mission.yml` to confirm mission class, owner reference, allowed action
   classes, success criteria, and failure conditions
2. Update `mission.md` with bounded narrative context
3. Review seeded mission control files and update schedule/awareness defaults if
   needed
4. Add initial tasks to `tasks.json`
5. Begin work on the mission

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.2.0 | 2026-03-23 | Upgraded to mission charter v2 and seeded mission autonomy control surfaces |
| 1.1.0 | 2025-01-14 | Added gap remediation fields |
| 1.0.0 | 2025-01-05 | Initial version |

## Related

- [Complete Mission](../complete-mission/00-overview.md) — Archive a completed mission
- [Missions README](../../../missions/README.md) — Overview of missions
