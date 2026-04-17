# Assumptions and Blockers

## Assumptions

- GitHub remains the host control plane for PR state, required checks, and
  merge execution.
- Standard Git linked-worktree support remains available.
- `gh` remains the GitHub CLI surface for operator and helper flows.
- The repo can land `.octon/**` and `.github/**` workflow alignments in the
  same implementation branch.
- Pre-1.0 change tolerance is high enough to permit a helper CLI hardening
  change if it materially reduces ambiguity.

## Current blockers

No blocker prevents creation of this proposal packet.

## Open implementation choice

The remaining implementation choice is whether `git-pr-ship.sh` keeps a short
legacy compatibility path for current no-argument mutation behavior or flips
directly to status-first behavior. This packet recommends status-first behavior
as the durable end state either way.
