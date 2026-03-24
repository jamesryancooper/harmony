---
title: Complete Mission
description: Archive a completed mission.
access: human
version: "1.2.0"
depends_on:
  - workflow: missions/create-mission
    condition: "Mission must exist"
checkpoints:
  enabled: true
  storage: ".octon/state/control/workflows/checkpoints/"
parallel_steps: []
---

# Complete Mission

Archive a mission after completion or cancellation while preserving mission
control, retained evidence, and continuity handoff coherence.

## Usage

```text
/complete-mission <slug> [--cancelled]
```

## Prerequisites

- Mission must exist in `missions/<slug>/`
- Mission should have success criteria met (or be cancelled)

## Steps

1. **Validate mission exists** — Check `missions/<slug>/` exists
2. **Verify completion** — Check success criteria in `mission.yml` and
   mission continuity (skip success check if `--cancelled`)
3. **Close mission control state** — Pause or revoke the continuation lease,
   set final mode/phase, and preserve control history for inspection by
   running `framework/orchestration/runtime/_ops/scripts/close-mission-autonomy-state.sh`
4. **Finalize continuity handoff** — Update `next-actions.yml` and `handoff.md`
   with closure or follow-up obligations
5. **Update mission authority** — Set final mission status and final log entry
6. **Move to archive** — Move `missions/<slug>/` to `missions/.archive/<slug>/`
   only after the control/evidence/read-model surfaces remain coherent
7. **Update registry** — Move from `active` to `archived` in `registry.yml`
8. **Confirm** — Report success

## Output

Mission moved to archive:

```text
missions/.archive/<slug>/
├── mission.md     # Status: completed/cancelled with linkage fields preserved
├── tasks.json     # Final task state
└── log.md         # Completion entry logged
```

## Flags

| Flag | Description |
|------|-------------|
| `--cancelled` | Mark as cancelled instead of completed |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.2.0 | 2026-03-23 | Added mission control closure and continuity handoff requirements |
| 1.1.0 | 2025-01-14 | Added gap remediation fields |
| 1.0.0 | 2025-01-05 | Initial version |

## Related

- [Create Mission](../create-mission/00-overview.md) — Scaffold a new mission
- [Missions README](../../../missions/README.md) — Overview of missions
