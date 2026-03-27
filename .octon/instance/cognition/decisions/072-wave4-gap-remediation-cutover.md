# ADR 072: Wave 4 Gap Remediation Cutover

- Date: 2026-03-27
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-27-wave4-gap-remediation-cutover/plan.md`
  - `/.octon/state/evidence/migration/2026-03-27-wave4-gap-remediation-cutover/`
  - `/.octon/instance/cognition/decisions/071-assurance-lab-disclosure-expansion-cutover.md`

## Context

The first Wave 4 cutover activated the assurance and disclosure families, but
four concrete gaps remained:

- maintainability was still not a first-class proof plane
- evaluator handling existed only as a thin run-local placeholder
- benchmark disclosure lacked a reusable writer and benchmark-backed lab path
- run evidence backfill lacked a reusable path for already-bound canonical runs

## Decision

Promote a second pre-1.0 transitional Wave 4 remediation pass.

Rules:

1. Maintainability is a first-class proof plane and must appear in retained
   RunCards.
2. Evaluator routing remains explicit and support-tier-aware.
3. Benchmark and release-style disclosure must use retained lab benchmark and
   evaluator evidence, not prose-only claims.
4. Wave 4 backfill is legal only for runs that already have canonical control
   roots and bound run contracts.
5. Evidence-only historical directories remain historical unless a human
   reconstructs missing authority.

## Consequences

### Benefits

- Wave 4 now covers the missing architecture-health proof plane.
- Benchmark disclosure has a reusable HarnessCard writer and approved
  evaluator-review path.
- Canonical run roots can be upgraded to the fuller Wave 4 evidence model
  without hand-editing retained artifacts.

### Costs

- More retained evidence is written for benchmark and higher-scrutiny runs.
- Wave 4 validation and harness structure checks now cover additional authored
  surfaces.
- Legacy evidence-only run roots remain intentionally out-of-scope for blind
  automatic backfill.

### Follow-on Work

1. Add human-guided historical reconstruction if older evidence-only runs ever
   need full run-contract-era disclosure.
2. Expand benchmark catalogs and evaluator policies as support claims broaden.
