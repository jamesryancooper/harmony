# ADR 089: Frontier Governance Target-State Revalidation

- Date: 2026-04-18
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/instance/cognition/context/shared/migrations/2026-04-18-octon-frontier-governance-target-state/plan.md`
  - `/.octon/state/evidence/migration/2026-04-18-octon-frontier-governance-target-state/`
  - `/.octon/inputs/exploratory/proposals/architecture/octon-frontier-governance-target-state/`

## Context

The frontier-governance packet revalidation found that live repo authority and
disclosure still overstate the admitted support universe. Browser/API packs and
frontier-boundary tuples are claimed as live even though the active runtime
service manifest does not admit the required runtime services.

## Decision

Treat the packet as an implementation-driving corrective migration, not a
closure-ready attainment packet.

Rules:

1. Active live claims must be narrowed to the currently supportable admitted
   tuple set.
2. Browser/API and frontier-boundary-sensitive support remain stage-only or
   unadmitted until runtime-service, replay/evidence, tuple-admission, and
   support-dossier requirements are real.
3. The repository must replace false `complete` disclosure with an explicit
   recertification-open posture whenever later packet phases remain blocked.

## Consequences

- Octon remains support-honest and fail-closed.
- The migration can land truthful Phase 0 corrections immediately.
- Full target-state attainment remains blocked pending later runtime and proof
  work.
