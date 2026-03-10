---
name: "create-harness"
description: "Scaffold a new .harmony directory in a target location, then customize it to the target repository context."
steps:
  - id: "validate-prerequisites"
    file: "stages/01-validate-prerequisites.md"
    description: "validate-prerequisites"
  - id: "validate-target"
    file: "stages/02-validate-target.md"
    description: "validate-target"
  - id: "analyze-context"
    file: "stages/03-analyze-context.md"
    description: "analyze-context"
  - id: "gather-input"
    file: "stages/04-gather-input.md"
    description: "gather-input"
  - id: "copy-templates"
    file: "stages/05-copy-templates.md"
    description: "copy-templates"
  - id: "customize"
    file: "stages/06-customize.md"
    description: "customize"
  - id: "verify"
    file: "stages/07-verify.md"
    description: "verify"
---

# Create Harness

_Generated README from canonical workflow `create-harness`._

## Usage

```text
/create-harness
```

## Purpose

Scaffold a new .harmony directory in a target location, then customize it to the target repository context.

## Target

This README summarizes the canonical workflow unit at `.harmony/orchestration/runtime/workflows/meta/create-harness`.

## Prerequisites

- Required workflow inputs are available.
- Canonical workflow contract exists at `.harmony/orchestration/runtime/workflows/meta/create-harness/workflow.yml`.

## Failure Conditions

- Required inputs are missing or invalid.
- The canonical workflow contract or stage assets are missing.
- Verification criteria are not satisfied.

## Steps

1. [validate-prerequisites](./stages/01-validate-prerequisites.md)
2. [validate-target](./stages/02-validate-target.md)
3. [analyze-context](./stages/03-analyze-context.md)
4. [gather-input](./stages/04-gather-input.md)
5. [copy-templates](./stages/05-copy-templates.md)
6. [customize](./stages/06-customize.md)
7. [verify](./stages/07-verify.md)

## Verification Gate

- [ ] verification stage passes

## References

- Canonical contract: `.harmony/orchestration/runtime/workflows/meta/create-harness/workflow.yml`
- Canonical stages: `.harmony/orchestration/runtime/workflows/meta/create-harness/stages/`

## Version History

| Version | Changes |
|---------|---------|
| 1.2.0 | Generated from canonical workflow `create-harness` |

