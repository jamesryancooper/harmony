# Support Pack Route Map

Generated at: `2026-04-22T03:44:21Z`

Non-authority disclaimer: this derived read model traces support tuples, pack routes, and retained receipts. Canonical authority remains in `framework/**`, `instance/**`, `state/**`, and freshness-gated generated/effective outputs.

Source refs:

- `/.octon/framework/engine/runtime/spec/runtime-resolution-v1.md`
- `/.octon/instance/governance/support-targets.yml`
- `/.octon/generated/effective/capabilities/pack-routes.effective.yml`
- `/.octon/generated/effective/capabilities/pack-routes.lock.yml`
- `/.octon/state/evidence/validation/architecture/10of10-target-transition/capabilities/pack-route-no-widening.yml`

## Pack Routes
- `repo`: status=`admitted`
  - `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
  - `tuple://repo-local-governed/boundary-sensitive/reference-owned/english-primary/repo-shell`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/github-control-plane`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/ci-control-plane`: `admitted-live-claim`, route=`allow`
  - `tuple://frontier-governed/boundary-sensitive/extended-governed/spanish-secondary/studio-control-plane`: `stage-only-non-live`, route=`stage_only`
- `git`: status=`admitted`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
  - `tuple://repo-local-governed/boundary-sensitive/reference-owned/english-primary/repo-shell`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/github-control-plane`: `stage-only-non-live`, route=`stage_only`
  - `tuple://frontier-governed/boundary-sensitive/extended-governed/spanish-secondary/studio-control-plane`: `stage-only-non-live`, route=`stage_only`
- `shell`: status=`admitted`
  - `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
  - `tuple://repo-local-governed/boundary-sensitive/reference-owned/english-primary/repo-shell`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/github-control-plane`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/ci-control-plane`: `admitted-live-claim`, route=`allow`
  - `tuple://frontier-governed/boundary-sensitive/extended-governed/spanish-secondary/studio-control-plane`: `stage-only-non-live`, route=`stage_only`
- `telemetry`: status=`admitted`
  - `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/repo-shell`: `admitted-live-claim`, route=`allow`
  - `tuple://repo-local-governed/boundary-sensitive/reference-owned/english-primary/repo-shell`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/github-control-plane`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/ci-control-plane`: `admitted-live-claim`, route=`allow`
  - `tuple://frontier-governed/boundary-sensitive/extended-governed/spanish-secondary/studio-control-plane`: `stage-only-non-live`, route=`stage_only`
- `browser`: status=`unadmitted`
  - `tuple://repo-local-governed/boundary-sensitive/reference-owned/english-primary/repo-shell`: `stage-only-non-live`, route=`stage_only`
  - `tuple://frontier-governed/boundary-sensitive/extended-governed/spanish-secondary/studio-control-plane`: `stage-only-non-live`, route=`stage_only`
- `api`: status=`unadmitted`
  - `tuple://repo-local-governed/boundary-sensitive/reference-owned/english-primary/repo-shell`: `stage-only-non-live`, route=`stage_only`
  - `tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/github-control-plane`: `stage-only-non-live`, route=`stage_only`
  - `tuple://frontier-governed/boundary-sensitive/extended-governed/spanish-secondary/studio-control-plane`: `stage-only-non-live`, route=`stage_only`
