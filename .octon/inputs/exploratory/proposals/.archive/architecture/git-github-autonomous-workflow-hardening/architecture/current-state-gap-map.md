# Current State Gap Map

## 1. What is already correct and should be preserved

The current repo already expresses the right base model in several important
places:

- one clean primary `main` worktree or clone as the integration anchor
- one branch worktree per task or PR
- draft-first PR creation from branch worktrees
- GitHub rulesets and required checks as the final merge gate
- reviewer-owned thread resolution left to reviewer or maintainer confirmation
- safe linked-worktree pruning during cleanup

This packet is not a request to replace that shape.

## 2. Material hardening gaps

| Gap ID | Current state | Risk if left live | Packet hardening move |
|---|---|---|---|
| `G1` | `branch_closeout_gate` declares `ready_pr` but does not define authoritative handling for it | ready PRs remain under-specified in the most authoritative workflow surface | add explicit ready-state contexts, suppression rules, and status responses in ingress plus parity prose |
| `G2` | `pull-request-standards.md` still says "Rebase and force-push cleanup" during review responsiveness | authors can rewrite history during remediation even though the live review model depends on new commits and reviewer-owned thread confirmation | align all remediation prose around new commits only, no rebase, no amend, no force-push unless a human explicitly asks |
| `G3` | `resolve-pr-comments` promises fix, commit, push, reply, but allowed-tools only authorize `gh` and the safety file says push is unavailable | the skill's behavioral promise is not executable as written | authorize a safe Git subset for remediation or narrow the promise; this packet chooses safe Git subset authorization with strict prohibitions |
| `G4` | helper semantics still drift from docs: `git-pr-open.sh` is described as "opens or updates" and `git-pr-ship.sh` still defaults to eager mutation | helper use can outrun actual readiness and operator expectations | define helper semantics centrally and move `git-pr-ship.sh` to a status-first, explicit-action model |
| `G5` | the workflow is described as worktree-capable, but there is no dedicated validator proving cross-surface alignment or environment-neutral execution | the repo can regress back into helper-only or app-specific assumptions without a fail-closed signal | add one machine-readable workflow contract plus one drift validator and scenario matrix |
| `G6` | the word `ship` still pulls double duty for PR-closeout intent and production shipping terminology | operator language is slightly ambiguous at closeout time | keep `ship` only as compatibility vocabulary and standardize durable operator wording on `closeout`, `ready`, and `request auto-merge` |

## 3. Gaps that are intentionally not reopened here

These areas are already directionally correct and do not justify new
architecture work in this packet:

- GitHub rulesets/checks as the final merge gate
- reviewer-owned thread resolution blocking merge
- draft-first PR posture
- same branch and same PR for the life of a task
- safe linked-worktree cleanup after closure
- Codex review remaining advisory and non-blocking

## 4. Why this is a hardening packet instead of a patch list

The audit defects are mostly not isolated typos. They are **cross-surface
coherence failures**:

- one surface declares a state without authoritative behavior
- one surface promises actions another surface forbids
- helper defaults and docs allow the same operator state to be read two
  different ways
- environment-neutral intent exists, but proof of that intent is weak

That is architecture-hardening territory, not just documentation cleanup.
