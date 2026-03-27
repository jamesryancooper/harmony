# Evaluator Proof Plane

The evaluator plane records independent review when deterministic proof is
insufficient or when separation of duties materially improves trust.

Canonical retained outputs live under:

- `/.octon/state/evidence/runs/<run-id>/assurance/evaluator.yml`
- `/.octon/state/evidence/lab/**`

Routing guidance lives at:

- `review-routing.yml`

Reusable authoring inputs live at:

- `templates/review-template.md`
- `runtime/_ops/scripts/write-evaluator-review.sh`

Evaluator outputs remain evidence. They do not mint authority.
