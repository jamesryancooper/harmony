#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
ROOT_DIR="$(cd -- "$DEFAULT_OCTON_DIR/.." && pwd)"
SEED_SCRIPT="$ROOT_DIR/.octon/framework/orchestration/runtime/_ops/scripts/seed-mission-autonomy-state.sh"
CLOSE_SCRIPT="$ROOT_DIR/.octon/framework/orchestration/runtime/_ops/scripts/close-mission-autonomy-state.sh"

fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

mkdir -p "$fixture_root/.octon/instance/orchestration/missions/demo"
mkdir -p "$fixture_root/.octon/instance/governance/policies"
mkdir -p "$fixture_root/.octon/state/evidence/control/execution"

cat > "$fixture_root/.octon/instance/orchestration/missions/demo/mission.yml" <<'EOF'
schema_version: "octon-mission-v2"
mission_id: "demo"
title: "Demo Mission"
summary: "Fixture"
status: "active"
mission_class: "maintenance"
owner_ref: "operator://demo-owner"
created_at: "2026-03-23"
risk_ceiling: "ACP-2"
allowed_action_classes:
  - "repo-maintenance"
default_safing_subset:
  - "observe_only"
  - "stage_only"
default_schedule_hint: "interruptible_scheduled"
default_overlap_policy: "skip"
scope_ids: []
success_criteria:
  - "done"
failure_conditions: []
EOF

cat > "$fixture_root/.octon/instance/governance/policies/mission-autonomy.yml" <<'EOF'
schema_version: "mission-autonomy-policy-v1"
mode_defaults:
  maintenance: "notify"
execution_postures:
  maintenance: "interruptible_scheduled"
overlap_defaults:
  maintenance: "skip"
backfill_defaults:
  maintenance: "latest_only"
pause_on_failure:
  default_triggers:
    - "breaker_trip"
preview_defaults: {}
digest_cadence_defaults: {}
ownership_routing: {}
recovery_windows: {}
proceed_on_silence: {}
safe_interrupt_boundaries: {}
autonomy_burn: {}
circuit_breakers: {}
quorum: {}
safing_defaults: {}
EOF

OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" bash "$SEED_SCRIPT" --mission-id demo --issued-by operator://seed-tester

test -f "$fixture_root/.octon/state/control/execution/missions/demo/lease.yml"
test -f "$fixture_root/.octon/state/control/execution/missions/demo/mode-state.yml"
test -f "$fixture_root/.octon/state/control/execution/missions/demo/intent-register.yml"
test -f "$fixture_root/.octon/state/control/execution/missions/demo/directives.yml"
test -f "$fixture_root/.octon/state/control/execution/missions/demo/schedule.yml"
test -f "$fixture_root/.octon/state/control/execution/missions/demo/autonomy-budget.yml"
test -f "$fixture_root/.octon/state/control/execution/missions/demo/circuit-breakers.yml"
test -f "$fixture_root/.octon/state/control/execution/missions/demo/subscriptions.yml"
test -f "$fixture_root/.octon/state/continuity/repo/missions/demo/next-actions.yml"
test -f "$fixture_root/.octon/state/continuity/repo/missions/demo/handoff.md"
find "$fixture_root/.octon/state/evidence/control/execution" -type f -name '*.yml' | grep -q .

OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" bash "$CLOSE_SCRIPT" --mission-id demo --issued-by operator://close-tester --final-status completed

grep -q 'status: "revoked"' "$fixture_root/.octon/state/control/execution/missions/demo/lease.yml"
grep -q 'phase: "closed"' "$fixture_root/.octon/state/control/execution/missions/demo/mode-state.yml"
