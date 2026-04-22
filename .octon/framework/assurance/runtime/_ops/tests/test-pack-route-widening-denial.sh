#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
FIXTURE="$(mktemp -d)"
cleanup_fixture() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  find "$dir" -depth -mindepth 1 \( -type f -o -type l \) -exec rm -f {} +
  find "$dir" -depth -type d -empty -exec rmdir {} +
}
trap 'cleanup_fixture "$FIXTURE"' EXIT

mkdir -p \
  "$FIXTURE/.octon/instance/governance/contracts" \
  "$FIXTURE/.octon/instance/governance/capability-packs" \
  "$FIXTURE/.octon/instance/governance/support-target-admissions/live" \
  "$FIXTURE/.octon/instance/governance/support-target-admissions/stage-only" \
  "$FIXTURE/.octon/instance/governance/support-dossiers/live/repo-shell-observe-read-en" \
  "$FIXTURE/.octon/instance/governance/support-dossiers/live/repo-shell-repo-consequential-en" \
  "$FIXTURE/.octon/instance/governance/support-dossiers/live/ci-observe-read-en" \
  "$FIXTURE/.octon/instance/governance/support-dossiers/stage-only/repo-shell-boundary-sensitive-en" \
  "$FIXTURE/.octon/instance/governance/support-dossiers/stage-only/github-repo-consequential-en" \
  "$FIXTURE/.octon/instance/governance/support-dossiers/stage-only/frontier-studio-boundary-sensitive-es" \
  "$FIXTURE/.octon/instance/capabilities/runtime/packs/admissions" \
  "$FIXTURE/.octon/instance/capabilities/runtime/packs" \
  "$FIXTURE/.octon/generated/effective/capabilities"

cp "$ROOT_DIR/.octon/instance/governance/contracts/support-pack-admission-alignment.yml" "$FIXTURE/.octon/instance/governance/contracts/support-pack-admission-alignment.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-targets.yml" "$FIXTURE/.octon/instance/governance/support-targets.yml"
cp "$ROOT_DIR/.octon/instance/governance/capability-packs/registry.yml" "$FIXTURE/.octon/instance/governance/capability-packs/registry.yml"
cp "$ROOT_DIR/.octon/instance/capabilities/runtime/packs/registry.yml" "$FIXTURE/.octon/instance/capabilities/runtime/packs/registry.yml"
cp "$ROOT_DIR/.octon/generated/effective/capabilities/pack-routes.effective.yml" "$FIXTURE/.octon/generated/effective/capabilities/pack-routes.effective.yml"

for file in repo git shell telemetry api browser; do
  cp "$ROOT_DIR/.octon/instance/governance/capability-packs/$file.yml" "$FIXTURE/.octon/instance/governance/capability-packs/$file.yml"
  cp "$ROOT_DIR/.octon/instance/capabilities/runtime/packs/admissions/$file.yml" "$FIXTURE/.octon/instance/capabilities/runtime/packs/admissions/$file.yml"
done

cp "$ROOT_DIR/.octon/instance/governance/support-target-admissions/live/repo-shell-observe-read-en.yml" "$FIXTURE/.octon/instance/governance/support-target-admissions/live/repo-shell-observe-read-en.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-target-admissions/live/repo-shell-repo-consequential-en.yml" "$FIXTURE/.octon/instance/governance/support-target-admissions/live/repo-shell-repo-consequential-en.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-target-admissions/live/ci-observe-read-en.yml" "$FIXTURE/.octon/instance/governance/support-target-admissions/live/ci-observe-read-en.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-target-admissions/stage-only/repo-shell-boundary-sensitive-en.yml" "$FIXTURE/.octon/instance/governance/support-target-admissions/stage-only/repo-shell-boundary-sensitive-en.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-target-admissions/stage-only/github-repo-consequential-en.yml" "$FIXTURE/.octon/instance/governance/support-target-admissions/stage-only/github-repo-consequential-en.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-target-admissions/stage-only/frontier-studio-boundary-sensitive-es.yml" "$FIXTURE/.octon/instance/governance/support-target-admissions/stage-only/frontier-studio-boundary-sensitive-es.yml"

cp "$ROOT_DIR/.octon/instance/governance/support-dossiers/live/repo-shell-observe-read-en/dossier.yml" "$FIXTURE/.octon/instance/governance/support-dossiers/live/repo-shell-observe-read-en/dossier.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-dossiers/live/repo-shell-repo-consequential-en/dossier.yml" "$FIXTURE/.octon/instance/governance/support-dossiers/live/repo-shell-repo-consequential-en/dossier.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-dossiers/live/ci-observe-read-en/dossier.yml" "$FIXTURE/.octon/instance/governance/support-dossiers/live/ci-observe-read-en/dossier.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-dossiers/stage-only/repo-shell-boundary-sensitive-en/dossier.yml" "$FIXTURE/.octon/instance/governance/support-dossiers/stage-only/repo-shell-boundary-sensitive-en/dossier.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-dossiers/stage-only/github-repo-consequential-en/dossier.yml" "$FIXTURE/.octon/instance/governance/support-dossiers/stage-only/github-repo-consequential-en/dossier.yml"
cp "$ROOT_DIR/.octon/instance/governance/support-dossiers/stage-only/frontier-studio-boundary-sensitive-es/dossier.yml" "$FIXTURE/.octon/instance/governance/support-dossiers/stage-only/frontier-studio-boundary-sensitive-es/dossier.yml"

yq -i '.packs[] |= (select(.pack_id == "repo").tuple_routes += [{"tuple_id":"tuple://bogus/live/widening","claim_effect":"admitted-live-claim","route":"allow","requires_mission":false}])' "$FIXTURE/.octon/generated/effective/capabilities/pack-routes.effective.yml"

if OCTON_DIR_OVERRIDE="$FIXTURE/.octon" OCTON_ROOT_DIR="$FIXTURE" bash "$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/validate-support-pack-admission-alignment.sh" >/dev/null 2>&1; then
  echo "expected support pack admission alignment validator to fail on widened pack route" >&2
  exit 1
fi
