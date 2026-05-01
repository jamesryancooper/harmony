---
title: Promote Proposal
description: Rewrite the proposal to implemented state after proving that promotion targets are materialized and independent from proposal-local paths.
---

# Step 2: Promote Proposal

## Actions

1. Validate every `promotion_evidence` path is repo-relative and already exists.
2. Fail closed unless every promotion target exists.
3. Fail closed if any promotion target still references the proposal path or archive path.
4. Write or refresh `support/implementation-conformance-review.md` with a
   passing conformance verdict, checked evidence, promotion target coverage,
   implementation map coverage, validator coverage, generated output coverage,
   rollback coverage, downstream reference coverage, exclusions, and closeout
   recommendation.
5. Write or refresh `support/post-implementation-drift-churn-review.md` with a
   passing drift/churn verdict, backreference scan, naming drift review,
   generated projection freshness, manifest/schema validity, projection
   boundary review, target-family review, churn review, validators run,
   exclusions, and closeout recommendation.
6. Rewrite `proposal.yml` from `status: accepted` to `status: implemented`.
7. Regenerate `generated/proposals/registry.yml` from manifests instead of editing it manually.
8. Run `validate-proposal-implementation-conformance.sh --package <proposal_path>`.
9. Run `validate-proposal-post-implementation-drift.sh --package <proposal_path>`.
