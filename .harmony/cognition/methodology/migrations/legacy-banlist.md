---
title: Legacy Banlist (SSOT)
description: Canonical banlist of removed legacy identifiers, paths, and configuration keys enforced by CI.
---

# Legacy Banlist (SSOT)

Add entries here during migrations. CI should enforce this file.

## Banned Identifiers

Each entry should be specific enough to avoid false positives.

- `agency/agents/registry.yml` - legacy root actor registry path - removed by migration `2026-02-20-agency-bounded-surfaces`
- `agency/assistants/registry.yml` - legacy root assistant registry path - removed by migration `2026-02-20-agency-bounded-surfaces`
- `agency/teams/registry.yml` - legacy root team registry path - removed by migration `2026-02-20-agency-bounded-surfaces`
- `agency/CONSTITUTION.md` - legacy root governance contract path - removed by migration `2026-02-20-agency-bounded-surfaces`
- `agency/DELEGATION.md` - legacy root governance contract path - removed by migration `2026-02-20-agency-bounded-surfaces`
- `agency/MEMORY.md` - legacy root governance contract path - removed by migration `2026-02-20-agency-bounded-surfaces`
- `orchestration/workflows/manifest.yml` - legacy root workflow manifest path - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `orchestration/workflows/registry.yml` - legacy root workflow registry path - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `orchestration/missions/registry.yml` - legacy root mission registry path - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `orchestration/incidents.md` - legacy root incident governance path - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `orchestration/incident-response.md` - removed compatibility redirect path - removed by migration `2026-02-20-orchestration-bounded-surfaces`

## Banned Paths

- `/.harmony/agency/agents/` - replaced by `/.harmony/agency/actors/agents/` - removed by migration `2026-02-20-agency-bounded-surfaces`
- `/.harmony/agency/assistants/` - replaced by `/.harmony/agency/actors/assistants/` - removed by migration `2026-02-20-agency-bounded-surfaces`
- `/.harmony/agency/teams/` - replaced by `/.harmony/agency/actors/teams/` - removed by migration `2026-02-20-agency-bounded-surfaces`
- `/.harmony/agency/CONSTITUTION.md` - moved to governance surface - removed by migration `2026-02-20-agency-bounded-surfaces`
- `/.harmony/agency/DELEGATION.md` - moved to governance surface - removed by migration `2026-02-20-agency-bounded-surfaces`
- `/.harmony/agency/MEMORY.md` - moved to governance surface - removed by migration `2026-02-20-agency-bounded-surfaces`
- `/.harmony/orchestration/workflows/` - replaced by `/.harmony/orchestration/runtime/workflows/` - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `/.harmony/orchestration/missions/` - replaced by `/.harmony/orchestration/runtime/missions/` - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `/.harmony/orchestration/incidents.md` - moved to governance surface - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `/.harmony/orchestration/incident-response.md` - compatibility redirect removed in clean-break migration `2026-02-20-orchestration-bounded-surfaces`
- `/.harmony/scaffolding/templates/harmony/orchestration/workflows/` - replaced by `/.harmony/scaffolding/templates/harmony/orchestration/runtime/workflows/` - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `/.harmony/scaffolding/templates/harmony/orchestration/missions/` - replaced by `/.harmony/scaffolding/templates/harmony/orchestration/runtime/missions/` - removed by migration `2026-02-20-orchestration-bounded-surfaces`
- `/.harmony/scaffolding/templates/harmony-docs/orchestration/workflows/` - replaced by `/.harmony/scaffolding/templates/harmony-docs/orchestration/runtime/workflows/` - removed by migration `2026-02-20-orchestration-bounded-surfaces`

## Banned Config Keys or Env Vars

- `(none currently)` - no legacy config or env keys removed in migration `2026-02-20-agency-bounded-surfaces`
