# Evidence Plan

This plan defines the evidence that must exist **before**, **during**, **after**, and **at certification** so that a future auditor can reconstruct the governing objective, authority route, changes made, validation executed, and closure outcome.

## 1. Before Cutover

Required baseline evidence:
- current bounded-support HarnessCard
- representative consequential run contract and run manifest
- current source-of-truth classification snapshot
- current support-target matrix snapshot
- current legacy surface inventory
- current proof-plane coverage snapshot
- current mirror/parity inventory

Required artifact locations:
- `/.octon/state/evidence/disclosure/releases/<pre-cutover-release-id>/harness-card.yml`
- `/.octon/state/control/execution/runs/**/run-contract.yml`
- `/.octon/state/control/execution/runs/**/run-manifest.yml`
- `/.octon/instance/governance/support-targets.yml`
- `/.octon/framework/agency/runtime/agents/architect/**` (inventory before deletion)

## 2. During Cutover

Evidence collected while implementing the cutover branch:
- branch freeze record
- schema migration diffs
- retirement decisions
- support-target admission diffs
- capability pack manifest creation diffs
- authority centralization diffs
- workflow changes
- pass-1 validator outputs

Required artifact locations:
- `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/`
- `/.octon/instance/governance/decisions/ADR-UEC-00*.md`
- CI artifacts from `uec-cutover-validate`

## 3. After Cutover (Before Certification Close)

Evidence that the merged tree reflects the target state:
- regenerated RunCards
- regenerated HarnessCard
- proof-plane coverage report
- support-target consistency report
- authority centralization report
- intervention completeness report
- retirement register
- pass-2 no-diff report

Required artifact locations:
- `/.octon/state/evidence/disclosure/runs/**/run-card.yml`
- `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/harness-card.yml`
- `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/**`

## 4. Certification Evidence

The certifier must be able to reconstruct:

### Objective
- workspace charter
- mission charter (if used)
- run contract
- stage attempts
- release objective as recorded in the closure ADR

### Governing source
- constitutional kernel
- source-of-truth map
- support-target matrix
- capability pack manifests
- authority contracts

### Route / authority
- decision artifact
- approval/grant bundle
- exception lease / revocation / quorum policy where applicable
- host projection parity proof

### Change set
- file-change map
- git diff / merge record
- retirement register
- ADR set

### Validation results
- pass-1 evidence bundle
- pass-2 evidence bundle
- second-pass no-diff report

### Closure outcome
- closure summary
- closure certificate
- final HarnessCard
- durable closeout ADR

## 5. Evidence Sufficiency Rule

Evidence is sufficient only if it allows a future auditor to answer all of the following without oral explanation:

1. What was the governing target state?
2. Which repository surfaces were authoritative?
3. Which gaps were closed?
4. Which validators proved closure?
5. Which run/release artifacts were regenerated?
6. Did the second pass change anything?
7. Why was the final claim honest?

If the answer to any question is “not reconstructable from retained artifacts,” certification fails.
