---
name: "verify-implementation-conformance"
description: "Verify that implemented repository changes satisfy the proposal packet before closeout or implemented archival."
steps:
  - id: "verify-implementation-conformance"
    file: "stages/01-verify-implementation-conformance.md"
    description: "verify-implementation-conformance"
  - id: "report"
    file: "stages/02-report.md"
    description: "report"
---

# Verify Implementation Conformance

_Generated README from canonical workflow `verify-implementation-conformance`._

## Usage

```text
/verify-implementation-conformance
```

## Purpose

Verify that implemented repository changes satisfy the proposal packet before closeout or implemented archival.

## Target

This README summarizes the canonical workflow unit at `.octon/framework/orchestration/runtime/workflows/meta/verify-implementation-conformance`.

## Prerequisites

- Required workflow inputs are available.
- Canonical workflow contract exists at `.octon/framework/orchestration/runtime/workflows/meta/verify-implementation-conformance/workflow.yml`.

## Parameters

- `proposal_path` (folder, required=true): Root proposal directory to verify against implemented repo changes

## Failure Conditions

- Required inputs are missing or invalid.
- The canonical workflow contract or stage assets are missing.
- Verification criteria are not satisfied.

## Outputs

- `implementation_conformance_summary` -> `/.octon/state/evidence/validation/analysis/{{date}}-implementation-conformance.md`: Top-level implementation conformance verification summary
- `implementation_conformance_bundle` -> `/.octon/state/evidence/runs/workflows/{{date}}-implementation-conformance-{{slug}}/`: Workflow bundle containing implementation conformance metadata and outputs

## Steps

1. [verify-implementation-conformance](./stages/01-verify-implementation-conformance.md)
2. [report](./stages/02-report.md)

## Verification Gate

- [ ] `summary.md`, `commands.md`, `inventory.md`, `bundle.yml`, and `validation.md` exist
- [ ] `stage-inputs/` and `stage-logs/` exist for the workflow bundle
- [ ] validate-proposal-implementation-readiness.sh passes before implementation conformance is accepted
- [ ] validate-proposal-implementation-conformance.sh passes for the target proposal
- [ ] `support/implementation-conformance-review.md` records `verdict: pass` and `unresolved_items_count: 0` for implemented closeout
- [ ] promotion target coverage, implementation map coverage, validator coverage, generated output coverage, rollback coverage, and downstream reference coverage are explicit
- [ ] final conformance verdict is explicit

## References

- Canonical contract: `.octon/framework/orchestration/runtime/workflows/meta/verify-implementation-conformance/workflow.yml`
- Canonical stages: `.octon/framework/orchestration/runtime/workflows/meta/verify-implementation-conformance/stages/`

## Version History

| Version | Changes |
|---------|---------|
| 1.0.0 | Generated from canonical workflow `verify-implementation-conformance` |
