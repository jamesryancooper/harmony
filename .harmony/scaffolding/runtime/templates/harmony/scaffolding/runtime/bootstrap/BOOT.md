# BOOT.md

## Purpose

Recurring startup routine for agent sessions in this repository.

## Session Start Checklist

1. Confirm working directory is repository root and `.harmony/` exists.
2. Read `.harmony/AGENTS.md`, then load default agent contracts from `.harmony/agency/manifest.yml`.
3. Scan `.harmony/continuity/log.md` and `.harmony/continuity/tasks.json` for active work and blockers.
4. Review `.harmony/START.md` for the active boot sequence.
5. Begin the highest-priority unblocked task.

## Guardrails

- Keep this file short and deterministic.
- Keep steps idempotent and primarily read-only.
- Put one-time onboarding in `BOOTSTRAP.md`, not here.
