# Engine Governance

`governance/` defines normative contracts for engine evolution and release safety.

## Runtime Authority Contract (ENGINE-GOV-001)

- Engine authority: `engine/runtime/` owns execution lifecycle, runtime safety
  controls, final execution gating, and runtime enforcement semantics.
- Capabilities authority: `capabilities/runtime/` owns capability declaration
  semantics, capability taxonomy, and discovery metadata for capability classes.

Boundary detail:

- `runtime-capability-authority-boundary.md` is the contract for non-overlapping
  ownership, dependency direction, and deterministic tie-breaker rules.

Tie-breaker:

- If capability semantics conflict with engine enforcement, engine enforcement
  wins for execution.
- If no explicit contract resolves the conflict, fail closed and escalate
  through ADR-backed contract updates before promotion.

## Contracts

- `protocol-versioning.md`
- `compatibility-policy.md`
- `release-gates.md`
- `runtime-capability-authority-boundary.md`
