# Closure Certification Plan

## 1. Purpose

This plan defines the only valid path for certifying that Octon has reached the full target-state Unified Execution Constitution. The proposal packet itself is **not** the durable completion record. The durable completion record is the authored governance decision set plus the release closure bundle.

## 2. Certification Must Fail Unless All Conditions Hold

Certification fails if any one of the following is false:

1. zero unresolved audit findings remain in `architecture/current-state-gap-map.md`
2. zero unresolved in-scope blockers remain in `resources/assumptions-and-blockers.md`
3. every remediation has full traceability to file changes, validators, evidence, and closure checkpoints
4. every blocking validator is green on pass 1
5. every blocking validator is green on pass 2
6. pass 2 produces no constitution-related diff
7. the final HarnessCard contains no in-scope exclusions
8. the full target support universe is admitted in policy and evidenced in proof
9. no shadow authority surface remains live
10. the durable closeout ADR exists
11. the closure certificate exists
12. release disclosure and lineage are published

## 3. Certification Inputs

- all canonical authored authority changes
- all canonical runtime/state/evidence changes
- full validation pass 1 evidence bundle
- full validation pass 2 evidence bundle
- final RunCards and HarnessCard
- support-target consistency report
- universal attainment proof
- intervention completeness report
- proof-plane coverage report
- lab substance report
- compatibility retirement report
- second-pass no-diff report

## 4. Required Closure Bundle Contents

The closure bundle under `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/` must contain at minimum:

- `closure-summary.yml`
- `closure-certificate.yml`
- `support-target-consistency-report.yml`
- `support-universe-coverage.yml`
- `admission-closure-report.yml`
- `authority-centralization-report.yml`
- `authority-artifact-completeness-report.yml`
- `fail-closed-routing-report.yml`
- `objective-stack-legality-report.yml`
- `mission-run-normalization-report.yml`
- `compatibility-retirement-report.yml`
- `mirror-parity-report.yml`
- `precedence-resolution-report.yml`
- `run-root-completeness-report.yml`
- `durable-lifecycle-report.yml`
- `evidence-retention-proof.yml`
- `external-replay-restore-report.yml`
- `intervention-completeness.yml`
- `measurement-trace-coverage.yml`
- `proof-plane-coverage-report.yml`
- `lab-substance-report.yml`
- `evaluator-independence-report.yml`
- `run-card-truth-report.yml`
- `universal-attainment-proof.yml`
- `second-pass-no-diff-report.yml`
- `claim-drift-report.yml`
- `projection-parity-report.yml`

## 5. Certifier Workflow

1. verify all inputs exist
2. verify all blocking validators are green on pass 1
3. verify all blocking validators are green on pass 2
4. inspect `second-pass-no-diff-report.yml`
5. inspect final HarnessCard and confirm:
   - admitted universe == target universe
   - no in-scope exclusions remain
   - claim scope is universal
6. verify durable ADR closeout exists
7. write `closure-certificate.yml`
8. write/update `ADR-UEC-010-full-attainment-certification.md`
9. allow protected merge and release

## 6. Durable Completion Record

The long-lived completion record is:

- `/.octon/instance/governance/decisions/ADR-UEC-010-full-attainment-certification.md`
- `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/closure-certificate.yml`
- `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/harness-card.yml`

The proposal packet remains non-authoritative after certification.

## 7. Reopening Rule

If any later audit proves:
- drift in source-of-truth classification
- reintroduction of shadow authority
- new in-scope exclusions
- failed proof-plane coverage
- failed second-pass idempotence
- hidden human repair

then certification is automatically reopened, the universal claim is suspended, and a new packet is required.
