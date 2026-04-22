# Cutover Checklist

## Pre-cutover

- [ ] Confirm proposal reviewed and accepted for promotion.
- [ ] Confirm clean git worktree or dedicated promotion branch/worktree.
- [ ] Snapshot current route bundle, route-bundle lock, pack routes, extension catalog, support matrix, and relevant receipts.
- [ ] Run current `octon doctor --architecture` and retain baseline evidence.
- [ ] Confirm no unsupported support broadening is included.

## Contract landing

- [ ] Promote runtime-effective handle spec and schema.
- [ ] Promote route-bundle lock v2 schema.
- [ ] Promote publication freshness gates v3.
- [ ] Promote architecture-health contract v2.
- [ ] Update fail-closed obligations.
- [ ] Update evidence obligations.
- [ ] Update contract registry and architecture spec.

## Runtime landing

- [ ] Implement resolver handle API.
- [ ] Update authority engine grant path to require handle verification.
- [ ] Add raw generated/effective read prohibition tests.
- [ ] Add stale route-bundle denial tests.
- [ ] Add side-effect discovery/coverage validator.

## Publication cutover

- [ ] Regenerate route bundle.
- [ ] Regenerate route-bundle lock under explicit freshness mode.
- [ ] Regenerate pack routes and lock.
- [ ] Regenerate extension catalog and generation lock.
- [ ] Regenerate support matrix.
- [ ] Retain publication receipts.

## Pack and extension cutover

- [ ] Freeze or retire `instance/capabilities/runtime/packs/**` as steady-state runtime surface.
- [ ] Update retirement register.
- [ ] Update non-authority register.
- [ ] Validate pack-route no-widening.
- [ ] Validate selected/active/quarantine/published extension states.

## Proof and support

- [ ] Upgrade representative support proof bundles to executable format.
- [ ] Validate support dossier sufficiency.
- [ ] Validate support card no-widening.
- [ ] Run proof-bundle executability validator.

## Operator/read models

- [ ] Generate architecture map.
- [ ] Generate runtime route map.
- [ ] Generate support-pack-route map.
- [ ] Generate compatibility retirement map.
- [ ] Validate traceability and non-authority posture.

## Final closure

- [ ] Run architecture-health v2.
- [ ] Retain closure certificate.
- [ ] Confirm no runtime consumer reads retired projections.
- [ ] Confirm generated/effective artifacts are handle-verified.
- [ ] Confirm proposal can be archived as non-authoritative historical evidence.
