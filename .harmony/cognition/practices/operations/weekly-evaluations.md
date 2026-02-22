---
title: Weekly Evaluations Runbook
description: Procedure for producing and reviewing weekly cognition scorecard evaluations.
---

# Weekly Evaluations Runbook

## Purpose

Produce weekly scorecard evaluations under `/.harmony/cognition/runtime/evaluations/digests/` from deterministic evidence sources.

## Inputs

- `/.harmony/cognition/runtime/context/metrics-scorecard.md`
- CI artifacts and quality-gate outputs
- Observability traces and Knowledge Plane references

## Procedure

1. Create a weekly digest artifact under `/.harmony/cognition/runtime/evaluations/digests/`.
2. Record metric snapshots and status per scorecard category.
3. Record week-over-week deltas and supporting evidence links.
4. Select 1-2 remediation actions with explicit owners and due dates and update `/.harmony/cognition/runtime/evaluations/actions/open-actions.yml`.
5. Update `/.harmony/cognition/runtime/evaluations/digests/index.yml` with the new digest record entry.
6. Validate harness structure after index updates.

## Required Output

Each weekly digest MUST include:

- category status (green/yellow/red),
- metric values and deltas,
- remediation actions (owner + date),
- evidence links and representative trace IDs.
