# ADR-UEC-003 Runtime Authority Centralization

- Status: active
- Date: 2026-04-08
- Decision: Canonical runtime and governance surfaces are the only origin of
  authority artifacts. Host systems remain projections only.
- Scope: approvals, grants, leases, revocations, decisions, and host workflows
- Canonical refs:
  - `/.octon/framework/engine/runtime/adapters/host/github-control-plane.yml`
  - `/.github/workflows/pr-autonomy-policy.yml`
  - `/.github/workflows/ai-review-gate.yml`
  - `/.octon/framework/constitution/contracts/authority/**`
- Reopen only if a new host adapter requires a stronger central mechanism.
