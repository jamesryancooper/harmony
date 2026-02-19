---
title: Deny by Default
description: Agents and systems have no permissions until explicitly granted. Security through explicit allowlists, not blocklists.
pillar: Trust
status: Active
---

# Deny by Default

> Agents and systems have no permissions until explicitly granted. Start with zero access; add only what is needed.

## Purpose

Deny by default means Harmony grants no operational permissions unless they are
explicitly allowlisted. Any missing, unknown, or ambiguous permission decision
must fail closed.

This principle applies to:

- tool access
- filesystem writes
- network access
- service capability grants
- exception handling and temporary elevation

## Why It Matters

- Limits blast radius from faulty prompts, code, or model behavior.
- Preserves deterministic behavior across agent and service executions.
- Makes policy intent auditable and reviewable.
- Enables safe autonomous operation when no human is in the loop.

## Enforced Model in Harmony

Harmony currently uses two enforcement lanes plus shared validation:

1. Runtime service lane (WASM/native runtime):
   - Services declare `capabilities_required` in `service.json`.
   - Runtime policy allowlists live in `.harmony/runtime/config/policy.yml`.
   - Runtime policy engine grants only declared capabilities and denies missing
     capabilities (`.harmony/runtime/crates/core/src/policy.rs`).

2. Skill and shell-service lane:
   - `allowed-tools` in `SKILL.md` and `SERVICE.md` is authoritative for tool
     and scoped write declarations.
   - Validation scripts fail active artifacts that use unscoped or disallowed
     patterns.
   - Execution wrappers enforce scoped permissions at runtime before launching
     shell entrypoints.

3. Shared safety invariants:
   - deny-by-default baseline (`allow: []` unless explicit allowlist)
   - fail-closed on parse/evaluation/enforcement errors
   - auditable denial/elevation records

## Permission Vocabulary

Harmony uses allowlisted tokens such as:

- `Read`, `Glob`, `Grep`, `Edit`
- `Write(<scoped-path>)` with explicit path scope only
- `Bash(<scoped-command>)` with explicit command scope only
- `WebFetch`, `WebSearch`, `Task`, and approved packs

Rules:

- Bare `Bash` and bare `Write` are prohibited for active skills and services.
- Broad write scopes (for example, workspace-root recursive globs) require a
  time-boxed exception lease.
- Unknown tools are denied.

## Fail-Closed Requirements

Any of the following must return deny and stop execution:

- missing policy data
- unknown tool token or malformed scope
- path/command scope mismatch
- capability required but not granted
- expired or missing exception metadata

No permissive fallback is allowed.

## Exception Protocol (Time-Boxed Elevation)

Temporary elevation is allowed only when all fields are present:

- `id`
- `scope` (`skill` or `service`)
- `target`
- `rule`
- `owner`
- `reason`
- `created`
- `expires`

Exception leases must be stored in a tracked policy file, validated in CI, and
rejected when expired. Permanent broad permissions are not allowed.

## Human-in-the-Loop and Agent-Only Modes

Deny-by-default supports both modes:

- HITL mode: high-risk actions may require explicit human confirmation.
- Agent-only mode: policy packages replace manual approvals using risk tiers,
  separation-of-duties checks, and automatic rollback/kill-switch behavior.

In both modes, enforcement remains fail-closed and deterministic.

## Development Speed Guidance

Deny-by-default should not block normal low-risk iteration. Harmony uses:

- low-risk `dev-fast` profiles with pre-scoped safe defaults
- policy suggestion tooling for minimal required grants
- precise denial diagnostics that point to exact remediation
- short-lived exception leases instead of permanent broad access

This keeps individual edits fast while retaining repository-level safety.

## Anti-Patterns

- blocklist-first policy
- unscoped `Bash` or `Write`
- broad workspace write grants without expiry
- fail-open error handling
- policy docs that diverge from enforceable runtime behavior

## Related Documentation

- [Trust Pillar](../pillars/trust.md)
- [HITL Checkpoints](./hitl-checkpoints.md)
- [Skills Specification](../../capabilities/_meta/architecture/specification.md)
- [Runtime Policy](../_meta/architecture/runtime-policy.md)
- [ADR 019](../decisions/019-deny-by-default-uniform-enforcement-and-agent-only-operation.md)
