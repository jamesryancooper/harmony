# Weighted Quality Results

- Profile: `ci-reliability`
- Repo: `my-repo`
- Run mode: `ci`
- Maturity: `prod`
- System score: `77.28%`

## Subsystem Totals

| Subsystem | Weighted Score |
|---|---:|
| `continuity` | `76.35%` |
| `quality` | `76.35%` |
| `runtime` | `79.13%` |

## Top Drivers

Prioritization formula: `effective_weight × max(0, target_score - current_score)`

| Subsystem | Attribute | Weight | Current | Target | Gap | Priority | Evidence | Suggested Action |
|---|---|---:|---:|---:|---:|---:|---|---|
| `continuity` | `availability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/methodology/risk-tiers.md | Raise 'availability' from 3 to target 5. |
| `continuity` | `operability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/_meta/architecture/runtime-policy.md | Raise 'operability' from 3 to target 5. |
| `continuity` | `deployability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/_meta/architecture/runtime-policy.md, .github/workflows/runtime-binaries.yml | Raise 'deployability' from 3 to target 5. |
| `quality` | `availability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/methodology/risk-tiers.md | Raise 'availability' from 3 to target 5. |
| `quality` | `operability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/methodology/reliability-and-ops.md, .harmony/cognition/_meta/architecture/runtime-policy.md | Raise 'operability' from 3 to target 5. |
| `quality` | `observability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/principles/observability-as-a-contract.md, .harmony/cognition/_meta/architecture/observability-requirements.md | Raise 'observability' from 3 to target 5. |
| `quality` | `deployability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/_meta/architecture/runtime-policy.md, .github/workflows/runtime-binaries.yml | Raise 'deployability' from 3 to target 5. |
| `runtime` | `deployability` | 5 | 3 | 5 | 2 | 10 | .harmony/cognition/_meta/architecture/runtime-policy.md, .github/workflows/runtime-binaries.yml | Raise 'deployability' from 3 to target 5. |
| `continuity` | `scalability` | 4 | 2 | 4 | 2 | 8 | .harmony/cognition/methodology/performance-and-scalability.md, .harmony/cognition/principles/contract-first.md | Raise 'scalability' from 2 to target 4. |
| `continuity` | `autonomy` | 4 | 3 | 5 | 2 | 8 | .harmony/cognition/principles/no-silent-apply.md, .harmony/cognition/principles/hitl-checkpoints.md, .harmony/cognition/principles/deny-by-default.md | Raise 'autonomy' from 3 to target 5. |
| `quality` | `scalability` | 4 | 2 | 4 | 2 | 8 | .harmony/cognition/methodology/performance-and-scalability.md, .harmony/cognition/principles/contract-first.md | Raise 'scalability' from 2 to target 4. |
| `quality` | `autonomy` | 4 | 3 | 5 | 2 | 8 | .harmony/cognition/principles/no-silent-apply.md, .harmony/cognition/principles/hitl-checkpoints.md, .harmony/cognition/principles/deny-by-default.md | Raise 'autonomy' from 3 to target 5. |
| `continuity` | `performance` | 3 | 3 | 5 | 2 | 6 | .harmony/cognition/methodology/performance-and-scalability.md, .github/workflows/filesystem-interfaces-perf-regression.yml | Raise 'performance' from 3 to target 5. |
| `continuity` | `accessibility` | 3 | 2 | 4 | 2 | 6 | .harmony/cognition/principles/accessibility-baseline.md, .harmony/cognition/methodology/ci-cd-quality-gates.md | Raise 'accessibility' from 2 to target 4. |
| `quality` | `performance` | 3 | 3 | 5 | 2 | 6 | .harmony/cognition/methodology/performance-and-scalability.md, .github/workflows/filesystem-interfaces-perf-regression.yml | Raise 'performance' from 3 to target 5. |
| `quality` | `accessibility` | 3 | 2 | 4 | 2 | 6 | .harmony/cognition/principles/accessibility-baseline.md, .harmony/cognition/methodology/ci-cd-quality-gates.md | Raise 'accessibility' from 2 to target 4. |
| `runtime` | `accessibility` | 3 | 2 | 4 | 2 | 6 | .harmony/cognition/principles/accessibility-baseline.md, .harmony/cognition/methodology/ci-cd-quality-gates.md | Raise 'accessibility' from 2 to target 4. |
| `continuity` | `simplicity` | 5 | 4 | 5 | 1 | 5 | .harmony/cognition/principles/simplicity-over-complexity.md, .harmony/agency/practices/pull-request-standards.md | Raise 'simplicity' from 4 to target 5. |
| `continuity` | `maintainability` | 5 | 4 | 5 | 1 | 5 | .harmony/cognition/principles/documentation-is-code.md, .harmony/cognition/principles/ownership-and-boundaries.md | Raise 'maintainability' from 4 to target 5. |
| `continuity` | `functional_suitability` | 5 | 4 | 5 | 1 | 5 | .harmony/cognition/principles/contract-first.md, .harmony/quality/_ops/scripts/validate-harness-structure.sh | Raise 'functional_suitability' from 4 to target 5. |

## Regressions

- Hard: `0`
- Soft: `0`
