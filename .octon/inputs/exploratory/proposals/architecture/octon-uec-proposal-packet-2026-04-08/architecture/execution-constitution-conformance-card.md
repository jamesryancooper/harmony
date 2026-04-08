# Execution Constitution Conformance Card

## Identity

- **System:** Octon
- **Claim target:** Full Unified Execution Constitution attainment
- **Post-cutover claim allowed only if:** universal support universe admitted, no in-scope exclusions remain, dual-pass certification green

## Control Artifacts

- constitutional kernel: `/.octon/framework/constitution/**`
- repo-specific durable authority: `/.octon/instance/**`
- objective stack: workspace charter → mission charter (when required) → run contract → stage attempt
- support-target matrix: `/.octon/instance/governance/support-targets.yml`
- capability pack manifests: `/.octon/instance/governance/capability-packs/**`

## Runtime Policy

- run-first lifecycle
- canonical run control root + canonical evidence root before side effects
- durable checkpoints, rollback posture, contamination state, retry records
- fail-closed routing on unsupported or under-approved actions
- no authority minted by host projections

## Authoritative Execution / Policy Surfaces

- runtime control truth: `/.octon/state/control/execution/runs/**`
- authority artifacts: `/.octon/state/evidence/control/execution/**`
- retained evidence: `/.octon/state/evidence/**`

## Execution Topology

- kernel agent: orchestrator
- model adapters: repo-local-governed, frontier-governed
- host adapters: repo-shell, github-control-plane, ci-control-plane, studio-control-plane
- capability packs: repo, git, shell, telemetry, browser, api

## Feedback / Validation Stack

- blocking validators: 23
- proof planes: structural, functional, behavioral, governance, maintainability, recovery
- mandatory dual-pass regeneration + validation with no second-pass constitution diff

## Governance / Observability Surfaces

- intervention and measurement contracts under `/.octon/framework/observability/runtime/contracts/**`
- intervention and measurement evidence under `/.octon/state/evidence/runs/**`
- release closure bundle under `/.octon/state/evidence/disclosure/releases/<cutover-release-id>/closure/**`

## Evaluation Protocol

- admitted support-target tuples must pass conformance and proof coverage
- held-out evaluator independence required for behavioral/research-heavy claims
- support-target, capability-pack, and disclosure parity must be validated against canonical sources

## Release Artifacts

- final HarnessCard
- regenerated RunCards
- closure summary
- closure certificate
- durable closeout ADR

## Known Residual Risks Allowed After Certification

Only residual risks that are explicitly disclosed, do not violate any invariant, and do not create unresolved in-scope work may remain. Residual risk may never include:
- shadow authority
- missing proof planes
- unresolved support-target exclusions
- hidden human repair
- missing external replay proof

## Exact Success Criteria

Octon may call the Unified Execution Constitution “fully attained” only if:
1. every finding in the gap map is closed
2. every invariant is green
3. every blocking validator is green on pass 1 and pass 2
4. pass 2 produces no constitution-related diff
5. admitted universe == target universe
6. final HarnessCard contains no in-scope exclusions
7. closure certificate and durable ADR closeout exist
