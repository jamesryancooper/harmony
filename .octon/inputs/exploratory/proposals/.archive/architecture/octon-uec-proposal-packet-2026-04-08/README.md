# Octon Unified Execution Constitution Full-Attainment Proposal Packet

## Problem Being Closed

Octon now has the shape of a unified execution constitution, but it still stops short of the full target-state because the current live claim is bounded, the objective stack is not yet fully normalized, several governance and replay guarantees are not yet proven end to end, and a small but material set of legacy and shadow-risk surfaces still remain. This packet closes the gap between **bounded-support constitutional execution** and **full Unified Execution Constitution attainment**.

This packet treats the repository audit as the authoritative current-state evidence baseline and the target-state design positions preserved in the thread as the authoritative normative end state. The packet is written so that implementation can proceed directly from it without inventing missing architecture.

## What This Packet Changes

This packet defines the full target-state constitution Octon must satisfy, normalizes every remaining audit finding into a concrete remediation item, specifies one atomic big-bang cutover, defines the blocking validators and closure evidence required for certification, classifies every touched artifact by authority status, and sets the exact claim conditions under which Octon may honestly state that the Unified Execution Constitution is fully attained.

## What This Packet Explicitly Does Not Change

This packet does **not** loosen the target-state design, preserve bounded live-claim exclusions, tolerate shadow authority, accept partial proof planes, accept host-native authority, or permit a phased partially compliant steady state on `main`. It also does **not** promote proposal artifacts, generated views, or exploratory inputs into live authority.

## Exact Required Repository End State

After cutover, Octon must satisfy all of the following simultaneously:

1. One authoritative constitutional kernel under `/.octon/framework/constitution/**` plus repo-specific authority under `/.octon/instance/**`.
2. One legal objective stack: workspace charter + mission charter (when required) + run contract + stage attempt.
3. One canonical authority regime: approval/grant/lease/revocation/decision artifacts minted only from canonical runtime/governance surfaces; host systems are projections only.
4. One durable run model: every consequential run binds exactly one canonical run control root and one canonical evidence root before side effects.
5. One tri-class evidence regime: git-inline, git-pointer, and external-immutable evidence linked by hashes and provenance.
6. One truthful disclosure regime: RunCards and HarnessCards generated from canonical surfaces and truthful about the admitted support universe.
7. One full support universe with no in-scope exclusions:
   - model tiers: `repo-local-governed`, `frontier-governed`
   - host adapters: `repo-shell`, `github-control-plane`, `ci-control-plane`, `studio-control-plane`
   - workload tiers: `observe-and-read`, `repo-consequential`, `boundary-sensitive`
   - language resource tiers: `reference-owned`, `extended-governed`
   - locale tiers: `english-primary`, `spanish-secondary`
   - capability packs: `repo`, `git`, `shell`, `telemetry`, `browser`, `api`
8. Complete proof planes: structural, functional, behavioral, governance, maintainability, recovery.
9. A substantively real top-level lab domain feeding proof.
10. No live legacy persona or compatibility shim surfaces.
11. No shadow authority surfaces.
12. Two consecutive clean validation passes with no constitution-related diff on pass two.

## Non-Negotiable Cutover Rules

- The cutover must occur on one isolated cutover branch and land on `main` in one atomic merge.
- `main` must never enter a partially compliant intermediate state.
- Every target-state invariant must be enforced by cutover, not deferred.
- All canonical docs, contracts, registries, validators, decisions, generated views, disclosure artifacts, and lineage records must be synchronized in the same change.
- Certification fails if any audit finding remains open, any blocker remains unresolved, any blocking validator is red, any second-pass diff appears, or any in-scope exclusion remains in the final HarnessCard.

## Reading Order

1. `proposal.yml`
2. `architecture-proposal.yml`
3. `architecture/target-architecture.md`
4. `architecture/unified-execution-constitution-invariants.md`
5. `architecture/current-state-gap-map.md`
6. `resources/audit-findings-traceability-matrix.md`
7. `architecture/file-change-map.md`
8. `architecture/implementation-plan.md`
9. `architecture/migration-cutover-plan.md`
10. `architecture/validation-plan.md`
11. `architecture/acceptance-criteria.md`
12. `architecture/cutover-checklist.md`
13. `architecture/closure-certification-plan.md`
14. `architecture/execution-constitution-conformance-card.md`
15. `navigation/source-of-truth-map.md`
16. `resources/full-audit.md`
17. `resources/evidence-plan.md`
18. `resources/decision-record-plan.md`
19. `resources/risk-register.md`
20. `resources/assumptions-and-blockers.md`
