# Execution Control Evidence

`state/evidence/control/execution/**` is the canonical retained evidence family
for per-run authority decisions, grant bundles, approval materialization, and
control-plane mutations.

## Canonical Artifacts

- `authority-decision-<request-id>.yml`
- `authority-grant-bundle-<request-id>.yml`
- control-plane mutation receipts such as schedule, budget, breaker, lease, and
  directive transitions

## Boundary

- This family retains durable evidence for the live authority path.
- It does not replace the mutable control roots under
  `state/control/execution/**`.
- Historical lineage under `state/evidence/decisions/**` may remain for
  backfilled or capability-local records, but it no longer substitutes for the
  canonical authority path.
