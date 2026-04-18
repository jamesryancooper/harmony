# Repository Baseline Audit

## 1. Current workflow lineage

Observed current state:

- the earlier architecture packet
  `/.octon/inputs/exploratory/proposals/.archive/architecture/git-github-workflow/`
  is archived as implemented
- the live repo already contains worktree creation, draft-PR creation,
  ready/automerge request, and cleanup helpers
- the current request is therefore a follow-on hardening exercise, not a first
  introduction of the workflow

## 2. Current authoritative workflow surfaces

Observed current state:

- ingress `manifest.yml` is the canonical closeout contract source
- ingress `AGENTS.md` projects that contract in prose
- workflow docs explicitly describe a worktree-capable Git environment rather
  than one mandatory host app
- the GitHub control-plane contract already keeps final merge authority in
  GitHub rulesets and checks

## 3. Audit-confirmed drift points rechecked locally

Observed current state:

- `/.octon/instance/ingress/manifest.yml` declares `ready_pr` but does not
  define explicit prompt or status handling for that context
- `/.octon/framework/agency/practices/pull-request-standards.md` still contains
  `Rebase and force-push cleanup. Don't merge \`main\` into the branch.`
- `resolve-pr-comments/SKILL.md` promises commit/push behavior while its
  allowed-tools boundary remains `Bash(gh)` only
- the matching safety reference says push is unavailable, which confirms the
  inconsistency
- `git-autonomy-playbook.md` still says `git-pr-open.sh` "opens or updates the
  PR"
- `git-pr-ship.sh` still defaults to ready and auto-merge mutation when run
  without explicit action selection

## 4. Repo fit conclusion

The live repo already has the right workflow primitives and the right host
authority boundary. The remaining need is to harden **coherence**:

- one canonical workflow contract
- one explicit closeout state machine
- one consistent remediation policy
- one validator that proves those statements stay aligned
