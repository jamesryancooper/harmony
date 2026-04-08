# Cutover Checklist

Each line item is binary. A checked item must be supported by the named evidence artifact or it is not complete.

## Pre-freeze

- [ ] Cutover branch/worktree exists and is the only branch used for the migration. — evidence: `branch-freeze-record.yml`
- [ ] Mainline merge freeze is active. — evidence: `branch-freeze-record.yml`
- [ ] Cutover release directory exists. — evidence: `release-stub.yml`
## Authority normalization

- [ ] `V-SOT-001` PASS artifact exists. — evidence: `authority-classification-report.yml`
- [ ] `V-SOT-002` PASS artifact exists. — evidence: `mirror-parity-report.yml`
- [ ] `V-PREC-001` PASS artifact exists. — evidence: `precedence-resolution-report.yml`
## Objective normalization

- [ ] `V-OBJ-001` PASS artifact exists. — evidence: `objective-stack-legality-report.yml`
- [ ] `V-OBJ-002` PASS artifact exists. — evidence: `mission-run-normalization-report.yml`
- [ ] Legacy objective shims are deleted or archived and no live references remain. — evidence: `compatibility-retirement-report.yml`
## Authority centralization

- [ ] `V-AUTH-001` PASS artifact exists. — evidence: `authority-centralization-report.yml`
- [ ] `V-AUTH-002` PASS artifact exists. — evidence: `authority-artifact-completeness-report.yml`
- [ ] `V-AUTH-003` PASS artifact exists. — evidence: `fail-closed-routing-report.yml`
## Support universe

- [ ] `V-SUP-001` PASS artifact exists. — evidence: `support-target-consistency-report.yml`
- [ ] Capability pack manifests exist for repo/git/shell/telemetry/browser/api. — evidence: `capability-pack-governance-report.yml`
- [ ] `V-CAP-001` PASS artifact exists. — evidence: `capability-pack-governance-report.yml`
## Runtime lifecycle

- [ ] `V-RUN-001` PASS artifact exists. — evidence: `run-root-completeness-report.yml`
- [ ] `V-RUN-002` PASS artifact exists. — evidence: `durable-lifecycle-report.yml`
## Evidence

- [ ] `V-EVD-001` PASS artifact exists. — evidence: `evidence-retention-proof.yml`
- [ ] `V-EVD-002` PASS artifact exists. — evidence: `external-replay-restore-report.yml`
## Observability

- [ ] `V-OBS-001` PASS artifact exists. — evidence: `intervention-completeness.yml`
- [ ] `V-OBS-002` PASS artifact exists. — evidence: `measurement-trace-coverage.yml`
## Proof planes

- [ ] `V-ASS-001` PASS artifact exists. — evidence: `proof-plane-coverage-report.yml`
## Lab

- [ ] `V-LAB-001` PASS artifact exists. — evidence: `lab-substance-report.yml`
- [ ] `V-LAB-002` PASS artifact exists. — evidence: `evaluator-independence-report.yml`
## Disclosure

- [ ] `V-DISC-001` PASS artifact exists. — evidence: `run-card-truth-report.yml`
- [ ] `V-DISC-002` PASS artifact exists. — evidence: `universal-attainment-proof.yml`
## Simplification

- [ ] `V-LEG-001` PASS artifact exists. — evidence: `compatibility-retirement-report.yml`
## Regeneration pass 1

- [ ] All generated/effective and disclosure artifacts regenerated from canonical sources only. — evidence: `closure-summary.yml`
- [ ] Pass-1 evidence bundle is complete. — evidence: `closure-summary.yml`
## Regeneration pass 2

- [ ] Fresh clean worktree created for second pass. — evidence: `second-pass-no-diff-report.yml`
- [ ] All generators rerun on the fresh state. — evidence: `second-pass-no-diff-report.yml`
- [ ] All validators rerun on the fresh state. — evidence: `second-pass-no-diff-report.yml`
- [ ] No constitution-related diff detected. — evidence: `second-pass-no-diff-report.yml`
## Certification

- [ ] Closure summary exists. — evidence: `closure-summary.yml`
- [ ] Closure certificate exists. — evidence: `closure-certificate.yml`
- [ ] Final HarnessCard exists and contains no in-scope exclusions. — evidence: `harness-card.yml`
- [ ] Durable closeout ADR exists. — evidence: `ADR-UEC-010-full-attainment-certification.md`
## Merge

- [ ] Exactly one protected atomic merge lands on `main`. — evidence: `git release record`
- [ ] Release tag and release lineage entry exist. — evidence: `release-lineage.yml`
- [ ] Mainline freeze is removed only after publication of disclosure and closure evidence. — evidence: `branch-freeze-record.yml`
