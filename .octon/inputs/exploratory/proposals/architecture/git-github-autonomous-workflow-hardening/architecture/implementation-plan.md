# Implementation Plan

## Profile Selection Receipt

- Semantic version source: `version.txt`
- Current version: `0.6.30`
- `release_state`: `pre-1.0`
- `change_profile`: `atomic`
- Hard-gate facts:
  - no new top-level root is introduced
  - no support-target widening is required
  - no new merge authority is created outside the current GitHub control plane
  - all durable changes can land in one coordinated implementation branch
- Tie-break status: none
- `transitional_exception_note`: `n/a`

## Posture

This packet is a **same-root hardening refinement**. The repo already has the
correct workflow shape. The goal is to make the live shape explicit,
validator-backed, and environment-neutral.

## Phase 0 — Accept the hardening frame

1. Accept this packet as a follow-on to the archived `git-github-workflow`
   normalization packet.
2. Freeze the in-scope hardening goals:
   - environment-neutral worktree contract
   - explicit `ready_pr` handling
   - coherent remediation policy and tool boundary
   - status-first helper semantics
   - fail-closed drift detection
3. Confirm that `.github/**` companion alignments will land in the same branch.

## Phase 1 — Establish one canonical workflow contract

1. Add `git-worktree-autonomy-contract.yml` under
   `/.octon/framework/agency/practices/standards/`.
2. Define, at minimum:
   - operating model
   - closeout contexts and suppressions
   - remediation policy
   - helper semantics
   - validation scenarios
3. Make docs and validators consume this contract as the single source of truth
   for workflow semantics.

## Phase 2 — Harden ingress closeout handling

1. Update `/.octon/instance/ingress/manifest.yml` so `ready_pr` is not merely
   declared but fully handled.
2. Encode ready-state status responses such as:
   - already ready and waiting on checks or auto-merge
   - already ready and waiting on reviewer or maintainer confirmation
   - already ready in the manual lane and waiting on human review or merge
3. Mirror the same behavior in ingress `AGENTS.md`.
4. Keep closeout prompts suppressed for ready PRs instead of prompting again.

## Phase 3 — Normalize remediation policy and capability boundaries

1. Update `pull-request-standards.md` to replace history-rewrite language with
   new-commit remediation language.
2. Align the remediation skill and safety reference around:
   - fix
   - commit
   - push
   - reply
   - no amend
   - no rebase
   - no force-push
   - no programmatic resolution of reviewer-owned threads
3. Ensure the skill's allowed-tools boundary matches the promised behavior.

## Phase 4 — Reframe helpers as explicit request surfaces

1. Keep `git-pr-open.sh` documented as a create-oriented helper; later updates
   happen by pushing more commits to the same branch.
2. Change `git-pr-ship.sh` to a status-first posture:
   - no-argument mode reports readiness and blockers
   - explicit flags request ready and auto-merge transitions
   - helper output states that GitHub remains the final merge gate
3. Keep cleanup behavior intact and continue treating worktree pruning as safe
   convergence rather than a second authority plane.

## Phase 5 — Add drift detection and scenario proof

1. Add `validate-git-github-workflow-alignment.sh`.
2. Cover at least these failure classes:
   - `ready_pr` declared without explicit handling
   - stale "rebase and force-push cleanup" language
   - playbook claiming `git-pr-open.sh` updates existing PRs
   - remediation skill prose that exceeds its allowed-tools boundary
   - helper docs or script text that overstate readiness proof
3. Add tests or fixtures for happy-path and failing-path cases.
4. Exercise the scenario matrix from `validation-plan.md`.

## Preferred Change Path

One coordinated implementation branch that lands:

- the workflow contract
- ingress updates
- practice-doc updates
- helper-script hardening
- remediation-skill alignment
- `.github/**` companion alignment
- validator coverage

## Minimal fallback path

Only if one coordinated branch becomes too risky:

1. land the workflow contract and ingress parity first
2. land remediation policy and capability-boundary alignment second
3. land helper and `.github/**` alignment third

This fallback is weaker because the current problem is drift across surfaces,
and split delivery prolongs that drift.
