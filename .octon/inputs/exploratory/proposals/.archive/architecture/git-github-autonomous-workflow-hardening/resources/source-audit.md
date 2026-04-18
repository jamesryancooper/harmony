# Source Audit

> Verbatim user-provided audit preserved as a packet artifact on 2026-04-17.

## 1. Executive Judgment

The implementation is **mostly correct but still incomplete**. The repo now expresses the right Octon-native model in the places that matter most: a **structured, canonical closeout contract** in ingress; a **worktree-first operating model** that treats `main` as a clean integration anchor and branch worktrees as the normal execution unit; **draft-first PR creation** from feature worktrees; **review remediation as fix + reply without taking reviewer-owned thread resolution away from reviewers**; and **GitHub rulesets/checks as the final merge authority**, with local helpers and labels acting only as request/projection surfaces. Cleanup now also includes safe linked-worktree pruning, which materially improves Codex-style multi-worktree operation. ([GitHub][1])

It is **not yet honestly claimable as complete**. Three defects are still material. First, `pull-request-standards.md` still tells operators to “Rebase and force-push cleanup,” which conflicts with the review-remediation skill and safety references that require **new commits**, prohibit force-push/rebase during remediation, and keep reviewer-owned resolution intact. Second, the canonical closeout contract defines a `ready_pr` context, but it does **not** encode what the assistant should do in that state, so already-ready PRs are still under-specified at the authoritative layer. Third, the review-remediation skill still promises a **fix, commit, push, reply** loop even though its own allowed-tools boundary only authorizes `Bash(gh)` and the safety references explicitly exclude `git push`, rebase, and amend. ([GitHub][1])

So the implementation now reflects the **correct Octon direction** and, importantly, it **did not** literalize your older “resolve any open conversations” wording. But it still has enough authoritative-layer drift that I would rate it **“mostly correct but incomplete,” not “complete.”** ([GitHub][2])

## 2. Implemented Surface Map

### Authoritative / canonical

* `/.octon/framework/constitution/CHARTER.md` and `/.octon/framework/constitution/precedence/normative.yml` are the top repo-local authority surfaces and explicitly deny authority to labels/comments/checks when canonical control artifacts disagree. ([GitHub][3])
* `/.octon/instance/ingress/manifest.yml` is now the canonical closeout-control surface; it contains the structured `branch_closeout_gate`. `/.octon/instance/ingress/AGENTS.md` explicitly says that gate is canonical and that assistants must stop asking one fixed closeout question after every file-changing turn. ([GitHub][1])
* `/.octon/framework/agency/practices/standards/commit-pr-standards.json`, `github-control-plane-contract.json`, and `ai-gate-policy.json` are the machine-readable contracts for commit/branch/PR grammar, required checks, merge settings, thread-resolution requirement, auto-merge settings, and AI-gate enforcement posture. ([GitHub][4])
* For review remediation specifically, `resolve-pr-comments/SKILL.md` plus its safety references are authoritative for what that capability may and may not do. ([GitHub][5])

### Executable / enforcement

* Local helper scripts: `git-wt-new.sh`, `git-pr-open.sh`, `git-pr-ship.sh`, `git-pr-cleanup.sh`, and the hook install/uninstall scripts are the executable local operator surfaces for worktree creation, PR opening, shipping requests, cleanup, and background convergence. ([GitHub][6])
* GitHub workflow enforcement lives in `.github/workflows/`, especially `main-pr-first-guard.yml`, `commit-and-branch-standards.yml`, `pr-quality.yml`, `pr-autonomy-policy.yml`, `pr-triage.yml`, `ai-review-gate.yml`, `codex-pr-review.yml`, `pr-auto-merge.yml`, `pr-clean-state-enforcer.yml`, and `ci-efficiency-guard.yml`. ([GitHub][7])

### Supporting / policy / operator guidance

