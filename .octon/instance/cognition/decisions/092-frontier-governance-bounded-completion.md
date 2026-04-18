# ADR 092: Frontier Governance Bounded Completion

- Date: 2026-04-18
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/instance/cognition/context/shared/migrations/2026-04-18-octon-frontier-governance-target-state/plan.md`
  - `/.octon/state/evidence/disclosure/releases/2026-04-18-frontier-governance-bounded-complete/`

## Context

Frontier-governance revalidation corrected the repo’s live-claim overstatement by
restaging browser/API, frontier-governed, boundary-sensitive, and other
unsupported surfaces to explicit non-live posture. The remaining active live
claim is a bounded admitted finite tuple set with retained evidence and
disclosure.

## Decision

Treat the bounded admitted finite live subset as the truthful completion target
for the current active release.

Rules:

1. A complete claim is valid only for the supported tuple subset.
2. Excluded surfaces may remain explicit in the support and closure ledgers
   without blocking completion when they are clearly non-live.
3. Future widening remains a separate follow-on program and must not inherit
   the complete claim implicitly.

## Consequences

- The active release can move from `recertification_open` to `complete`
  without widening unsupported support.
- Browser/API and frontier-boundary work remain durable follow-on scope, not
  active live support.
