# Harmony As-Is Effective Weights (Inferred)
Date: `2026-02-18`
Method: evidence-based inference from enforced checks, workflows, policy docs, and continuity artifacts.
Scale:
- `5` hard-gated / mandatory blocking enforcement
- `4` strong norms + consistent checks
- `3` partial enforcement
- `2` occasional mention, weak enforcement
- `1` not evident/deprioritized

## Evidence Sources Used
- CI workflows: `.github/workflows/*.yml`
- Validator scripts: `.harmony/quality/_ops/scripts/*.sh`, `.harmony/capabilities/services/_ops/scripts/*.sh`
- Governance/runtime policy: `.harmony/cognition/_meta/architecture/governance-model.md`, `.harmony/cognition/_meta/architecture/runtime-policy.md`
- Principles and methodology contracts: `.harmony/cognition/principles/*.md`, `.harmony/cognition/methodology/*.md`
- Quality checklists: `.harmony/quality/complete.md`, `.harmony/quality/session-exit.md`
- Decision history: `.harmony/cognition/decisions/*.md`

## As-Is Weights
| Attribute | As-Is | Rationale | Evidence pointers |
|---|---:|---|---|
| performance | 3 | Strong in filesystem interfaces; not system-wide gate | `.github/workflows/filesystem-interfaces-perf-regression.yml`, `.harmony/cognition/methodology/performance-and-scalability.md` |
| scalability | 2 | Discussed, lightly enforced outside specific services | `.harmony/cognition/methodology/performance-and-scalability.md`, `.harmony/cognition/principles/README.md` |
| reliability | 5 | Multiple blocking validators/tests and determinism gates | `.github/workflows/main-push-safety.yml`, `.github/workflows/filesystem-interfaces-runtime.yml`, `.harmony/cognition/principles/determinism.md` |
| availability | 3 | SLO policy exists; limited global hard-gate enforcement | `.harmony/cognition/methodology/reliability-and-ops.md`, `.harmony/cognition/_meta/architecture/governance-model.md` |
| robustness | 4 | Fail-closed and validation-heavy contracts, including degraded-path checks | `.harmony/cognition/_meta/architecture/runtime-policy.md`, `.harmony/capabilities/services/_ops/scripts/validate-service-independence.sh` |
| recoverability | 4 | Rollback-first and reversibility are explicit policy; limited automatic drills globally | `.harmony/cognition/principles/reversibility.md`, `.harmony/cognition/_meta/architecture/runtime-policy.md` |
| dependability | 4 | Composite trust posture is explicit and reinforced by governance | `.harmony/cognition/pillars/trust.md`, `.harmony/cognition/principles/determinism-and-provenance.md` |
| safety | 5 | Deny-by-default, no-silent-apply, HITL and fail-closed rules are core | `.harmony/cognition/principles/deny-by-default.md`, `.harmony/cognition/principles/no-silent-apply.md`, `.harmony/cognition/_meta/architecture/governance-model.md` |
| security | 5 | Security scans and policy gates are declared blocking/non-waivable in methodology | `.harmony/cognition/methodology/ci-cd-quality-gates.md`, `.harmony/cognition/principles/security-and-privacy-baseline.md` |
| simplicity | 4 | Foundational principle and repeatedly enforced through process norms | `.harmony/cognition/principles/simplicity-over-complexity.md`, `.harmony/agency/practices/pull-request-standards.md` |
| evolvability | 4 | Boundaries/contracts/portability are strongly defended in principles and ADRs | `.harmony/cognition/principles/ownership-and-boundaries.md`, `.harmony/cognition/decisions/012-agent-platform-interop-native-first.md` |
| maintainability | 4 | Explicit quality attribute in multiple principles; strong but mostly policy-based | `.harmony/cognition/principles/README.md`, `.harmony/cognition/principles/documentation-is-code.md` |
| portability | 5 | Dedicated principle + self-containment and independence validators in CI | `.github/workflows/harness-self-containment.yml`, `.harmony/cognition/principles/portability-and-independence.md` |
| functional_suitability | 4 | Contract-first + strict structural and schema validators; broad but not universal runtime behavior checks | `.harmony/cognition/principles/contract-first.md`, `.harmony/quality/_ops/scripts/validate-harness-structure.sh` |
| completeness | 4 | PR template sections/checklists are enforced; completeness is explicit principle language | `.github/workflows/pr-quality.yml`, `.harmony/cognition/principles/observability-as-a-contract.md` |
| operability | 3 | Strong runbook/policy guidance; limited direct operational readiness gates | `.harmony/cognition/methodology/reliability-and-ops.md`, `.harmony/cognition/_meta/architecture/runtime-policy.md` |
| observability | 3 | Required by policy, but not yet uniformly enforced by repository-wide automation | `.harmony/cognition/principles/observability-as-a-contract.md`, `.harmony/cognition/methodology/ci-cd-quality-gates.md` |
| testability | 4 | Determinism and layered testing are strong and repeatedly validated in runtime workflows | `.harmony/quality/testing-strategy.md`, `.github/workflows/filesystem-interfaces-runtime.yml` |
| auditability | 4 | Provenance/audit trails are explicit and recurring; partial automation coverage | `.harmony/cognition/principles/determinism.md`, `.harmony/cognition/principles/determinism-and-provenance.md`, `.harmony/continuity/log.md` |
| deployability | 3 | Deployment safety and rollback policy are detailed; limited global deploy gate implementation | `.harmony/cognition/_meta/architecture/runtime-policy.md`, `.github/workflows/runtime-binaries.yml` |
| usability | 3 | Included in design doctrine and accessibility policy, not strongly gated | `.harmony/agency/agents/architect/AGENT.md`, `.harmony/cognition/principles/accessibility-baseline.md` |
| accessibility | 2 | Principle exists; little concrete enforcement visible in active workflows | `.harmony/cognition/principles/accessibility-baseline.md`, `.harmony/cognition/methodology/ci-cd-quality-gates.md` |
| interoperability | 4 | Interop contract and validation scripts are explicit and enforced for key interfaces | `.harmony/cognition/context/agent-platform-interop.md`, `.harmony/capabilities/services/_ops/scripts/validate-service-independence.sh` |
| compatibility | 3 | Cross-OS determinism is validated in filesystem runtime path only | `.github/workflows/filesystem-interfaces-runtime.yml` |
| configurability | 3 | Flags and profile concepts exist; guardrails around config-sprawl are still mostly normative | `.harmony/cognition/principles/flags-by-default.md`, `.github/workflows/flags-stale-report.yml` |
| sustainability | 1 | Cost/efficiency discussed, no clear enforceable energy/resource gates found | `.harmony/cognition/methodology/README.md` |