* `git-autonomy-playbook.md`, `git-github-autonomy-workflow-v1.md`, `pull-request-standards.md`, `commits.md`, `github-autonomy-runbook.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `daily-flow.md`, and `SHIPPING.md` are the supporting/operator surfaces that explain how to use the canonical contracts and executable helpers. ([GitHub][8])

### Mirrored / projected

* `/.octon/AGENTS.md`, `/AGENTS.md`, and `/CLAUDE.md` are thin parity adapters pointing back to the canonical ingress surface; they are not independent workflow authorities. ([GitHub][9])

### Stale / conflicting

* `pull-request-standards.md` is partly stale because it still instructs “Rebase and force-push cleanup” even though the remediation skill and safety references reject that during review remediation. ([GitHub][10])
* `git-autonomy-playbook.md` still overstates `git-pr-open.sh` as something that “opens or updates the PR,” while the script itself is a **create** helper built around `gh pr create`; subsequent PR updates happen by pushing more commits to the same branch. ([GitHub][8])
* The remediation skill is internally inconsistent because its prose promises commit/push behavior that its own allowed-tools boundary does not authorize. ([GitHub][5])

I did not independently reconstruct the exact historical patch that introduced each change, so this map is a **current-state functional classification**, not a file-age classification.

## 3. What Was Implemented

The biggest implementation change is the **new structured closeout gate** in `manifest.yml`. It now encodes triggers, worktree/branch/PR-state detection probes, autonomous-vs-manual lane conditions, suppression heuristics, and contextual prompts for the main worktree, a branch worktree with no PR, and a branch worktree with a draft PR in either the autonomous or manual lane. `ingress/AGENTS.md` mirrors that logic and explicitly replaces the old “ask one fixed question after any file change” behavior. ([GitHub][1])

The supporting workflow docs were updated to match that model. The playbook and workflow doc now say to keep one clean primary `main` worktree or clone, create **one branch worktree per task/PR**, do implementation and review remediation there, open draft PRs early, and treat helper scripts as accelerators rather than as the durable definition of readiness or mergeability. ([GitHub][8])

The review-thread semantics were also corrected in the human-facing surfaces. The PR template now says reviewer feedback should be addressed while reviewer-owned threads are left for reviewer or maintainer confirmation, and `pull-request-standards.md` now describes “no unresolved author action items remain” as the readiness criterion rather than asking the author to forcibly clear every unresolved thread. ([GitHub][2])

The local cleanup path improved materially. `git-pr-cleanup.sh` now sweeps closed/merged branches, prunes safe linked worktree directories, prints an exact manual `git worktree remove` command when an in-use/current/dirty worktree cannot be removed automatically, and fast-forwards `main`; the hook installer now runs cleanup opportunistically from managed `post-checkout` and `post-merge` hooks. ([GitHub][11])

The GitHub control plane remains intact and aligned with the new docs. Direct pushes to `main` are still blocked, branch naming and PR-template structure are still enforced, autonomy policy and AI review are still evaluated on PRs, the required checks still come from the control-plane contract, `codex-pr-review.yml` remains advisory, and the auto-merge workflow still delegates final mergeability to GitHub rulesets/branch protections rather than inventing a shadow gate. ([GitHub][7])

## 4. Correctness Audit

**Worktree creation and branch creation:** correct. `git-wt-new.sh` exists specifically to create a new branch worktree, validates against the branch contract, defaults to `main` as the base, and runs cleanup preflight first. That is exactly the right Octon-native entry point for isolated work. ([GitHub][6])

**Main worktree vs branch worktree role separation:** correct. The closeout gate treats the main worktree differently, the docs now call it the clean integration anchor, and `git-pr-open.sh` explicitly refuses to open a PR from `main`. That is aligned with the `main` PR-first guard. ([GitHub][1])

**Staging and committing:** correct. `git-pr-open.sh` stages only when asked with `--stage-all`, otherwise commits what is already staged, validates the commit header and PR title against `commit-pr-standards.json`, and uses the PR template. That matches Octon’s commit/PR contract. ([GitHub][12])

**PR creation:** correct. The executable path is branch-only, draft-first by default, template-backed, and issue-link-aware. That matches the current policy surfaces. ([GitHub][12])

**PR update:** operationally correct, but the documentation is not fully tight. Octon’s intended update path is to keep the same branch and same PR for the life of the task and push additional commits, which the docs now say clearly. But `git-pr-open.sh` itself does not update an existing PR; it is a creation helper, and the playbook still overstates it as “opens or updates” the PR. ([GitHub][13])

**Draft vs ready transition:** mostly correct. The docs and ingress contract now treat “ready” as a state that should happen only when the work is complete, the lane is correct, and no unresolved author action items remain. But the canonical closeout contract still does not fully specify how an already-ready PR should be handled. ([GitHub][1])

**Required checks and merge execution:** correct. The required `main` checks are machine-declared in `github-control-plane-contract.json`, and the workflows implement them. `pr-auto-merge.yml` still uses GitHub’s merge endpoint and explicitly leaves required-check truth to rulesets/branch protections. ([GitHub][14])

**Review-feedback remediation:** mostly correct. The repo now correctly distinguishes author-side remediation from reviewer-owned resolution, but the stale force-push line in PR standards and the remediation skill’s tools mismatch keep this from being fully coherent. ([GitHub][10])

**Merge-lane selection:** correct. The lane rules are now aligned across ingress and GitHub triage: `exp/*`, high-impact governance/control-plane changes, and major/unknown Dependabot transitions are manual-lane; everything else is eligible for the autonomous lane subject to checks and policy. ([GitHub][15])

**Post-merge cleanup and convergence:** correct and improved. The repo now cleans both refs and safe linked-worktree directories, returns local state to `main`, and also has a remote clean-state enforcer loop for stale PR/branch hygiene. ([GitHub][11])

## 5. Autonomy and Authority-Boundary Audit

The implementation is now autonomous in the **right general Octon-native way**. It automates branch-worktree creation, draft PR opening, readiness/auto-merge requests, cleanup, and remote merge polling, while still leaving final authority with GitHub rulesets, required checks, and reviewer/maintainer confirmation. The repo also explicitly treats labels and similar projections as non-authoritative, and Codex review remains advisory instead of being smuggled in as merge authority. ([GitHub][6])

That said, autonomy is not yet **fully** coherent at every boundary. `git-pr-ship.sh` is still a mutating helper with eager defaults: it marks draft PRs ready and requests squash auto-merge unless told otherwise, and it does so without an explicit built-in readiness assertion. The docs now explain that the script does **not** prove readiness, which avoids a control-plane violation, but the executable helper is still easier to overuse than the new closeout contract ideally allows. ([GitHub][16])

The bigger autonomy defect is in review remediation. The repo clearly wants an autonomous **fix, commit, push, reply** loop, but the capability surface that is supposed to do that still does not authorize the git operations it claims to perform. That is not a GitHub authority violation, but it is an autonomy-completeness problem. ([GitHub][5])

## 6. Review-Thread / Conversation Audit

This part is substantially corrected. The current implementation **does not** literalize the old “resolve any open conversations” phrasing. Instead, the PR template now says reviewer feedback should be addressed while reviewer-owned threads are left for reviewer or maintainer confirmation; the PR standards say readiness means no unresolved **author** action items remain; and the remediation skill explicitly says not to take reviewer-owned thread resolution away from reviewers and never to dismiss or resolve PR comments programmatically. ([GitHub][2])

At the same time, the control-plane contract still requires review-thread resolution before merge. So the repo’s current operational meaning is the correct Octon one: the author/agent should **fix, commit, push, and reply**; if reviewer-owned unresolved threads remain, merge is supposed to stay blocked until reviewer or maintainer confirmation resolves them. That is the right adaptation of your conceptual end-of-work flow. ([GitHub][14])

The remaining defect here is internal coherence, not the policy itself. `pull-request-standards.md` still contains the stale rebase/force-push instruction, and the remediation skill still lacks the git authority it claims to need. So the repo now has the **right thread-resolution semantics**, but the **execution contract for doing the remediation** still needs tightening. ([GitHub][10])

## 7. Closeout Logic Audit

The closeout implementation is a real improvement and mostly correct. The logic is now in the **manifest**, not hidden in prose; ingress `AGENTS.md` explicitly binds to it; prompts are context-aware; and suppression exists for active implementation, red checks, unresolved author action items, and ready PRs waiting on reviewer or maintainer confirmation. That is exactly the right architectural move. ([GitHub][1])

The implementation also correctly distinguishes the main worktree from branch worktrees and distinguishes a branch worktree with no PR from one with a draft PR in either lane. That satisfies the core closeout-governance requirement much better than the old scalar question ever could. ([GitHub][1])

The gap is that `ready_pr` exists as a declared context in the canonical manifest, but there is **no corresponding `prompt_by_context` or status-handling entry** for it. As a result, a branch that already has a ready PR is not fully encoded at the authoritative layer, even though the prose says ready PRs waiting on reviewer confirmation should suppress closeout prompts. That means the implementation is close, but still incomplete. ([GitHub][1])

There is also still a mild terminology collision: the closeout gate uses `ship` as an explicit trigger word, while `daily-flow.md` and `SHIPPING.md` use “ship” for the **post-merge production-promotion** process. Context can usually disambiguate that, but the ambiguity is still present in the repo. ([GitHub][1])

## 8. Main vs Branch Worktree Audit

This is now implemented correctly. The repo’s workflow surfaces consistently treat the primary `main` worktree/clone as the clean integration anchor and the branch worktree as the normal execution cell for one task/PR. The helper script for PR opening refuses `main`, the closeout gate prompts a branch/worktree hop from `main`, and the docs say to keep the same branch and same PR for the life of the task. ([GitHub][12])

That model fits Codex App well. The playbook now explicitly supports one task/PR per worktree, multiple concurrent branch worktrees, same-worktree review remediation, and cleanup back to a clean steady state. `git-pr-cleanup.sh` now also handles the linked-worktree filesystem lifecycle far better than before. ([GitHub][8])

## 9. Gap and Defect List

1. **Material:** `pull-request-standards.md` still instructs “Rebase and force-push cleanup,” which conflicts with the review-remediation skill and safety references that require new commits and forbid force-push/rebase during remediation. ([GitHub][10])

2. **Material:** the canonical `branch_closeout_gate` declares a `ready_pr` context but does not encode the assistant behavior for that context. Already-ready PRs therefore remain under-specified in the authoritative contract. ([GitHub][1])

3. **Material:** `resolve-pr-comments/SKILL.md` promises a fix/commit/push/reply loop, but its allowed-tools boundary only authorizes `Bash(gh)`, and the safety references explicitly say it does not have `git push`, amend, or rebase access. That leaves review-remediation autonomy only partially implemented. ([GitHub][5])

4. **Moderate:** `git-autonomy-playbook.md` still says `git-pr-open.sh` “opens or updates the PR,” but the helper is a create-oriented script built around `gh pr create`. That is a documentation drift issue around PR-update semantics. ([GitHub][8])

5. **Moderate:** `git-pr-ship.sh` still has eager defaults that mutate PR state without an explicit built-in readiness assertion. The docs now explain the boundary correctly, but the helper itself is still easier to overuse than ideal. ([GitHub][16])

6. **Minor:** the trigger word `ship` still collides with Octon’s production-shipping terminology in `daily-flow.md` and `SHIPPING.md`. ([GitHub][1])

## 10. Exact Required Follow-Up Changes

### Required before the workflow can be called complete

`/.octon/framework/agency/practices/pull-request-standards.md`
Replace the stale “Rebase and force-push cleanup” instruction with language that matches the live remediation policy. The simplest correct replacement is: **prefer new commits while a PR is under review; do not rebase, amend, or force-push during remediation unless a human explicitly asks for that history rewrite; never merge `main` into the branch.** That would align the PR standard with the remediation skill and `commits.md`. ([GitHub][10])

`/.octon/instance/ingress/manifest.yml`
Add explicit handling for `ready_pr`. The minimal correct change is to keep closeout **suppressed** for ready PRs and add status responses such as: “This PR is already ready and waiting on checks/auto-merge,” “This PR is already ready in the manual lane and waiting on human review/merge,” and “This PR is ready but still waiting on reviewer or maintainer confirmation.” Right now the canonical contract declares `ready_pr` but does not encode it. ([GitHub][1])

`/.octon/instance/ingress/AGENTS.md`
Mirror the same explicit `ready_pr` handling from the manifest so ingress parity remains honest. The current prose already suppresses some ready-PR cases, but it should bind to an explicit canonical `ready_pr` contract instead of leaving that state implicit. ([GitHub][15])

`/.octon/framework/capabilities/runtime/skills/remediation/resolve-pr-comments/SKILL.md` and `.../references/safety.md`
Choose one coherent model and encode it consistently. Since Octon clearly wants an autonomous remediation loop, the better fix is to **authorize safe git operations needed for that loop**—for example `git status`, `git add`, `git commit`, and `git push`—while still prohibiting `--amend`, rebase, and force-push. If Octon does **not** want that autonomy inside the skill, then the prose must stop claiming the skill itself performs commit/push. Right now the capability contract contradicts itself. ([GitHub][5])

`/.octon/framework/agency/practices/git-autonomy-playbook.md`
Change “Opens or updates the PR in draft-first posture” to something accurate, such as: **“Opens the draft PR; later updates are pushed to the same branch and reflected on the same PR.”** That would align the playbook with `git-pr-open.sh` and with the workflow doc’s “same branch, same PR” model. ([GitHub][8])

### Recommended hardening, but not strictly required for minimum conformance

`/.octon/framework/agency/_ops/scripts/git/git-pr-ship.sh`
Add a non-mutating `--status` or `--assert-ready` mode so higher-level automation can verify state before making the ready/automerge request. The docs now explain the helper boundary correctly, so this is hardening rather than a prerequisite for baseline correctness. ([GitHub][16])

## 11. Acceptance Judgment

My acceptance judgment is: **not yet honestly claimable as complete**. The repository now implements the **right Octon-native workflow shape** and it has fixed the most important conceptual error by moving from “resolve all conversations” to “address author action items; leave reviewer-owned thread resolution to reviewer/maintainer confirmation under GitHub’s merge gate.” But the implementation still has unresolved authoritative-layer drift in PR standards, an incomplete canonical `ready_pr` closeout state, and a review-remediation capability whose tool boundary does not match its own promised behavior. ([GitHub][2])

Once those required follow-up changes land, I think the repo would be able to claim, honestly, that it has a **correct, coherent, Octon-native Git/GitHub/worktree/closeout workflow** that is suitable for heavy Codex App use and preserves the right autonomy boundaries.

[1]: https://github.com/jamesryancooper/octon/blob/main/.octon/instance/ingress/manifest.yml "octon/.octon/instance/ingress/manifest.yml at main · jamesryancooper/octon · GitHub"
[2]: https://github.com/jamesryancooper/octon/blob/main/.github/PULL_REQUEST_TEMPLATE.md "octon/.github/PULL_REQUEST_TEMPLATE.md at main · jamesryancooper/octon · GitHub"
[3]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/constitution/CHARTER.md "raw.githubusercontent.com"
[4]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/practices/standards/commit-pr-standards.json "raw.githubusercontent.com"
[5]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/capabilities/runtime/skills/remediation/resolve-pr-comments/SKILL.md "raw.githubusercontent.com"
[6]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/_ops/scripts/git/git-wt-new.sh "raw.githubusercontent.com"
[7]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.github/workflows/main-pr-first-guard.yml "raw.githubusercontent.com"
[8]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/practices/git-autonomy-playbook.md "raw.githubusercontent.com"
[9]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/AGENTS.md "raw.githubusercontent.com"
[10]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/practices/pull-request-standards.md "raw.githubusercontent.com"
[11]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/_ops/scripts/git/git-pr-cleanup.sh "raw.githubusercontent.com"
[12]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/_ops/scripts/git/git-pr-open.sh "raw.githubusercontent.com"
[13]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/practices/git-github-autonomy-workflow-v1.md "raw.githubusercontent.com"
[14]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/practices/standards/github-control-plane-contract.json "raw.githubusercontent.com"
[15]: https://github.com/jamesryancooper/octon/blob/main/.octon/instance/ingress/AGENTS.md "octon/.octon/instance/ingress/AGENTS.md at main · jamesryancooper/octon · GitHub"
[16]: https://raw.githubusercontent.com/jamesryancooper/octon/main/.octon/framework/agency/_ops/scripts/git/git-pr-ship.sh "raw.githubusercontent.com"
