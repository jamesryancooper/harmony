---
title: Closeout Change Decisions
---

# Decisions

- Select `branch-pr` when the operator requests a PR, hosted review, remote CI,
  preview publication, external signoff, release automation, branch protection,
  existing PR context, or high-risk hosted validation.
- Select `branch-no-pr` when isolation, pause/resume, multiple commits,
  uncertain scope, handoff, branch backup, or no-PR landing is needed without
  PR-backed publication.
- Select `direct-main` only on clean current `main` for low-risk solo Changes
  with local validation, receipt, durable history, and rollback ready.
- Select `stage-only-escalate` when route, validation, rollback, ownership,
  support, or authority is ambiguous.

After selecting a route, select lifecycle outcome:

- `preserved`: state is recoverable but not necessarily committed or landed.
- `branch-local-complete`: intended scope is committed on a branch but not
  landed.
- `published-branch`: branch is pushed for backup or handoff without a PR.
- `published`: PR-backed branch is pushed and a PR exists.
- `ready`: PR gates are satisfied and waiting for merge or auto-merge.
- `landed`: the Change is integrated into `main`.
- `cleaned`: branch, remote branch when present, and worktree cleanup are
  complete or explicitly deferred with evidence.
- `blocked`, `escalated`, or `denied`: closeout cannot truthfully progress.
