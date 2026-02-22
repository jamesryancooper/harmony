# Cognition Intent-to-Surface Atlas

Intent-first routing map across cognition runtime, governance, and practices.

## How To Use

1. Start with your task intent in the table below.
2. Open the primary entrypoint first.
3. Use companion paths for supporting contracts, operations, and evidence.

## Intent Routing Table

| Intent | Primary Entrypoint | Companion Paths |
|---|---|---|
| Find constraints or operational context before work | `/.harmony/cognition/runtime/context/index.yml` | `/.harmony/cognition/runtime/context/constraints.md`, `/.harmony/cognition/runtime/context/decisions.md` |
| Review or add architecture decisions | `/.harmony/cognition/runtime/decisions/index.yml` | `/.harmony/cognition/runtime/context/decisions.md`, `/.harmony/cognition/runtime/evidence/index.yml` |
| Plan or audit migration records | `/.harmony/cognition/runtime/migrations/index.yml` | `/.harmony/cognition/practices/methodology/migrations/README.md`, `/.harmony/cognition/runtime/evidence/index.yml` |
| Generate weekly scorecard digest | `/.harmony/cognition/runtime/evaluations/digests/index.yml` | `/.harmony/cognition/runtime/context/metrics-scorecard.md`, `/.harmony/cognition/practices/operations/weekly-evaluations.md` |
| Track remediation actions from evaluations | `/.harmony/cognition/runtime/evaluations/actions/index.yml` | `/.harmony/cognition/runtime/evaluations/actions/open-actions.yml`, `/.harmony/cognition/practices/operations/weekly-evaluations.md` |
| Trace knowledge graph links and provenance | `/.harmony/cognition/runtime/knowledge/index.yml` | `/.harmony/cognition/runtime/knowledge/graph/index.yml`, `/.harmony/cognition/runtime/knowledge/sources/index.yml`, `/.harmony/cognition/runtime/knowledge/queries/index.yml` |
| Consume or regenerate derived runtime projections | `/.harmony/cognition/runtime/projections/index.yml` | `/.harmony/cognition/runtime/projections/definitions/index.yml`, `/.harmony/cognition/runtime/projections/materialized/index.yml` |
| Interpret governance contracts and exceptions | `/.harmony/cognition/governance/index.yml` | `/.harmony/cognition/governance/principles/README.md`, `/.harmony/cognition/governance/controls/index.yml`, `/.harmony/cognition/governance/exceptions/README.md` |
| Apply methodology and execution standards | `/.harmony/cognition/practices/index.yml` | `/.harmony/cognition/practices/methodology/index.yml`, `/.harmony/cognition/practices/operations/index.yml` |
| Triage cognition policy lint and drift | `/.harmony/cognition/practices/operations/governance-lint-triage.md` | `/.harmony/cognition/_ops/principles/scripts/lint-principles-governance.sh`, `/.harmony/assurance/runtime/_ops/scripts/validate-harness-structure.sh` |

## Escalation Hints

- If your task touches more than one row, start from the highest-risk intent first.
- If ownership is still unclear, open `/.harmony/cognition/README.md` and then recurse via linked indexes.
