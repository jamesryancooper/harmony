---
title: Validate Proposal Before Promotion
description: Confirm that the proposal is structurally valid and eligible for promotion before mutating lifecycle state.
---

# Step 1: Validate Proposal Before Promotion

## Actions

1. Run `validate-proposal-standard.sh --package <proposal_path>`.
2. Run the subtype validator that matches `proposal.yml#proposal_kind`.
3. Run `validate-proposal-implementation-readiness.sh --package <proposal_path>`.
4. Fail closed if any validator fails.
5. Fail closed unless the proposal lives in the active path and currently uses `status: accepted`.
6. Fail closed unless `support/implementation-grade-completeness-review.md`
   records `verdict: pass`, `unresolved_questions_count: 0`, and
   `clarification_required: no`.
7. Confirm the promotion plan includes post-promotion receipts at
   `support/implementation-conformance-review.md` and
   `support/post-implementation-drift-churn-review.md`; do not claim
   implemented closeout until their validators pass after durable changes land.
8. Persist the validator transcript as `standard-validator.log`.
