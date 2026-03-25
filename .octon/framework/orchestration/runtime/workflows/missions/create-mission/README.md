---
name: "create-mission"
description: "Scaffold a new mission, seed its full autonomy control family, and register it for execution tracking."
steps:
  - id: "overview"
    file: "stages/00-overview.md"
    description: "overview"
  - id: "validate-request"
    file: "stages/01-validate-request.md"
    description: "validate-request"
  - id: "scaffold-authority"
    file: "stages/02-scaffold-authority.md"
    description: "scaffold-authority"
  - id: "seed-and-register"
    file: "stages/03-seed-control-and-register.md"
    description: "seed-and-register"
  - id: "report"
    file: "stages/04-report.md"
    description: "report"
---

# Create Mission

_Generated README from canonical workflow `create-mission`._

## Usage

```text
/create-mission
```

## Purpose

Scaffold a new mission, seed its full autonomy control family, and register it for execution tracking.

## Target

This README summarizes the canonical workflow unit at `.octon/framework/orchestration/runtime/workflows/missions/create-mission`.

## Prerequisites

- Required workflow inputs are available.
- Canonical workflow contract exists at `.octon/framework/orchestration/runtime/workflows/missions/create-mission/workflow.yml`.

## Failure Conditions

- Required inputs are missing or invalid.
- The canonical workflow contract or stage assets are missing.
- Verification criteria are not satisfied.

## Steps

1. [overview](./stages/00-overview.md)
2. [validate-request](./stages/01-validate-request.md)
3. [scaffold-authority](./stages/02-scaffold-authority.md)
4. [seed-and-register](./stages/03-seed-control-and-register.md)
5. [report](./stages/04-report.md)

## Verification Gate

- [ ] verification stage passes

## References

- Canonical contract: `.octon/framework/orchestration/runtime/workflows/missions/create-mission/workflow.yml`
- Canonical stages: `.octon/framework/orchestration/runtime/workflows/missions/create-mission/stages/`

## Version History

| Version | Changes |
|---------|---------|
| 1.4.0 | Generated from canonical workflow `create-mission` |
