# Full Concept Integration Assessment

## 1. Environment-neutral worktree contract

### Current state

The docs already say "any worktree-capable Git environment" in several places,
but the live workflow still leans on helper semantics and host-specific reading
habits for operator clarity.

### Recommended integration

Introduce one machine-readable workflow contract that defines:

- primary `main` worktree or clone as the integration anchor
- one branch worktree per task or PR
- same branch and same PR for the life of the task
- plain Git lane and helper lane as equally valid execution paths

### Why this is the right layer

This is narrower than a new control plane and stronger than prose-only docs.
It gives validators one stable surface to defend.

## 2. Explicit ready-state closeout handling

### Current state

`ready_pr` exists in ingress detection, but the authoritative contract does not
say what happens when a PR is already ready.

### Recommended integration

Encode ready-state handling explicitly:

- waiting on checks or auto-merge
- waiting on reviewer or maintainer confirmation
- manual-lane ready and waiting on human review or merge

These are status responses, not new closeout prompts.

### Why this is the right layer

This is core ingress behavior. If it stays implicit, every adapter or helper
must guess.

## 3. Review-remediation policy and capability coherence

### Current state

The live repo clearly wants new-commit remediation, but one doc still says
force-push cleanup and the remediation skill cannot actually perform the full
loop it promises.

### Recommended integration

Make the durable rule:

- fix
- commit
- push
- reply
- never amend
- never rebase
- never force-push
- never resolve reviewer-owned threads programmatically

Then give the skill the minimal safe Git authority needed to do what it says.

### Why this is the right layer

This closes the contradiction at the contract boundary instead of hiding it in
operator folklore.

## 4. Helper semantics hardening

### Current state

Helper docs and behavior are still easier to overread than the durable policy
allows.

### Recommended integration

- keep `git-pr-open.sh` create-oriented
- move `git-pr-ship.sh` to status-first and explicit-action semantics
- keep helper output explicit that GitHub is the final merge authority

### Why this is the right layer

This preserves helpers as accelerators while making misuse harder.

## 5. Drift detection

### Current state

Cross-surface workflow drift is currently easy to reintroduce because there is
no validator focused on this exact class of mismatch.

### Recommended integration

Add one dedicated validator and one small test suite that check the workflow
contract against ingress, docs, skill text, and helper semantics.

### Why this is the right layer

The audit defects are systematic. They need systematic detection.
