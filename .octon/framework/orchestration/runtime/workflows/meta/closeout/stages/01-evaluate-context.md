# Evaluate Context

1. Load the canonical default work unit policy and Git/worktree route contract.
2. Resolve or create the Change identity before selecting branch or PR actions.
3. Select the route and then select lifecycle outcome separately. Determine
   whether the current state is:
   - direct-main eligible Change
   - branch-only Change with no PR requirement and outcome `preserved`,
     `branch-local-complete`, `published-branch`, `landed`, or `cleaned`
   - PR-backed Change with outcome `preserved`, `published`, `ready`, `landed`,
     or `cleaned`
   - already-ready PR-backed Change with only queued or running required checks
   - stage-only or escalated Change with missing decision, validation,
     rollback, authorization, review, or ownership evidence
   - blocked implementation that should continue without closeout mutation
4. Treat red required checks, failing jobs, failing scripts, unresolved review
   conversations, unresolved author action items, missing rollback handles,
   missing Change receipts, and failed final hygiene as blockers, not as
   waiting states.
5. Record the selected Change route, lifecycle outcome, and every blocking
   condition.
