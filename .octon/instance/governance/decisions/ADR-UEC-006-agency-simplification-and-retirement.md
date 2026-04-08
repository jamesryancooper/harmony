# ADR-UEC-006 Agency Simplification And Retirement

- Status: active
- Date: 2026-04-08
- Decision: `orchestrator` remains the sole active kernel agent. Legacy
  architect/persona surfaces remain retired from live runtime paths.
- Scope: agency runtime discovery and tool-facing projections
- Canonical refs:
  - `/.octon/framework/agency/manifest.yml`
  - `/.octon/framework/agency/runtime/agents/orchestrator/**`
  - `/.octon/instance/governance/retirement-register.yml`
- Reopen only if stronger separation-of-duties evidence requires a new active
  kernel role.
