---
name: octon-proposal-packet-lifecycle-closeout
description: Run the closeout-proposal-packet bundle.
license: MIT
compatibility: Octon proposal packet lifecycle extension.
metadata:
  author: Octon Framework
  created: "2026-04-30"
  updated: "2026-04-30"
skill_sets: [executor, specialist]
capabilities: [self-validating]
allowed-tools: Read Glob Grep Bash(git status) Bash(git diff) Bash(gh pr) Write(/.octon/inputs/exploratory/proposals/*) Write(/.octon/state/evidence/runs/skills/*)
---

# Proposal Packet Lifecycle Closeout

Execute gated closeout for one proposal packet. Refuse closeout when required
checks, review conversations, evidence, staging, archive, PR, merge,
branch-cleanup, hygiene, or sync gates fail. Red checks require remediation, not
status-only waiting.

Closeout must refuse final, accepted, implemented, archive-ready, or
implementation-ready claims unless `support/implementation-grade-completeness-review.md`
passes and the implementation-readiness validator succeeds. For implemented
closeout or implemented archival, also refuse unless
`support/implementation-conformance-review.md` and
`support/post-implementation-drift-churn-review.md` pass their validators with
no unresolved items, or the packet records an explicit blocked/deferred report
outcome or a rejected/superseded/historical archive disposition instead of a
successful closeout.
