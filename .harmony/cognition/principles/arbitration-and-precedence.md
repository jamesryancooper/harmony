---
title: Arbitration and Precedence
description: Conflict-resolution rules for principles so RA/ACP governance remains deterministic, fail-closed, and auditable.
pillar: Trust, Direction
status: Active
---

# Arbitration and Precedence

> Resolve principle conflicts with deterministic, policy-bound tie-break rules.

## Rules

1. Capability attempt questions are resolved only by Deny-by-Default policy outputs.
2. Durable promotion/contraction questions are resolved only by ACP gate outcomes.
3. Receipt-required evidence is canonical; PR evidence is a derived projection when a PR exists.
4. `apply` for durable state is interpreted as `promote` unless explicitly read-only or stage-only.
5. Owner attestation is never a standalone gate; missing attestation defaults to bounded `STAGE_ONLY` with reason code.
6. Risk tier to ACP mapping must come from one policy table (`acp.risk_tier_mapping`) referenced by ACP and observability docs.
7. Cross-principle disagreement without explicit mapping fails closed (`STAGE_ONLY` or `DENY`).
8. Waivers are valid only if time-boxed, reason-coded, append-only, and receipt-linked.
9. ACP-4 is blocked-by-default and out-of-band for routine autonomous runs.
10. Principle reference-integrity failures must fail governance lint before merge.

## How to Use This Rule

- Identify the conflicting principles and classify whether the conflict is about capability attempts, durable promotion, or supporting controls.
- Apply the rules above in order; higher-order rules win.
- Record the outcome in append-only receipts/digests and include reason codes.

## When Conflicts Arise

1. If the question is "can the actor attempt this operation?", use deny-by-default.
2. If the question is "can this staged change become durable now?", use ACP.
3. If supporting principles disagree and no explicit mapping exists, fail closed.
4. If uncertainty remains, emit reason-coded `STAGE_ONLY`/`DENY` and receipts.

## Related Documentation

- [Autonomous Control Points](./autonomous-control-points.md)
- [Deny by Default](./deny-by-default.md)
- [Guardrails](./guardrails.md)
- [No Silent Apply](./no-silent-apply.md)
