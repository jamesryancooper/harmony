# ADR 091: Browser And API Live-Claim Restaging

- Date: 2026-04-18
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/framework/capabilities/runtime/services/manifest.runtime.yml`
  - `/.octon/framework/capabilities/runtime/services/{browser-session,api-client}/contract.yml`
  - `/.octon/instance/governance/support-targets.yml`
  - `/.octon/instance/capabilities/runtime/packs/registry.yml`

## Context

Browser/API contracts exist, but the active runtime service manifest does not
admit `browser-session` or `api-client`. Active support-target admissions,
capability-pack registries, and disclosure currently outstate that reality.

## Decision

Restage browser and API live claims to non-live until the runtime substrate is
actually admitted.

Rules:

1. Browser/API capability packs remain governed design surfaces but are
   `unadmitted` for the active live claim.
2. Any tuple whose live claim depends on those packs becomes `stage_only`.
3. Runtime or disclosure widening requires:
   - runtime service manifest admission,
   - retained replay/event or request/response evidence,
   - support-target tuple admission,
   - support dossier proof,
   - negative-test and assurance coverage.

## Consequences

- The repo stops claiming browser/API support it cannot presently substantiate.
- Historical evidence remains retained but non-authoritative for current live
  claim semantics.
- Full frontier target-state closure remains blocked until these criteria are met.
