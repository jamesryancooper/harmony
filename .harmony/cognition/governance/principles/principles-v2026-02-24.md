---
title: Engineering Principles & Standards (Successor v2026-02-24)
description: Active successor charter that preserves immutable-principles policy while defining current framing.
status: Active
mutability: versioned-successor
agent_editable: true
risk_tier: high
change_policy: supersede-with-adr
owner: "@you"
last_reviewed: 2026-02-24
supersedes:
  - principles.md
adr:
  - ../../runtime/decisions/040-principles-charter-successor-v2026-02-24.md
---

# Engineering Principles & Standards (Successor v2026-02-24)

This file is the active successor charter for current framing. The immutable
constitutional charter remains:
`/.harmony/cognition/governance/principles/principles.md`.

## Canonical Goal

Enable reliable agent execution that is deterministic enough to trust,
observable enough to debug, and flexible enough to evolve.

## Active Framing (Normative)

1. Harmony is `agent-first`: it standardizes agent execution across projects
through shared contracts, workflows, capabilities, safety controls, and
auditability.
2. Harmony is `system-governed`: governance runs through default-on contracts,
policy, workflows, and enforcement checks.
3. Humans retain policy authorship, exception handling, and escalation
authority.
4. Complexity language is `minimal sufficient complexity`, `Complexity
Calibration`, and `Complexity Fitness`.
5. Delivery defaults prioritize deterministic behavior, observable operations,
and reversible change.

## Supersession Contract

- Do not edit `principles.md`.
- If this successor needs evolution, create
  `principles-vYYYY-MM-DD.md` and add an ADR that supersedes this version.
- Keep `README.md` and `index.yml` synchronized with the active successor path.
