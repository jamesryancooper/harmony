---
title: Validate Proposal Before Archive
description: Confirm that the source proposal is structurally valid before mutating archive state.
---

# Step 1: Validate Proposal Before Archive

## Actions

1. Run `validate-proposal-standard.sh --package <proposal_path>`.
2. Run the subtype validator that matches `proposal.yml#proposal_kind`.
3. Run `validate-proposal-implementation-readiness.sh --package <proposal_path>`.
4. When `disposition=implemented`, run
   `validate-proposal-implementation-conformance.sh --package <proposal_path>`
   and `validate-proposal-post-implementation-drift.sh --package <proposal_path>`.
5. Fail closed if any required validator fails.
6. Fail closed unless the proposal starts from the active path and is not already archived.
7. Fail closed for implemented archival unless the completeness, conformance,
   and drift/churn receipts pass or explicit blockers route the packet away
   from implemented archival.
8. Persist the validator transcript as `standard-validator.log`.
