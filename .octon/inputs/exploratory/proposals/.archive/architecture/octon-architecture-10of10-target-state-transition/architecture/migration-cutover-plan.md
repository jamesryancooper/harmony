# Migration and Cutover Plan

## Cutover posture

The transition must be additive, fail-closed, and reversible until the closure certificate is retained. No implementation step may broaden runtime authority, support claims, pack admission, extension availability, or generated/effective consumption.

## Cutover sequence

1. **Contract landing** — promote new specs, schemas, fail-closed obligations, evidence obligations, and registry entries.
2. **Resolver dual-read phase** — runtime resolver supports current route bundle locks and new handle contract but emits warnings for legacy freshness semantics.
3. **Publication regeneration** — regenerate route bundle, pack routes, extension catalog, support matrix, and locks under v2/v3 freshness semantics.
4. **Hard-enforce phase** — grants require handle verification; raw generated/effective path reads fail closed.
5. **Capability-pack cutover** — runtime pack projection becomes frozen compatibility; generated/effective pack routes become the only runtime-facing route surface.
6. **Extension hardening** — selected/active/quarantine/published states are validated by handle and negative controls.
7. **Proof upgrade** — live support dossiers require executable proof bundles; shallow proof downgrades claims.
8. **Architecture-health v2** — closure-grade depth-aware `octon doctor --architecture` becomes the target gate.
9. **Compatibility retirement** — retired or frozen compatibility surfaces are recorded with evidence and no longer consumed by runtime.

## Compatibility handling

| Surface | Interim treatment | Target treatment |
|---|---|---|
| `instance/capabilities/runtime/packs/**` | Retained compatibility projection; may be read by validators for migration comparison. | Not consumed by runtime; frozen or retired. |
| Workflow execution wrappers | Retained compatibility wrapper over run-first lifecycle. | Keep only as explicit wrapper; no workflow-first authority. |
| Root `AGENTS.md` / `CLAUDE.md` | Keep as ingress parity projections. | Keep if parity validation passes. |
| Support-card projections | Keep as generated operator read models. | Keep, but validate no-widening against canonical support targets/dossiers. |
| Generated/effective runtime outputs | Keep runtime-facing only through resolver. | Keep as handle-verified compiled outputs, not authority. |

## Rollback posture

Rollback must restore the previous runtime selector, previous route bundle and lock, previous pack routes and lock, previous extension publication state, and previous validator set. Rollback must not restore any stale generated/effective artifact without its matching receipt and lock.

## No-big-bang rule

The proposal forbids a single unvalidated cutover that changes contracts, runtime resolver, support claims, pack routes, and publication outputs at once. Each phase must retain evidence before the next phase broadens enforcement.
