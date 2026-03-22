# ADR 061: Harness Integrity Tightening Atomic Cutover

- Date: 2026-03-22
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/harness-integrity-tightening/`
  - `/.octon/framework/cognition/_meta/architecture/contract-registry.yml`
  - `/.octon/state/evidence/migration/2026-03-22-harness-integrity-tightening-cutover/`

## Context

Octon's architecture already required framework-local `_ops/**` to stay
portable, retained execution evidence to live under `state/evidence/runs/**`,
and outbound/model execution to remain fail-closed. The live runtime still
drifted from that contract in four material ways:

1. `RuntimeConfig` still exposed a framework-local mutable `state_dir`,
2. `TraceWriter` still emitted under that framework-local state root,
3. `execution/flow` still inherited ambient `net.http`, and
4. spend governance plus cross-surface path invariants were not yet enforced
   from one machine-readable registry.

## Decision

Promote harness integrity tightening as one atomic clear-break cutover.

Rules:

1. Runtime write targets are explicit:
   `state/evidence/runs/**`, `state/control/execution/**`, and
   `generated/.tmp/execution/**`.
2. `authorize_execution(...)` remains the engine-owned material side-effect
   boundary and binds the canonical retained run root before retained artifacts
   are emitted.
3. `TraceWriter` writes `trace.ndjson` into the canonical retained run root.
4. `execution/flow` no longer grants ambient `net.http`; outbound HTTP is legal
   only through repo-owned destination-scoped policy plus retained run evidence.
5. Repo-owned execution budgets govern model-backed execution with mutable
   budget state, retained `cost.json`, and stage/deny behavior.
6. The machine-readable architecture contract registry and blocking assurance
   validator become the canonical anti-drift enforcement path.
7. The `harness-integrity-tightening` proposal package is archived as
   implemented once the durable runtime, governance, assurance, CI, and doc
   surfaces are promoted.

## Consequences

### Benefits

- Runtime writes now align with the declared super-root model instead of
  leaking through framework-local mutable state.
- Flow egress is explicitly justified and evidenced instead of ambient.
- Model-backed execution now has repo-owned spend governance and retained cost
  evidence.
- Architecture path invariants are enforced by code, validators, and CI rather
  than by doc memory alone.

### Costs

- Engine runtime, host bindings, policy/config contracts, assurance scripts,
  generated capability publication, and multiple architecture/docs surfaces all
  changed together.
- Capability publication had to be refreshed so routing hashes matched the
  updated flow documentation and policy surfaces.
- Harness alignment required elevated host-projection refresh to update live
  `.codex` projections in this environment.

### Follow-on Work

1. Promote richer actual-cost accounting when executor runtimes can emit stable
   token usage without heuristics.
2. Expand repo-owned egress rules only through explicit governance changes; do
   not restore ambient HTTP allowance.
