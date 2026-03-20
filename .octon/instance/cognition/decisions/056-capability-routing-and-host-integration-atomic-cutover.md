# ADR 056: Capability Routing And Host Integration Atomic Cutover

- Date: 2026-03-20
- Status: Accepted
- Deciders: Octon maintainers
- Related:
  - `/.octon/inputs/exploratory/proposals/.archive/architecture/capability-routing-host-integration/`
  - `/.octon/instance/cognition/context/shared/migrations/2026-03-20-capability-routing-host-integration-cutover/plan.md`
  - `/.octon/generated/effective/capabilities/routing.effective.yml`

## Context

Packet 12 formalizes generated, scope-aware, extension-aware capability
routing, but the live repository still carried four categories of drift:

1. capability publication was still a minimal catalog rather than a full
   routing contract,
2. scope routing hints were still schema-loose and not part of the generated
   routing linkage,
3. host surfaces still depended on symlink-era discovery and stale command
   wrappers, and
4. extension publication still exposed routing only through `content_roots`
   rather than explicit routing exports.

That left one final routing risk: even with generated capability outputs
present, active consumers, docs, and projection workflows could still behave
as though raw trees or existing symlinks were authoritative.

## Decision

Promote Packet 12 as one atomic clean-break cutover.

Rules:

1. `generated/effective/capabilities/**` is the only live routing surface.
2. Framework and instance capability definitions now carry explicit routing and
   host-adapter metadata.
3. Scope manifests move to `octon-locality-scope-v2` and only allow the
   bounded routing hint keys ratified by Packet 12.
4. Extension publication moves to `v3` and exports routing-ready command and
   skill metadata through `routing_exports`.
5. Host adapter surfaces are materialized projections, not symlinks, and are
   regenerated only from the published routing view plus compiled extension
   exports.
6. `.codex/commands/` becomes a first-class projected host surface.
7. Routing and host validators fail closed on stale locality linkage, stale
   extension linkage, raw `inputs/**` leakage, host projection drift, or
   legacy symlink-era leftovers.
8. Rollback is full-revert-only for the cutover change set.

## Consequences

### Benefits

- One deterministic routing publication used by runtime and host adapters.
- No symlink-first or `.harmony` command drift remains in active host
  surfaces.
- Extension-origin routing candidates now flow through compiled extension
  exports instead of raw content-root rediscovery.
- New harness templates and active creation docs default to the Packet 12
  contract.

### Costs

- Broad one-shot sweep across manifests, schemas, publishers, validators,
  host projections, generated outputs, tests, and active docs.
- Increased generated host-surface churn because projected host directories are
  now materialized copies.

### Follow-on Work

1. Packet 13 can consume the new routing and extension publication metadata
   for portability/trust without reopening routing precedence.
2. Packet 14 can enforce Packet 12 failures as first-class stale-generation
   and quarantine rules.
3. Packet 15 can remove any remaining historical plan-only references to the
   old host-link model without affecting runtime behavior.
