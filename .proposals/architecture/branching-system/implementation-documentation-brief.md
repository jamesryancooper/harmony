# Implementation Documentation Brief

This is the documentation and contract set the downstream research agent should specify in its recommendation if it recommends any form of descendant-local sidecar architecture.

## 1. Core Architecture Decision Artifacts

- ADR or equivalent architecture decision record for the descendant-local sidecar concept
- explicit statement of whether the concept is adopted, narrowed, or rejected
- terminology decision record for the chosen name and rejected alternatives
- change-profile recommendation for implementation (`atomic` or `transitional`) with justification

## 2. Canonical Architecture Contract Updates

- umbrella architecture update describing the relationship between `/.octon/`, `/.extensions/`, and descendant-local sidecars
- bounded-surfaces update if any concern boundaries change
- runtime-vs-ops update if local sidecars can contain operational state
- portability manifest contract update for any new metadata in `octon.yml`
- contract-registry updates for any new contract-bearing surfaces, including required machine-readable metadata such as `contract_id`, `path`, `owner`, `version`, `supersedes`, and `enforced_by`

## 3. Authority And Precedence Documentation

- source-of-truth map for:
  - `/.octon/`
  - `/.extensions/`
  - descendant-local sidecars
  - effective/derived projections
- authority/precedence contract for conflicts and tie-breakers
- inheritance contract defining what is inherited, shadowed, merged, or forbidden
- fail-closed contract for ambiguous, invalid, stale, or conflicting local content

## 4. Filesystem And Topology Documentation

- canonical filesystem layout for any local sidecar
- naming convention and path-placement rules
- allowed and forbidden artifact classes
- one-sidecar-vs-many-sidecars rule
- local-sidecar discovery model from an arbitrary descendant working directory

## 5. Discovery, Merge, And Effective-Resolution Contracts

- discovery-index contract for local sidecars if discovery is explicit
- effective-resolution contract if runtime-facing catalogs are compiled
- collision policy across:
  - native `/.octon/`
  - `/.extensions/`
  - local sidecars
- rebasing rules for any local artifact that declares writes or outputs

## 6. Cognition / Memory / Decision Placement Documentation

- memory-class routing update explaining where local context, local memory, local decisions, and local evidence belong
- distinction between:
  - active work state
  - durable context
  - ADR-grade decisions
  - decision evidence
  - graph materializations
  - projections
- local-to-root publication/promotion rules if local artifacts can become repo-wide truths

## 7. Validation And Assurance Documentation

- validator specifications for local-sidecar structure and schema
- invariant checks for forbidden artifact classes
- validation rules for inheritance, precedence, and collision handling
- assurance entrypoint updates so local-sidecar validity is checked during alignment/structure validation
- stale-generation or stale-local-content invalidation rules where applicable
- enforcement-binding coverage so new contract-bearing surfaces satisfy canonical registry and assurance expectations rather than existing as undocumented policy/doc drift

## 8. Authoring And Operator Documentation

- authoring guide for creating and maintaining a local sidecar
- migration guide from current root-only patterns
- troubleshooting guide for validation failures and precedence conflicts
- operator workflows/commands for:
  - validate local sidecar
  - inspect effective view
  - disable or quarantine invalid local sidecar content

## 9. Example And Reference Material

- at least one minimal example
- at least one realistic multi-artifact example
- at least one conflict/failure example showing fail-closed behavior
- example showing interplay with `/.extensions/` if both concepts survive

## 10. Implementation Planning Outputs

The downstream agent should specify that implementation planning include:

- impact map across code, tests, docs, contracts, scaffolding, and assurance
- migration plan if current canonical architecture must change first
- rollback/decommission plan for temporary or transitional surfaces
- test plan covering both source behavior and effective/derived behavior

## Minimum Checklist For The Downstream Recommendation

- chosen concept name
- adopt / narrow / reject decision
- authority model
- precedence model
- filesystem model
- artifact placement model
- discovery/inheritance model
- fail-closed model
- `/.extensions/` relationship
- cognition/memory/decision interaction model
- implementation-doc set required before rollout
