---
title: Verify Implementation Conformance
description: Prove implemented repository changes satisfy the proposal packet before closeout.
---

# Step 1: Verify Implementation Conformance

## Purpose

Attach implementation proof to the proposal packet, independent of branch or PR
route.

## Actions

1. Run `validate-proposal-implementation-readiness.sh --package <proposal_path>`
   and fail closed unless the Implementation-Grade Completeness Gate passes for
   implemented closeout.
2. Run `validate-proposal-implementation-conformance.sh --package <proposal_path>`.
3. Confirm `support/implementation-conformance-review.md` exists when the
   proposal is implemented or being archived as implemented.
4. Confirm the receipt records `verdict: pass`, `unresolved_items_count: 0`,
   checked evidence, promotion target coverage, implementation map coverage,
   validator coverage, generated output coverage, rollback coverage,
   downstream reference coverage, exclusions, and final closeout
   recommendation.
5. Fail closed when any declared promotion target, implementation-map row,
   validator, generated output, rollback note, evidence item, or downstream
   reference is missing without an explicit blocker.
