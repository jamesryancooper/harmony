# Runtime Route Map

Generated at: `2026-04-23T13:19:44Z`

Non-authority disclaimer: this map is derived from canonical authored authority, retained evidence, and freshness-gated generated/effective outputs. It does not mint authority.

Source refs:

- `/.octon/framework/engine/runtime/spec/runtime-resolution-v1.md`
- `/.octon/instance/governance/runtime-resolution.yml`
- `/.octon/generated/effective/runtime/route-bundle.yml`
- `/.octon/generated/effective/runtime/route-bundle.lock.yml`
- `/.octon/state/evidence/validation/architecture/10of10-target-transition/publication/freshness.yml`

Route bundle generation: `runtime-route-bundle-d832aab6f332`
Publication receipt: `.octon/state/evidence/validation/publication/runtime/2026-04-23T13-18-16Z-runtime-route-bundle-d832aab6f332.yml`
Freshness mode: `digest_bound`
Validator refs:

- `/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-route-bundle.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-artifact-handles.sh`
- `/.octon/framework/assurance/runtime/_ops/scripts/validate-no-raw-generated-effective-runtime-reads.sh`

Runtime consumers: `runtime_resolver`, `validators`
Forbidden consumers: `direct_runtime_raw_path_read`, `generated_cognition_as_authority`

## Tuple Routes
- `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
- `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
- `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/ci-control-plane`: `admitted-live-claim`, route=`allow`
- `tuple://repo-local-governed/boundary-sensitive/reference-owned/english-primary/repo-shell`: `stage-only-non-live`, route=`stage_only`
- `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/github-control-plane`: `admitted-live-claim`, route=`allow`
- `tuple://frontier-governed/boundary-sensitive/extended-governed/spanish-secondary/studio-control-plane`: `stage-only-non-live`, route=`stage_only`
