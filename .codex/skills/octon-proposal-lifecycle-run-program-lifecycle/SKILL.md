---
name: octon-proposal-lifecycle-run-program-lifecycle
description: Run the generic lifecycle runner against one proposal program target.
license: MIT
compatibility: Octon proposal lifecycle extension.
metadata:
  author: Octon Framework
  created: "2026-05-12"
  updated: "2026-05-12"
skill_sets: [executor, integrator, specialist]
capabilities: [self-validating]
allowed-tools: Read Glob Grep Bash(octon lifecycle *) Write(/.octon/state/*)
---

# Octon Proposal Lifecycle: Run Program Lifecycle

Use the shared lifecycle runner for one proposal program target:

```sh
octon lifecycle run --lifecycle proposal-program --target <program-packet-path>
```

The runner resolves `proposal-program` from the published effective extension
catalog, reconstructs parent program state from `proposal.yml`,
`resources/child-packet-index.yml`, and parent-local support receipts, evaluates
parent review and child-readiness gates, selects the next route, and writes run
evidence plus a resumable checkpoint.

This wrapper has no prompt bundle and is not a dispatcher route. It must
preserve child-owned manifests, receipts, validation verdicts, promotion
targets, and archive metadata. Parent receipts may summarize child outcomes but
never satisfy child receipts or child authority.
