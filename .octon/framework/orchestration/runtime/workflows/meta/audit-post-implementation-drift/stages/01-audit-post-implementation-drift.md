---
title: Audit Post-Implementation Drift
description: Prove implemented proposal changes did not introduce unintended drift or churn.
---

# Step 1: Audit Post-Implementation Drift

## Purpose

Attach drift/churn proof to the proposal packet after implementation
conformance passes.

## Actions

1. Run `validate-proposal-implementation-conformance.sh --package <proposal_path>`
   and fail closed unless the Implementation Conformance Gate passes first.
2. Run `validate-proposal-post-implementation-drift.sh --package <proposal_path>`.
3. Confirm `support/post-implementation-drift-churn-review.md` exists when the
   proposal is implemented or being archived as implemented.
4. Confirm the receipt records `verdict: pass`, `unresolved_items_count: 0`,
   checked evidence, active proposal-path backreference scan, naming drift
   review, generated projection freshness, manifest/schema validity,
   repo-local projection boundary review, target-family boundary review, churn
   review, validators run, exclusions, and final closeout recommendation.
5. Fail closed when promoted targets retain active proposal-path
   dependencies, stale Work Package/Change naming conflicts, stale generated
   registry entries, manifest/schema drift, `.github/**` boundary mixing,
   unplanned target-family mixing, or unexplained churn.
