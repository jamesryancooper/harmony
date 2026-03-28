# Wave 4 Change Inventory

## Constitutional And Structural Authority

- Added `/.octon/framework/constitution/contracts/{assurance,disclosure}/**`
- Activated the Wave 4 assurance and disclosure contract families in
  `/.octon/framework/constitution/contracts/registry.yml`
- Recorded the Wave 4 `release_state`, `change_profile`, and Profile
  Selection Receipt in
  `/.octon/instance/cognition/context/shared/migrations/2026-03-27-assurance-lab-disclosure-expansion-cutover/`
- Added ADR
  `/.octon/instance/cognition/decisions/071-assurance-lab-disclosure-expansion-cutover.md`

## Proof Planes, Lab, And Observability

- Added first-class proof-plane surfaces under
  `/.octon/framework/assurance/{structural,functional,behavioral,recovery,evaluators}/**`
- Added lab-authored scenario and replay contracts under `/.octon/framework/lab/**`
- Added observability-authored measurement and intervention contracts under
  `/.octon/framework/observability/**`
- Updated the constitutional kernel, root manifest, policy-interface config,
  umbrella architecture spec, bootstrap docs, and retained-evidence docs to
  reference the new Wave 4 surfaces

## Retained Evidence And Disclosure

- Extended the retained sample consequential run under
  `/.octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/**` with
  replay, assurance, measurement, intervention, and disclosure families
- Added a normalized RunCard plus supporting proof-plane reports and
  observability artifacts for the retained consequential run bundle
- Added retained lab scenario proof and a support-target-backed HarnessCard
  under `/.octon/state/evidence/lab/**`

## Validators And Alignment

- Added
  `/.octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`
- Updated the harness alignment profile, harness-structure validator,
  architecture-conformance validator, and run validator to include the Wave 4
  contract
- Refreshed generated mission read models plus extension/capability
  publication state during the passing harness alignment run so current
  generated and receipt-backed surfaces reflect the new retained evidence
  contract
