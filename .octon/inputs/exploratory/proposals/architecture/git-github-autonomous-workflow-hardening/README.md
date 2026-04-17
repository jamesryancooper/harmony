# Octon Git + GitHub Autonomous Workflow Hardening

## Purpose

This packet turns the 2026-04-17 Git + GitHub workflow audit into a
proposal-first hardening plan for Octon's live autonomous workflow.

This is a follow-on hardening packet, not a greenfield redesign. The live
workflow shape is already mostly correct: worktree-first execution, draft-first
PR creation, GitHub as the final merge gate, reviewer-owned thread resolution,
and safe linked-worktree cleanup are all materially in place. The remaining
work is to remove authoritative drift, tighten helper semantics, and prove that
the workflow stays correct in any environment that supports linked worktrees,
not only in one host app.

## Executive triage

The audit identifies six relevant hardening themes:

1. the canonical closeout contract declares `ready_pr` but does not yet define
   authoritative behavior for it
2. review-remediation policy is still split across conflicting prose surfaces
3. the remediation skill's promised behavior does not match its allowed-tools
   boundary
4. helper-script semantics are still easier to overread than the durable policy
   allows
5. workflow alignment is still mostly protected by prose, not by a dedicated
   drift validator
6. the operator story is already worktree-native, but validation still needs to
   prove that the model works equally well in plain Git + GitHub flows, not
   only through Octon's helper lane

The packet therefore proposes one bounded architectural move:

- add one canonical workflow contract for Git/worktree/PR/remediation semantics
- align ingress, practice docs, helper scripts, and remediation skill behavior
  to that contract
- add validator coverage that fails closed on the exact drift class the audit
  surfaced

## Scope boundary

This packet is intentionally **not Codex-app-specific**.

The target workflow is defined in standard Git and GitHub terms:

- one clean primary `main` worktree or clone
- one branch worktree per task or PR
- same branch and same PR for the life of the task
- new-commit review remediation
- GitHub rulesets, checks, and reviewer or maintainer confirmation as the final
  merge authority

That model must remain usable from:

- plain terminal Git + `gh`
- IDE-integrated Git worktree flows
- Codex App
- Claude Code
- any other agent or operator environment that can work against a linked
  worktree and GitHub PRs

## Important manifest scope note

This proposal remains `promotion_scope: octon-internal`, so its manifest
promotion targets stay inside `/.octon/**`.

Repo-local GitHub alignment surfaces such as `.github/PULL_REQUEST_TEMPLATE.md`
and `.github/workflows/**` are still required for a truthful implementation,
but they are treated here as **same-branch companion alignments**, not manifest
promotion targets.

## Historical lineage considered

- current user-provided audit preserved in `resources/source-audit.md`
- implemented historical architecture packet:
  `/.octon/inputs/exploratory/proposals/.archive/architecture/git-github-workflow/`
- live workflow surfaces:
  `/.octon/instance/ingress/manifest.yml`,
  `/.octon/instance/ingress/AGENTS.md`,
  `/.octon/framework/agency/practices/git-autonomy-playbook.md`,
  `/.octon/framework/agency/practices/git-github-autonomy-workflow-v1.md`,
  `/.octon/framework/agency/practices/pull-request-standards.md`, and
  `/.octon/framework/capabilities/runtime/skills/remediation/resolve-pr-comments/**`

## Recommended reading order

1. `resources/source-artifact.md`
2. `resources/source-audit.md`
3. `resources/repository-baseline-audit.md`
4. `architecture/current-state-gap-map.md`
5. `architecture/concept-coverage-matrix.md`
6. `architecture/target-architecture.md`
7. `architecture/file-change-map.md`
8. `architecture/implementation-plan.md`
9. `architecture/validation-plan.md`
10. `architecture/acceptance-criteria.md`
11. `resources/risk-register.md`

## Non-authority notice

This packet lives under `inputs/exploratory/proposals/**` and is not canonical
authority. If accepted, its durable meaning must be promoted into the listed
targets outside the proposal tree and must not leave proposal-path dependencies
behind.
