# File Change Map

## Primary promotion targets

| Path | Change class | Why it is in scope |
|---|---|---|
| `/.octon/framework/agency/practices/standards/git-worktree-autonomy-contract.yml` | add | gives the workflow one machine-readable contract for operating model, closeout contexts, remediation policy, helper semantics, and validation scenarios |
| `/.octon/instance/ingress/manifest.yml` | edit | adds explicit `ready_pr` handling and makes closeout behavior authoritative instead of implied |
| `/.octon/instance/ingress/AGENTS.md` | edit | keeps human-readable ingress parity with the hardened manifest |
| `/.octon/framework/agency/practices/git-autonomy-playbook.md` | edit | removes create-versus-update drift and keeps the worktree model environment-neutral |
| `/.octon/framework/agency/practices/git-github-autonomy-workflow-v1.md` | edit | keeps the overview synchronized with the hardened contract and ready-state handling |
| `/.octon/framework/agency/practices/pull-request-standards.md` | edit | removes rebase/force-push remediation language and points to the hardened policy |
| `/.octon/framework/agency/_ops/scripts/git/git-pr-ship.sh` | edit | moves helper semantics to status-first and explicit action requests rather than eager mutation |
| `/.octon/framework/capabilities/runtime/skills/remediation/resolve-pr-comments/SKILL.md` | edit | aligns promised behavior with the actual permitted Git/GitHub action set |
| `/.octon/framework/capabilities/runtime/skills/remediation/resolve-pr-comments/references/safety.md` | edit | codifies the same remediation boundaries in the derived safety reference |
| `/.octon/framework/assurance/runtime/_ops/scripts/validate-git-github-workflow-alignment.sh` | add | fails closed when ingress, docs, skill, and helper semantics drift from the workflow contract |
| `/.octon/framework/assurance/runtime/_ops/tests/test-git-github-workflow-alignment.sh` | add | proves validator behavior on representative happy-path and failing fixtures |

## Same-branch companion alignments

These are required implementation companions, even though they are not manifest
promotion targets for this `octon-internal` packet.

| Path | Role |
|---|---|
| `.github/PULL_REQUEST_TEMPLATE.md` | keep reviewer-thread wording aligned with the hardened remediation policy |
| `.github/workflows/pr-quality.yml` | ensure PR-body validation still matches the intended closeout and review contract |
| `.github/workflows/pr-autonomy-policy.yml` | keep autonomous/manual lane evaluation aligned with the hardened workflow contract |
| `.github/workflows/pr-auto-merge.yml` | preserve request-only helper semantics while leaving final authority with GitHub |

## Expected no-change or minimal-change adjacent surfaces

| Path | Current packet posture |
|---|---|
| `/.octon/framework/agency/_ops/scripts/git/git-wt-new.sh` | keep current behavior; already consistent with the target model |
| `/.octon/framework/agency/_ops/scripts/git/git-pr-open.sh` | behavior can remain create-oriented; only surrounding docs need to stop overstating it |
| `/.octon/framework/agency/_ops/scripts/git/git-pr-cleanup.sh` | preserve current safe cleanup behavior unless validation exposes a concrete gap |
