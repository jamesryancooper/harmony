# Wave 4 Remediation Inventory

Completion status: Wave 4 complete.

## Proof Plane And Contract Expansion

- Added `/.octon/framework/assurance/maintainability/**`
- Added evaluator routing and reusable evaluator-review tooling under
  `/.octon/framework/assurance/evaluators/**`
- Added lab catalog and reusable HarnessCard tooling under `/.octon/framework/lab/**`
- Updated the assurance and disclosure contracts plus RunCard schema so
  maintainability becomes a required first-class proof plane

## Run Evidence And Backfill

- Added `write-run.sh backfill-wave4` for canonical run roots that already
  have bound run contracts
- Backfilled `run-wave3-runtime-bridge-20260327` with maintainability proof
  and updated RunCard/retained-evidence references
- Seeded a second normalized consequential benchmark run:
  `run-wave4-benchmark-evaluator-20260327`

## Benchmark And Evaluator Evidence

- Added retained benchmark measurements under
  `/.octon/state/evidence/lab/benchmarks/**`
- Added retained evaluator reviews under
  `/.octon/state/evidence/lab/evaluator-reviews/**`
- Added benchmark scenario proof plus a benchmark HarnessCard under
  `/.octon/state/evidence/lab/{scenarios,harness-cards}/**`

## Validators, Generated Outputs, And Continuity

- Extended the Wave 4 validator and harness structure validator for
  maintainability, evaluator-routing, benchmark, and writer surfaces
- Refreshed generated mission summaries/views and publication receipts during
  the passing harness alignment run
