---
name: "audit-post-implementation-drift"
description: "Audit an implemented proposal for proposal-path backreferences, naming drift, projection drift, target-family mixing, and excess churn."
steps:
  - id: "audit-post-implementation-drift"
    file: "stages/01-audit-post-implementation-drift.md"
    description: "audit-post-implementation-drift"
  - id: "report"
    file: "stages/02-report.md"
    description: "report"
---

# Audit Post Implementation Drift

_Generated README from canonical workflow `audit-post-implementation-drift`._

## Usage

```text
/audit-post-implementation-drift
```

## Purpose

Audit an implemented proposal for proposal-path backreferences, naming drift, projection drift, target-family mixing, and excess churn.

## Target

This README summarizes the canonical workflow unit at `.octon/framework/orchestration/runtime/workflows/meta/audit-post-implementation-drift`.

## Prerequisites

- Required workflow inputs are available.
- Canonical workflow contract exists at `.octon/framework/orchestration/runtime/workflows/meta/audit-post-implementation-drift/workflow.yml`.

## Parameters

- `proposal_path` (folder, required=true): Root proposal directory to audit after implementation conformance

## Failure Conditions

- Required inputs are missing or invalid.
- The canonical workflow contract or stage assets are missing.
- Verification criteria are not satisfied.

## Outputs

- `post_implementation_drift_summary` -> `/.octon/state/evidence/validation/analysis/{{date}}-post-implementation-drift.md`: Top-level post-implementation drift/churn audit summary
- `post_implementation_drift_bundle` -> `/.octon/state/evidence/runs/workflows/{{date}}-post-implementation-drift-{{slug}}/`: Workflow bundle containing post-implementation drift/churn metadata and outputs

## Steps

1. [audit-post-implementation-drift](./stages/01-audit-post-implementation-drift.md)
2. [report](./stages/02-report.md)

## Verification Gate

- [ ] `summary.md`, `commands.md`, `inventory.md`, `bundle.yml`, and `validation.md` exist
- [ ] `stage-inputs/` and `stage-logs/` exist for the workflow bundle
- [ ] validate-proposal-implementation-conformance.sh passes before drift/churn is accepted
- [ ] validate-proposal-post-implementation-drift.sh passes for the target proposal
- [ ] `support/post-implementation-drift-churn-review.md` records `verdict: pass` and `unresolved_items_count: 0` for implemented closeout
- [ ] active proposal backreferences, stale naming conflicts, generated projection freshness, manifest/schema validity, repo-local projection boundaries, target-family boundaries, and churn are explicitly reviewed
- [ ] final drift/churn verdict is explicit

## References

- Canonical contract: `.octon/framework/orchestration/runtime/workflows/meta/audit-post-implementation-drift/workflow.yml`
- Canonical stages: `.octon/framework/orchestration/runtime/workflows/meta/audit-post-implementation-drift/stages/`

## Version History

| Version | Changes |
|---------|---------|
| 1.0.0 | Generated from canonical workflow `audit-post-implementation-drift` |
