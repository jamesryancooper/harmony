---
title: Arbitration and Precedence
description: Single normative conflict-resolution contract for RA/ACP governance.
pillar: Trust, Direction
status: Active
---

# Arbitration and Precedence

> Resolve principle conflicts with deterministic, policy-bound tie-break rules.

## Normative Rules (SSOT)

1. Capability-attempt authority is deny-by-default policy output only.
2. Durable promotion/finalize authority is ACP gate output only.
3. `apply` for durable state is interpreted as `promote` unless explicitly stage-only/read-only.
4. Owner attestation is quorum input only; it is never standalone promotion authority.
5. Term collisions are resolved by [RA/ACP Glossary](./_meta/ra-acp-glossary.md) definitions.
6. Evidence-minima collisions are resolved by [RA/ACP Promotion Inputs Matrix](./_meta/ra-acp-promotion-inputs-matrix.md).
7. Non-normative guidance/examples cannot weaken fail-closed controls in policy.
8. If principles disagree and no explicit mapping exists, fail closed with reason-coded `STAGE_ONLY` or `DENY`.
9. Normative arbitration text remains in this document only; other principles must link out instead of restating arbitration rules.

## Application Order

1. Determine whether the question is capability-attempt, durable promotion/finalize (including `contraction` alias), or supporting governance semantics.
2. Apply the corresponding authority rule above.
3. If unresolved, apply fail-closed behavior and emit reason-coded receipts.

## Related Documentation

- [Autonomous Control Points](./autonomous-control-points.md)
- [Deny by Default](./deny-by-default.md)
- [Guardrails](./guardrails.md)
- [No Silent Apply](./no-silent-apply.md)
- [Waivers and Exceptions](./_meta/waivers-and-exceptions.md)
