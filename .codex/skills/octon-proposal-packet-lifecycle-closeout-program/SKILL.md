---
name: octon-proposal-packet-lifecycle-closeout-program
description: Run the closeout-proposal-program bundle.
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

# Proposal Packet Lifecycle Closeout Program

Program closeout must refuse final or implementation-ready claims unless every
required packet-level completeness receipt passes or the program records an
explicit blocked/deferred report outcome or rejected/superseded/historical
archive disposition.

For implemented child packets, program closeout must also require passing
implementation conformance and post-implementation drift/churn receipts. A
program may aggregate child receipts, but it may not replace the packet-level
post-implementation evidence.

Execute gated program closeout after required child lifecycle states are
implemented, archived, rejected, superseded, or covered by an explicitly
deferred report outcome.
