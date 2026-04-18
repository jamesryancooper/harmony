# Assumptions and Blockers

## Assumptions

- The default branch is `main`.
- Proposal packets remain non-canonical and temporary under `/.octon/inputs/exploratory/proposals/**`.
- Promotion scope for this packet is `octon-internal`; all promotion targets are under `.octon/**`.
- Existing root invariants remain binding: only `framework/**` and `instance/**` are authored authority; `state/**` is operational truth/evidence; `generated/**` is rebuildable; `inputs/**` is non-authoritative.
- The review included in `resources/frontier-governance-architecture-review.md` is the required upstream analytical source.
- Browser/API/multimodal support should not be live without runtime services, evidence, support dossiers, and validation.

## Blockers before implementation promotion

- Run Octon's local proposal validators against this packet.
- Run support-target schema validation after vocabulary reconciliation.
- Decide whether to rename `bounded-admitted-live-universe` or extend the schema to include it.
- Decide whether overlay registry or README is canonical where they currently diverge; update the other surface accordingly.
- Validate cognition runtime index against actual checked-out tree.
- Determine exact schema versioning path for execution request/grant/receipt changes.
- Confirm whether browser-session and api-client service contract files already exist in the current checkout but are not active in runtime manifest, or need to be added.
- Define acceptance thresholds for comparative frontier benchmarks.

## Known limits of this packet

- This packet does not include executable code patches.
- This packet does not run the runtime or validators.
- This packet does not prove browser/API support is live.
- This packet does not modify generated registry outputs; it expects registry regeneration after materialization.
- This packet proposes durable promotion targets that may require follow-up schema and implementation design.

## Open questions

1. Should `support_claim_mode` settle on `bounded-admitted-finite`, or should the schema add `bounded-admitted-live-universe` with exact semantics?
2. Should context-pack contracts live under `framework/constitution/contracts/runtime/**`, `framework/engine/runtime/spec/**`, or both with one referencing the other?
3. Should RunCard/HarnessCard contracts be under constitution assurance contracts, assurance runtime, or both?
4. What minimum browser/UI replay fidelity is acceptable for live support?
5. What minimum API egress trace/redaction/compensation evidence is acceptable for live support?
6. What raw frontier-model baseline tasks are representative enough to prove governance value?
