# Migration Cutover Plan

## Cutover classification

This packet is an **additive same-root hardening refinement**, not a topology
migration and not a multi-epoch control-plane cutover.

The live workflow already exists. The required change is to tighten how its
meaning is declared and validated.

## Why a big-bang migration is unnecessary

The packet does **not** require:

- a new top-level root
- a new host adapter family
- a new support-target tuple
- a new source-control provider abstraction
- replacement of GitHub as the current host merge gate

The repo already has the correct durable surfaces; they simply need one tighter
contract and better synchronization.

## Preferred cutover motion

1. Add the canonical workflow contract.
2. Update ingress and practice surfaces to consume it.
3. Update remediation skill boundaries in the same branch.
4. Flip `git-pr-ship.sh` to status-first, explicit-action behavior in the same
   branch.
5. Align `.github/**` companion surfaces in the same branch.
6. Land validator coverage in the same branch.

## Compatibility posture

- Keep `ship` as a compatibility alias in ingress trigger vocabulary if
  required, but standardize durable operator wording on `closeout`, `ready`,
  and `request auto-merge`.
- If helper CLI changes would surprise current operators, keep a short
  deprecation window with explicit warnings. Because the repo is `pre-1.0`,
  long-lived dual semantics are not required.

## Rollback posture

Rollback should be **whole-branch**, not piecemeal.

If the hardening proves unsafe:

1. revert the workflow contract, ingress parity, helper changes, and validator
   as one unit
2. revert companion `.github/**` changes in the same rollback
3. do not leave mixed old/new remediation semantics behind

## Cutover done-gate

Cutover is complete only when:

- the new contract exists
- ingress `ready_pr` handling is explicit
- remediation policy surfaces agree
- helper semantics are explicit-action and status-first
- the validator passes
- plain Git and helper-lane scenarios both pass
