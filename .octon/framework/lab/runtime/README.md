# Lab Runtime

Lab runtime surfaces define the contracts used to record replay manifests,
scenario proof, and other retained behavioral evidence.

Canonical retained outputs live under `/.octon/state/evidence/lab/**` and
run-local replay roots under `/.octon/state/evidence/runs/<run-id>/replay/**`.

Reusable disclosure tooling lives under `runtime/_ops/scripts/`.
