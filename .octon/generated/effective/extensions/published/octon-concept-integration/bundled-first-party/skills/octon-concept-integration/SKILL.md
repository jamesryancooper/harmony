---
name: octon-concept-integration
description: >
  Composite extension-pack skill that turns a source artifact into extracted,
  verified, and selected Octon concepts, a manifest-governed architecture
  proposal packet, and a packet-specific executable implementation prompt.
license: MIT
compatibility: Designed for Octon extension-pack publication and host projection.
metadata:
  author: Octon Framework
  created: "2026-04-13"
  updated: "2026-04-14"
skill_sets: [executor, integrator, specialist]
capabilities: [self-validating]
allowed-tools: Read Glob Grep Write(/.octon/inputs/exploratory/proposals/*) Write(/.octon/state/control/skills/checkpoints/*) Write(/.octon/state/evidence/runs/skills/*)
---

# Octon Concept Integration

Run the concept-integration pipeline from source artifact to validated
proposal packet and packet-specific executable implementation prompt.

## When To Use

- You have an external source artifact and want a repository-grounded Octon
  proposal packet.
- You want extraction, verification, packetization, and implementation-prompt
  generation handled as one bounded capability.
- You want a reusable extension-pack capability rather than a repo-native
  one-off analysis flow.

## Core Workflow

1. Normalize the source artifact and any explicit selected-concepts override.
2. Resolve the effective prompt bundle and its retained alignment receipt.
   Use `/.octon/framework/orchestration/runtime/_ops/scripts/resolve-extension-prompt-bundle.sh`
   as the deterministic decision point for prompt bundle freshness and
   alignment mode handling.
3. If `alignment_mode=auto`, use the fresh bundle, realign and republish it,
   or fail closed when re-alignment cannot make the bundle safe to run.
4. If `alignment_mode=skip`, record degraded execution and continue only with
   explicit retained disclosure.
5. Run concept extraction using the published prompt bundle rather than raw
   prompt rereads as the default runtime path.
6. Run concept verification against the live repository.
7. Resolve the in-scope concept set.
8. Generate a manifest-governed architecture proposal packet under
   `/.octon/inputs/exploratory/proposals/architecture/<proposal_id>/`.
9. Generate a packet-specific executable implementation prompt as proposal
   support material when requested.
10. Validate the generated proposal packet and retain run evidence, including
    prompt bundle provenance.

The skill owns the intermediate artifacts for this flow. Extraction and
verification outputs should be materialized by the capability into pack-managed
artifacts rather than treated as user-supplied thread context.
The skill should also retain which prompt bundle and alignment receipt each run
used.

## Inputs

- source artifact
- optional selected-concepts subset
- optional proposal id override
- optional alignment mode

## Outputs

- proposal packet under `/.octon/inputs/exploratory/proposals/architecture/`
- retained run evidence under `/.octon/state/evidence/runs/skills/`
- optional checkpoints under `/.octon/state/control/skills/checkpoints/`
- intermediate extraction and verification artifacts under the run checkpoint
  root and copied into packet support files when packetization succeeds
- retained prompt bundle provenance and alignment receipt references in the run
  evidence

## Boundaries

- Additive only. Do not mint authority from raw pack paths.
- Proposal packets remain non-canonical.
- The landed capability must use the published prompt bundle and retained
  alignment receipts rather than raw prompt rereads as the default runtime
  path.
- Do not auto-implement the proposal packet as part of this skill.

## When To Escalate

- The source artifact is missing or unreadable.
- The prompt set is materially drifted and the alignment pass cannot resolve
  the conflict.
- The requested packet scope would require support-target widening or a new
  governed capability-pack family.
- The generated proposal packet fails validators for reasons not attributable
  to the source or user scope.

## References

- `references/phases.md`
- `references/io-contract.md`
- `references/validation.md`
- `references/decisions.md`
