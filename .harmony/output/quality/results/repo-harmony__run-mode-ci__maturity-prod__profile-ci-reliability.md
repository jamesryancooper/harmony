# Weighted Quality Results

- Profile: `ci-reliability`
- Repo: `harmony`
- Run mode: `ci`
- Maturity: `prod`
- System score: `77.28%`

## Charter Metadata

- Charter: `.harmony/quality/CHARTER.md`
- Version: `1.0.0`
- Priority chain: `Trust (trust) > Speed of development (speed_of_development) > Ease of use (ease_of_use) > Portability (portability) > Interoperability (interoperability)`
- Tie-break rule: When weighted priority ties, prioritize items mapped to higher charter outcomes in chain order.

## Trade-off Rules

- Trust is non-negotiable.
- Speed is optimized inside trust constraints.
- Ease of use is protected by progressive disclosure.
- Portability is preserved by contracts and isolation.
- Interoperability is allowed only with versioning + security + tests.

## Conflict Resolution

Equal-priority conflicts were resolved by charter chain order.

| Priority | Winner | Loser | Winner Outcome | Loser Outcome |
|---:|---|---|---|---|
| 10 | `quality:observability` | `continuity:deployability` | `trust` | `speed_of_development` |
| 10 | `runtime:deployability` | `continuity:operability` | `speed_of_development` | `ease_of_use` |
| 6 | `quality:performance` | `continuity:accessibility` | `speed_of_development` | `ease_of_use` |

## Subsystem Totals

| Subsystem | Weighted Score |
|---|---:|
| `continuity` | `76.35%` |
| `quality` | `76.35%` |
| `runtime` | `79.13%` |

## Top Drivers

Prioritization formula: `effective_weight × max(0, target_score - current_score)`

| Subsystem | Attribute | Outcome | Rank | Weight | Current | Target | Gap | Priority | Evidence | Suggested Action |
|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| `continuity` | `availability` | `trust` | 1 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/methodology/risk-tiers.md | Raise 'availability' from 3 to target 5. |
| `quality` | `availability` | `trust` | 1 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/methodology/risk-tiers.md | Raise 'availability' from 3 to target 5. |
| `quality` | `observability` | `trust` | 1 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/principles/observability-as-a-contract.md, .harmony/cognition/_meta/architecture/observability-requirements.md | Raise 'observability' from 3 to target 5. |
| `continuity` | `deployability` | `speed_of_development` | 2 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/_meta/architecture/runtime-policy.md, .github/workflows/runtime-binaries.yml | Raise 'deployability' from 3 to target 5. |
| `quality` | `deployability` | `speed_of_development` | 2 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/_meta/architecture/runtime-policy.md, .github/workflows/runtime-binaries.yml | Raise 'deployability' from 3 to target 5. |
| `runtime` | `deployability` | `speed_of_development` | 2 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/_meta/architecture/runtime-policy.md, .github/workflows/runtime-binaries.yml | Raise 'deployability' from 3 to target 5. |
| `continuity` | `operability` | `ease_of_use` | 3 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/_meta/architecture/runtime-policy.md | Raise 'operability' from 3 to target 5. |
| `quality` | `operability` | `ease_of_use` | 3 | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/_meta/architecture/runtime-policy.md | Raise 'operability' from 3 to target 5. |
| `continuity` | `scalability` | `speed_of_development` | 2 | 4 | 2 | 4 | 2 | 8 | .harmony/cognition/methodology/performance-and-scalability.md, .harmony/cognition/principles/contract-first.md | Raise 'scalability' from 2 to target 4. |
| `continuity` | `autonomy` | `speed_of_development` | 2 | 4 | 3 | 5 | 2 | 8 | .harmony/cognition/principles/no-silent-apply.md, .harmony/cognition/principles/hitl-checkpoints.md, .harmony/cognition/principles/deny-by-default.md | Raise 'autonomy' from 3 to target 5. |
| `quality` | `scalability` | `speed_of_development` | 2 | 4 | 2 | 4 | 2 | 8 | .harmony/cognition/methodology/performance-and-scalability.md, .harmony/cognition/principles/contract-first.md | Raise 'scalability' from 2 to target 4. |
| `quality` | `autonomy` | `speed_of_development` | 2 | 4 | 3 | 5 | 2 | 8 | .harmony/cognition/principles/no-silent-apply.md, .harmony/cognition/principles/hitl-checkpoints.md, .harmony/cognition/principles/deny-by-default.md | Raise 'autonomy' from 3 to target 5. |
| `continuity` | `performance` | `speed_of_development` | 2 | 3 | 3 | 5 | 2 | 6 | .harmony/cognition/methodology/performance-and-scalability.md, .github/workflows/filesystem-interfaces-perf-regression.yml | Raise 'performance' from 3 to target 5. |
| `quality` | `performance` | `speed_of_development` | 2 | 3 | 3 | 5 | 2 | 6 | .harmony/cognition/methodology/performance-and-scalability.md, .github/workflows/filesystem-interfaces-perf-regression.yml | Raise 'performance' from 3 to target 5. |
| `continuity` | `accessibility` | `ease_of_use` | 3 | 3 | 2 | 4 | 2 | 6 | .harmony/cognition/principles/accessibility-baseline.md, .harmony/cognition/methodology/ci-cd-quality-gates.md | Raise 'accessibility' from 2 to target 4. |
| `quality` | `accessibility` | `ease_of_use` | 3 | 3 | 2 | 4 | 2 | 6 | .harmony/cognition/principles/accessibility-baseline.md, .harmony/cognition/methodology/ci-cd-quality-gates.md | Raise 'accessibility' from 2 to target 4. |
| `runtime` | `accessibility` | `ease_of_use` | 3 | 3 | 2 | 4 | 2 | 6 | .harmony/cognition/principles/accessibility-baseline.md, .harmony/cognition/methodology/ci-cd-quality-gates.md | Raise 'accessibility' from 2 to target 4. |
| `continuity` | `functional_suitability` | `trust` | 1 | 5 | 4 | 5 | 1 | 5 | .harmony/cognition/principles/contract-first.md, .harmony/quality/_ops/scripts/validate-harness-structure.sh | Raise 'functional_suitability' from 4 to target 5. |
| `continuity` | `observability` | `trust` | 1 | 5 | 4 | 5 | 1 | 5 | .harmony/cognition/principles/observability-as-a-contract.md, .harmony/cognition/_meta/architecture/observability-requirements.md | Raise 'observability' from 4 to target 5. |
| `quality` | `recoverability` | `trust` | 1 | 5 | 4 | 5 | 1 | 5 | .harmony/cognition/principles/reversibility.md, .harmony/cognition/_meta/architecture/runtime-policy.md | Raise 'recoverability' from 4 to target 5. |

## Regressions

- Hard: `0`
- Soft: `0`
