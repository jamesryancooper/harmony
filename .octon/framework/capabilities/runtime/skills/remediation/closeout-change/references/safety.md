---
title: Closeout Change Safety
---

# Safety

- Fail closed when route selection is ambiguous.
- Preserve unrelated working tree changes.
- Do not stage files outside the intended Change scope.
- Do not bypass required validation, review, approval, evidence, or rollback
  requirements.
- Do not use GitHub state as authority.
- Do not report a checkpoint, patch, or branch-local commit as landed.
- Do not report a draft, open, or ready PR as full closeout.
- Do not claim cleanup unless local branch, remote branch when present, and
  worktree cleanup evidence exists or a deferred-cleanup record is written.
- Do not retain proposal-local runtime dependencies.
