# Architecture Health Contract v2

This contract defines Octon's depth-aware aggregate architecture health gate.

## Depth classes

- `existence`
- `schema`
- `semantic`
- `runtime`
- `proof`
- `closure-grade`

## Required closure-grade dimensions

- structural contract
- runtime-effective handles
- freshness modes
- authorization coverage
- capability-pack cutover
- extension lifecycle
- support proof
- operator read models
- compatibility retirement
- publication receipts
- architecture health v2

## Rules

1. A dimension passes only at the depth actually proven by its validator or
   retained evidence.
2. A required closure-grade dimension fails when it only proves existence or
   schema.
3. Closure-grade status requires semantic, runtime, and proof depth wherever
   the dimension demands them.
4. The aggregate gate may orchestrate narrower validators, but it may not mint
   a second authority surface.
5. The final certificate lives under
   `/.octon/state/evidence/validation/architecture/10of10-target-transition/closure/**`.

## Canonical validator

- `/.octon/framework/assurance/runtime/_ops/scripts/validate-architecture-health.sh`
