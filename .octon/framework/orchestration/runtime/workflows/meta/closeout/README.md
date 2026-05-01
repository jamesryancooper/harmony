---
title: Change Closeout Workflow
description: Canonical Change closeout workflow entry point for Octon's Change-first Git and GitHub operating model.
---

# Change Closeout Workflow

This workflow family owns Change closeout routing for Octon.

Ingress does not define closeout trigger logic, route selection, merge-lane
selection, or compatibility fallback prompts inline. It points here.

Canonical policy and execution surfaces:

- `/.octon/framework/product/contracts/default-work-unit.md`
- `/.octon/framework/product/contracts/default-work-unit.yml`
- `/.octon/framework/product/contracts/change-receipt-v1.schema.json`
- `/.octon/framework/orchestration/runtime/workflows/meta/closeout/workflow.yml`
- `/.octon/framework/execution-roles/practices/standards/git-worktree-autonomy-contract.yml`
- `/.octon/framework/capabilities/runtime/skills/remediation/closeout-change/SKILL.md`
- `/.octon/framework/capabilities/runtime/skills/remediation/closeout-pr/SKILL.md`

This workflow covers:

- contextual closeout triggering at a credible completion point
- direct-main, branch-only, PR-backed, and stage-only route selection
- lifecycle outcome resolution distinct from route selection
- worktree and PR state detection after route selection
- Change receipt and rollback evidence requirements
- branch-only preservation, branch-local completion, branch push, no-PR landing,
  and cleanup claims
- PR-backed published, ready, landed, and cleaned claims
- PR-backed autonomous versus manual merge-lane routing
- status-only responses for already-ready PR-backed Changes
- compatibility fallback handling for legacy adapters

This workflow does not own build-to-delete or release-claim closeout. Those
governance closure surfaces live under
`/.octon/instance/governance/contracts/closeout-reviews.yml`.
