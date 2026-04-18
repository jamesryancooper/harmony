# Validation Plan

## 1. Proposal-structure validation

Before any implementation work is accepted, the packet itself must pass:

1. `bash .octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh --package ".octon/inputs/exploratory/proposals/architecture/git-github-autonomous-workflow-hardening"`
2. `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-proposal.sh --package ".octon/inputs/exploratory/proposals/architecture/git-github-autonomous-workflow-hardening"`

## 2. Static contract-alignment validation

Add one dedicated alignment validator that checks at least:

- ingress manifest and ingress `AGENTS.md` stay in parity for closeout contexts
- `ready_pr` has explicit handling and does not silently fall through
- `pull-request-standards.md` no longer instructs rebase/amend/force-push
  remediation
- playbook and overview no longer overstate helper capabilities
- remediation skill prose matches its allowed-tools boundary
- helper text does not claim to prove mergeability or readiness

## 3. Scenario validation

The hardened workflow must be demonstrated in **both** of the following
operator lanes.

### Lane A — Plain Git + GitHub

Required proof scenarios:

1. create a branch worktree with standard `git worktree` commands
2. make changes and commit with plain Git
3. push the same branch and open a draft PR through `gh`
4. add follow-up commits to the same branch and confirm the same PR updates
5. transition a draft PR to ready only when checks and author action items are
   satisfied
6. observe ready-state handling when the PR is waiting on checks, auto-merge,
   reviewer confirmation, or manual-lane review

### Lane B — Octon helper lane

Required proof scenarios:

1. `git-wt-new.sh` creates the branch worktree
2. `git-pr-open.sh` creates the draft PR
3. `git-pr-ship.sh` reports status with no action flags
4. explicit action flags request ready and auto-merge transitions
5. helper output still states that GitHub remains the final merge gate

## 4. Review-remediation validation

Required proof scenarios:

1. author addresses review feedback with new commits, not history rewrite
2. branch update is pushed before the author replies that the code changed
3. reviewer-owned threads are left unresolved by the author
4. manual and autonomous lanes both respect the same remediation safety rules

## 5. Multi-worktree cleanup validation

Required proof scenarios:

1. merged branch cleanup converges refs safely
2. linked-worktree pruning stays safe when another worktree is current, dirty,
   or in use
3. cleanup output prints an exact manual follow-up when automatic removal is
   not safe

## 6. Evidence expectations

The implementation branch should retain:

- validator transcripts
- scenario notes or receipts proving both plain Git and helper-lane execution
- evidence of `ready_pr` suppression/status behavior
- evidence that remediation policy surfaces and tool boundaries agree

No new evidence family is required. Existing validation and run evidence roots
remain sufficient.