## Unknowns and Gaps
1. Branch protection required-check configuration is not visible in repo files; true merge-blocking status of all workflows is partially unknown.
2. Several methodology gates are normative in docs but not all are implemented in active workflows.
3. Incident urgency weighting is inferred from docs and workflow alerts; full issue/incident operational history is not fully represented in tracked artifacts.
4. Observability and availability enforcement is strong in policy and in filesystem workflows, but generalized harness-wide automated checks are incomplete.

## Delta vs Proposed Target (`ci-reliability`)
Top 5 mismatches (absolute delta) and backlog implications:

1. `observability`: as-is `3` -> target `5` (`+2`)
- Backlog: add repo-wide CI check for required trace/log evidence on changed flows.

2. `availability`: as-is `3` -> target `5` (`+2`)
- Backlog: define harness-level availability SLOs and burn-rate alerts for core validators/runtime entrypoints.

3. `operability`: as-is `3` -> target `5` (`+2`)
- Backlog: require runbook readiness checks for high-risk workflows and release paths.

4. `deployability`: as-is `3` -> target `5` (`+2`)
- Backlog: add consistent release/rollback rehearsal gate and evidence artifact.

5. `scalability`: as-is `2` -> target `4` (`+2`)
- Backlog: expand benchmark + concurrency regression checks beyond filesystem interfaces.
