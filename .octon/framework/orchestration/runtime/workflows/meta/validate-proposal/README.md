---
name: "validate-proposal"
description: "Run fail-closed validation for any manifest-governed proposal and verify that the committed proposal registry matches the manifest projection."
steps:
  - id: "validate-proposal"
    file: "stages/01-validate-proposal.md"
    description: "validate-proposal"
  - id: "report"
    file: "stages/02-report.md"
    description: "report"
---

# Validate Proposal

_Generated README from canonical workflow `validate-proposal`._

## Usage

```text
/validate-proposal
```

## Purpose

Run fail-closed validation for any manifest-governed proposal and verify that the committed proposal registry matches the manifest projection.

## Target

This README summarizes the canonical workflow unit at `.octon/framework/orchestration/runtime/workflows/meta/validate-proposal`.

## Parameters

- `proposal_path` (folder, required=true): Root proposal directory to validate

## Outputs

- `validate_proposal_workflow_summary` -> `/.octon/state/evidence/validation/analysis/{{date}}-validate-proposal.md`
- `validate_proposal_workflow_bundle` -> `/.octon/state/evidence/runs/workflows/{{date}}-validate-proposal-{{slug}}/`

## Steps

1. [validate-proposal](./stages/01-validate-proposal.md)
2. [report](./stages/02-report.md)

## Verification Gate

- [ ] `summary.md`, `commands.md`, `inventory.md`, `bundle.yml`, and `validation.md` exist
- [ ] `stage-inputs/` and `stage-logs/` exist for the workflow bundle
- [ ] base and subtype proposal validators pass
- [ ] generated proposal registry matches the manifest projection
- [ ] final validation verdict is explicit
