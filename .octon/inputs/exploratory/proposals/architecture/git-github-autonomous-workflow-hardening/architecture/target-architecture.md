# Target Architecture

## Executive decision

Adopt a **contract-backed, worktree-native, GitHub-gated hardening follow-up**
for Octon's autonomous workflow.

The durable workflow remains Git + GitHub, but the client or execution host is
**not** part of the contract. The contract must be equally valid whether the
operator works from plain terminal Git, an IDE with worktree support, Codex
App, Claude Code, or another environment that can operate a linked worktree
and GitHub PR.

## What this packet keeps

- one clean primary `main` worktree or clone as the integration anchor
- one branch worktree per task or PR
- same branch and same PR for the life of the task
- draft-first PR posture
- GitHub rulesets, checks, and reviewer or maintainer confirmation as the final
  merge gate
- reviewer-owned thread resolution left to reviewer or maintainer
- local helper scripts as optional accelerators, not the only valid workflow

## What this packet changes

### 1. Add one canonical workflow contract

Add a machine-readable workflow contract at:

- `/.octon/framework/agency/practices/standards/git-worktree-autonomy-contract.yml`

That contract should define, at minimum:

- operating model
- closeout contexts and suppressions
- author remediation policy
- helper semantics
- validation scenarios

This is the main architectural hardening move. It gives the repo one durable
surface that validators can defend instead of relying on parallel prose updates
alone.

### 2. Make `ready_pr` an explicit closeout state

The authoritative closeout model should distinguish at least these ready states:

- ready and waiting on required checks or auto-merge
- ready and waiting on reviewer or maintainer confirmation
- ready in the manual lane and waiting on human review or merge

These are **status responses**, not more closeout questions.

The main prompts remain:

- primary `main` worktree:
  - branch into a feature worktree and prepare a draft PR
- branch worktree with no PR:
  - stage, commit, push, and open a draft PR
- branch worktree with a draft PR in the autonomous lane:
  - mark ready and request squash auto-merge
- branch worktree with a draft PR in the manual lane:
  - mark ready for human review with auto-merge off

### 3. Normalize remediation around new commits

The durable remediation rule becomes:

- fix
- commit
- push
- reply
- never amend during ordinary remediation
- never rebase during ordinary remediation
- never force-push during ordinary remediation
- never resolve reviewer-owned threads programmatically
- never merge `main` into the branch as a remediation shortcut

This rule must appear consistently in:

- `pull-request-standards.md`
- remediation skill prose
- remediation safety reference

### 4. Give the remediation skill the authority it promises

Because the target repo behavior is clearly an autonomous remediation loop, the
better hardening path is to authorize the **minimal safe Git subset** needed
for that loop, while still forbidding risky history rewrite.

The intended safe subset is:

- `git status`
- `git diff`
- `git add`
- `git commit`
- `git push`

Forbidden operations remain:

- `git commit --amend`
- `git rebase`
- any force-push variant
- programmatic review-thread resolution

### 5. Reframe helpers as request and status surfaces

`git-pr-open.sh` remains a create-oriented helper. Later PR updates happen by
pushing more commits to the same branch.

`git-pr-ship.sh` should move to a clearer contract:

- no-argument mode reports current status and blockers
- explicit flags request ready-for-review or auto-merge transitions
- helper output makes clear that GitHub still decides mergeability

This packet intentionally hardens the helper boundary rather than removing the
helper.

### 6. Add workflow drift detection

Add one dedicated validator that fails on the exact drift classes surfaced by
the audit:

- `ready_pr` declared without explicit handling
- stale force-push/rebase remediation guidance
- helper docs overstating behavior
- remediation skill prose exceeding its allowed-tools boundary
- helper messaging implying readiness proof rather than request semantics

### 7. Keep GitHub projections aligned but subordinate

Repo-local GitHub surfaces must still align in the same branch:

- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/workflows/pr-quality.yml`
- `.github/workflows/pr-autonomy-policy.yml`
- `.github/workflows/pr-auto-merge.yml`

Those surfaces remain **important**, but they do not replace the authoritative
meaning in ingress, practice standards, capability boundaries, and validators.

## Explicit terminology posture

The packet standardizes operator language on:

- `closeout`
- `ready`
- `request auto-merge`

The word `ship` may remain as a compatibility alias, but it should stop being
the preferred durable label for PR-closeout intent because the repo already
uses `shipping` for post-merge production promotion.

## End-state behavior model

Once implemented, the live workflow should read as:

1. start from a clean primary `main` worktree or clone
2. create a branch worktree for one task or PR
3. implement and validate in that worktree
4. open a draft PR early
5. iterate on the same branch and same PR
6. remediate review with new commits and replies
7. move to ready only when the work is complete, the lane is correct, and no
   author action items remain
8. let GitHub perform the final merge when checks and review policy are
   satisfied
9. converge local refs and linked worktrees safely after closure
