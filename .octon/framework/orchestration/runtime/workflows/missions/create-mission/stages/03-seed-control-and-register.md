---
title: Seed Control And Register
description: Seed mission control truth, continuity, generated outputs, and registry state.
---

# Seed Control And Register

Materialize the full mission operating model after the authored scaffold exists.

## Steps

1. Run
   `/.octon/framework/orchestration/runtime/_ops/scripts/seed-mission-autonomy-state.sh --mission-id <mission_id> --issued-by <owner_ref>`.
2. Ensure the seed path creates:
   `lease.yml`, `mode-state.yml`, `intent-register.yml`, `action-slices/`,
   `directives.yml`, `authorize-updates.yml`, `schedule.yml`,
   `autonomy-budget.yml`, `circuit-breakers.yml`, `subscriptions.yml`,
   `next-actions.yml`, `handoff.md`, `scenario-resolution.yml`,
   mission summaries, operator digests, and `mission-view.yml`.
3. Add the mission to the active set in
   `/.octon/instance/orchestration/missions/registry.yml`.
4. Rebuild mission read models if the seed path did not already refresh them.

## Rules

- The mission is not complete until authority, control, continuity, and
  generated outputs all exist.
- Fail closed if any canonical root is missing after seeding.

