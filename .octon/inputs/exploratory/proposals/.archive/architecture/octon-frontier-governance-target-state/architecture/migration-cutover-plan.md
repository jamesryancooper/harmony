# Migration and Cutover Plan

## Cutover posture

The transition must be additive, fail-closed, and evidence-preserving. No proposal-local artifact becomes runtime authority. Durable changes must land under declared promotion targets and stand alone after this packet is archived.

## Migration principles

1. **Authority before execution:** fix support/overlay/cognition drift before widening runtime behavior.
2. **Stage before live:** browser/API/multimodal support remains stage-only until executable services and support dossiers exist.
3. **Evidence before claim:** no support target, adapter, or capability pack is live without retained proof.
4. **Run-first continuity:** missions remain continuity containers; runs remain atomic consequential execution units.
5. **Generated remains derived:** generated cognition and generated effective projections can assist runtime only when freshness and publication receipts are current; they never mint authority.
6. **Rollback before side effect:** material actions require rollback/compensation posture where materiality demands it.

## Cutover waves

### Wave A — Proposal staging

- Materialize this packet under the active architecture proposal path.
- Regenerate `/.octon/generated/proposals/registry.yml` from manifests.
- Validate proposal structure against proposal and architecture proposal standards.
- Do not wire proposal files into runtime/policy.

### Wave B — Authority drift correction

- Patch support-target vocabulary mismatch.
- Patch overlay registry/README/instance manifest mismatch.
- Patch cognition runtime index drift.
- Quarantine experimental external adapter or make stage-only enforcement explicit.
- Produce migration receipts and decision records.

### Wave C — Contract addition

- Add context-pack, risk/materiality, rollback-plan, browser/UI, API-egress, benchmark, RunCard, and HarnessCard contracts.
- Update contract registry if required.
- Add validation tests for schema shape and cross-reference integrity.

### Wave D — Runtime integration

- Extend execution request/grant/receipt and authorization logic.
- Add context assembler and context-pack evidence emission.
- Add runtime checks for rollback and egress prerequisites.
- Bind new receipts to existing run evidence roots.

### Wave E — Simplification and deletion

- Run workflow audit.
- Demote/delete thinking-only workflows.
- Simplify actor and capability documentation.
- Retire compatibility shims with expiration criteria.
- Confirm no durable target references proposal paths.

### Wave F — Browser/API admission

- Keep packs stage-only unless runtime services and support dossiers exist.
- Add browser/API service contracts and implementations.
- Add event/replay/evidence records.
- Add support-target tuple admission only after proof.

### Wave G — Assurance closeout

- Run structural, governance, runtime, support, recovery, evidence, and benchmark validators.
- Generate RunCards/HarnessCards from evidence.
- Record ADR/decision closeout.
- Archive packet only after durable targets stand alone.

## Evidence continuity

Retain migration evidence under `state/evidence/validation/**` and run/lab evidence roots. The migration must not delete historical evidence. Deletions/demotions should produce receipts identifying:

- removed path or demoted surface;
- replacement path or reason no replacement is required;
- affected support claims;
- validator status;
- rollback plan for migration itself.

## Runtime continuity

Compatibility wrappers may remain temporarily only if they route to canonical run-first lifecycle and emit canonical receipts. Any wrapper that creates a second execution path must be removed or made fail-closed.

## Rollback posture for the migration

Each wave should be reversible or compensable:

- Wave A rollback: remove proposal packet and regenerate proposal registry.
- Wave B rollback: restore prior support/overlay/cognition files while preserving drift evidence.
- Wave C rollback: remove unreferenced new schemas before runtime integration.
- Wave D rollback: disable new runtime checks behind hard-enforce-compatible flags while retaining receipts.
- Wave E rollback: restore optional workflows from archive/practice pack if deletion breaks operators.
- Wave F rollback: demote browser/API tuples to stage-only and remove runtime manifest entries.
- Wave G rollback: retain failed assurance evidence and block certification.
