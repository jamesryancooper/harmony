---
title: Evidence Map Maintenance Runbook
description: Procedure for maintaining runtime evidence map coverage and correctness.
---

# Evidence Map Maintenance Runbook

## Purpose

Keep runtime evidence discovery aligned with decision and migration records.

## Canonical Inputs

- `/.harmony/cognition/runtime/migrations/index.yml`
- `/.harmony/cognition/runtime/decisions/index.yml`
- `/.harmony/output/reports/migrations/README.md`
- `/.harmony/output/reports/decisions/README.md`

## Canonical Output

- `/.harmony/cognition/runtime/evidence/index.yml`

## Procedure

1. Add or update source records:
   - migration records in `/.harmony/cognition/runtime/migrations/index.yml`
   - optional decision evidence bundles in `/.harmony/output/reports/decisions/<NNN>-<slug>/`
2. Run:
   - `bash .harmony/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh`
3. Validate:
   - `bash .harmony/cognition/_ops/runtime/scripts/validate-generated-runtime-artifacts.sh`
   - `bash .harmony/assurance/runtime/_ops/scripts/validate-harness-structure.sh`

## Guardrails

- Do not manually edit `/.harmony/cognition/runtime/evidence/index.yml`.
- Do not point evidence bundles to non-canonical report locations.
- Do not bypass generated-artifact drift checks.
