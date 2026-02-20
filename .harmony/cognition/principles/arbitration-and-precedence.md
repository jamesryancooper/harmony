---
title: Arbitration and Precedence
description: Conflict-resolution rules for principles so RA/ACP governance remains deterministic, fail-closed, and auditable.
pillar: Trust, Direction
status: Active
---

# Arbitration and Precedence

> Resolve principle conflicts with deterministic, policy-bound tie-break rules.

## Rules

1. ACP is the final authority for durable-state promotion and contraction.
2. Deny-by-default is the final authority for capability attempts.
3. Assurance overrides Productivity; Productivity overrides Integration.
4. No Silent Apply is satisfied by receipts/evidence/rollback handles, never standing approvals.
5. Owner attestation is quorum input only, never standalone promotion authority.
6. Deterministic replay is mandatory for promote decisions/receipts; bounded variance requires policy bounds and provenance.
7. Observability tiers must stay within budget/circuit constraints; downgrades require reason code and receipt linkage.
8. Small-diff/trunk thresholds are evaluated per promotable slice, not mission duration.
9. Waivers/overrides must be time-boxed, reason-coded, append-only, and receipt-linked.

## How to Use This Rule

- Identify the conflicting principles and classify whether the conflict is about capability attempts, durable promotion, or supporting controls.
- Apply the rules above in order; higher-order rules win.
- Record the outcome in append-only receipts/digests and include reason codes.

## When Conflicts Arise

1. If the question is "can the actor attempt this operation?", use deny-by-default.
2. If the question is "can this staged change become durable now?", use ACP.
3. If supporting principles disagree, apply Assurance > Productivity > Integration.
4. If uncertainty remains, fail closed to `STAGE_ONLY` or `DENY` and emit a reason-coded receipt.

## Related Documentation

- [Autonomous Control Points](./autonomous-control-points.md)
- [Deny by Default](./deny-by-default.md)
- [Guardrails](./guardrails.md)
- [No Silent Apply](./no-silent-apply.md)
