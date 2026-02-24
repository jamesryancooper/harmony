# Engine Governance

`governance/` defines normative contracts for engine evolution and release safety.

## Runtime Authority Contract (ENGINE-GOV-001)

- Engine authority: `engine/runtime/` owns execution lifecycle, runtime safety
  controls, and final execution gating.
- Capabilities authority: `capabilities/runtime/` owns behavioral semantics,
  capability taxonomy, and discovery metadata for capability classes.

Tie-breaker:

- If capability semantics conflict with engine enforcement, engine enforcement
  wins for execution.
- If no explicit contract resolves the conflict, fail closed and escalate
  through ADR-backed contract updates before promotion.

## Contracts

- `protocol-versioning.md`
- `compatibility-policy.md`
- `release-gates.md`
