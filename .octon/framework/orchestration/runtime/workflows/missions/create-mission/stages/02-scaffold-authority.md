---
title: Scaffold Mission Authority
description: Create the authored mission authority files for a new mission.
---

# Scaffold Mission Authority

Create the mission authority root under
`/.octon/instance/orchestration/missions/<mission_id>/`.

## Steps

1. Copy `/.octon/instance/orchestration/missions/_scaffold/template/` into the
   new mission directory.
2. Set `mission.yml` fields:
   `mission_id`, `title`, `mission_class`, `owner_ref`.
3. Preserve the canonical `octon-mission-v2` authority shape.
4. Initialize `mission.md`, `tasks.json`, and `log.md` for the new mission.

## Rules

- Do not write mutable control truth into the authored scaffold root.
- Do not mark the mission as operationally valid until the seed path completes.

