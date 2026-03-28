---
title: "Team: delivery-core"
description: "Default delivery composition with one accountable orchestrator and optional independent verification."
---

# Team: delivery-core

## Purpose

Use this team for non-trivial changes that benefit from one accountable orchestrator plus bounded specialist or verifier handoffs.

## Composition

- **Lead Agent:** orchestrator
- **Agents:** orchestrator, verifier
- **Assistants:** reviewer, refactor, docs

## Handoff Policy

1. `orchestrator` owns scope, risk posture, sequencing, and final integration.
2. `orchestrator` delegates only bounded subtasks that benefit from context isolation or parallelism.
3. `verifier` participates only when separation of duties or materially independent review adds value.

## Workflow Alignment

- **Default workflow:** none
- **Optional workflows:** `audit-pre-release`, `audit-documentation`,
  `audit-orchestration`
- **Routing guidance:**
  - Use `audit-pre-release` before risky promotions.
  - Use `audit-documentation` when docs-as-code artifacts are in scope.
  - Use `audit-orchestration` for partitioned migration audits.

## Composite Skill Alignment

- **Preferred composite skills:** none currently registered
- **Policy stance:** If a composite skill is introduced, it must be
  fail-closed, self-validating, and declared in skills registry with explicit
  `depends_on`.

## Escalation Rules

Escalate to human when:

- requirements are ambiguous and choice is irreversible,
- security/compliance tradeoffs are unresolved,
- verification surfaces a high-severity unresolved risk.

## Output Contract

```markdown
## Team Execution Summary

**Team:** delivery-core
**Lead:** orchestrator
**Delegations:** [assistant tasks and outputs]
**Verification:** [verifier findings and status]
**Outcome:** [complete / blocked / escalated]
```
