#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
ROOT_DIR="$(cd -- "$OCTON_DIR/.." && pwd)"

POLICY="$OCTON_DIR/framework/product/contracts/default-work-unit.yml"
POLICY_MD="$OCTON_DIR/framework/product/contracts/default-work-unit.md"
RECEIPT_SCHEMA="$OCTON_DIR/framework/product/contracts/change-receipt-v1.schema.json"
CLOSEOUT_CHANGE="$OCTON_DIR/framework/capabilities/runtime/skills/remediation/closeout-change/SKILL.md"
CLOSEOUT_PR="$OCTON_DIR/framework/capabilities/runtime/skills/remediation/closeout-pr/SKILL.md"
WORKFLOW_STAGE="$OCTON_DIR/framework/orchestration/runtime/workflows/meta/closeout/stages/02-request-or-report.md"
WORKTREE_CONTRACT="$OCTON_DIR/framework/execution-roles/practices/standards/git-worktree-autonomy-contract.yml"
BRANCH_COMMIT_SCRIPT="$OCTON_DIR/framework/execution-roles/_ops/scripts/git/git-branch-commit.sh"
BRANCH_PUSH_SCRIPT="$OCTON_DIR/framework/execution-roles/_ops/scripts/git/git-branch-push.sh"
BRANCH_LAND_SCRIPT="$OCTON_DIR/framework/execution-roles/_ops/scripts/git/git-branch-land.sh"
BRANCH_CLEANUP_SCRIPT="$OCTON_DIR/framework/execution-roles/_ops/scripts/git/git-branch-cleanup.sh"

RECEIPT_PATH=""
errors=0

usage() {
  cat <<'USAGE'
usage:
  validate-change-closeout-lifecycle-alignment.sh [--receipt <path>]

Without --receipt, validates policy/workflow/schema/helper alignment.
With --receipt, also validates route/lifecycle semantic claims in the receipt.
USAGE
}

pass() { echo "[OK] $1"; }
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }

require_file() {
  local file="$1"
  [[ -f "$file" ]] && pass "found ${file#$ROOT_DIR/}" || fail "missing ${file#$ROOT_DIR/}"
}

require_literal() {
  local file="$1"
  local needle="$2"
  local ok_msg="$3"
  local fail_msg="$4"
  grep -Fq -- "$needle" "$file" && pass "$ok_msg" || fail "$fail_msg"
}

require_yq() {
  local file="$1"
  local expr="$2"
  local ok_msg="$3"
  local fail_msg="$4"
  yq -e "$expr" "$file" >/dev/null 2>&1 && pass "$ok_msg" || fail "$fail_msg"
}

require_jq() {
  local file="$1"
  local expr="$2"
  local ok_msg="$3"
  local fail_msg="$4"
  jq -e "$expr" "$file" >/dev/null 2>&1 && pass "$ok_msg" || fail "$fail_msg"
}

json_value() {
  local expr="$1"
  jq -r "$expr // \"\"" "$RECEIPT_PATH"
}

json_has_nonempty() {
  local expr="$1"
  jq -e "$expr | type == \"string\" and length > 0" "$RECEIPT_PATH" >/dev/null 2>&1
}

json_array_nonempty() {
  local expr="$1"
  jq -e "$expr | type == \"array\" and length > 0" "$RECEIPT_PATH" >/dev/null 2>&1
}

validate_contracts() {
  for file in "$POLICY" "$POLICY_MD" "$RECEIPT_SCHEMA" "$CLOSEOUT_CHANGE" "$CLOSEOUT_PR" "$WORKFLOW_STAGE" "$WORKTREE_CONTRACT" "$BRANCH_COMMIT_SCRIPT" "$BRANCH_PUSH_SCRIPT" "$BRANCH_LAND_SCRIPT" "$BRANCH_CLEANUP_SCRIPT"; do
    require_file "$file"
  done

  for route in direct-main branch-no-pr branch-pr stage-only-escalate; do
    require_yq "$POLICY" ".routes[]? | select(.route_id == \"$route\")" "policy exposes route $route" "policy missing route $route"
  done
  if yq -e '.routes[]? | select(.route_id == "branch-land-no-pr")' "$POLICY" >/dev/null 2>&1; then
    fail "branch-land-no-pr must not be a top-level route"
  else
    pass "branch landing without PR remains a branch-no-pr lifecycle outcome"
  fi

  for outcome in preserved branch-local-complete published-branch published ready landed cleaned blocked escalated denied; do
    require_jq "$RECEIPT_SCHEMA" ".properties.lifecycle_outcome.enum[] | select(. == \"$outcome\")" "receipt schema accepts outcome $outcome" "receipt schema missing outcome $outcome"
  done
  for field in lifecycle_outcome integration_status publication_status cleanup_status; do
    require_jq "$RECEIPT_SCHEMA" ".required[] | select(. == \"$field\")" "receipt schema requires $field" "receipt schema missing required $field"
  done

  require_yq "$POLICY" '.route_lifecycle_outcomes."branch-no-pr".allowed_outcomes[]? | select(. == "landed")' "branch-no-pr supports landed lifecycle outcome" "branch-no-pr must support landed lifecycle outcome"
  require_yq "$POLICY" '.route_lifecycle_outcomes."branch-pr".allowed_outcomes[]? | select(. == "ready")' "branch-pr supports ready lifecycle outcome" "branch-pr must support ready lifecycle outcome"
  require_literal "$POLICY_MD" "Routes do not by themselves prove landing, publication, or cleanup." "policy docs separate route from outcome" "policy docs must separate route from outcome"
  require_literal "$CLOSEOUT_CHANGE" 'Do not claim `branch-no-pr` as `landed`' "closeout-change blocks false no-PR landing claims" "closeout-change must block false no-PR landing claims"
  require_literal "$CLOSEOUT_PR" 'Draft/open PR state is `published`, not full closeout' "closeout-pr blocks draft/open full closeout claims" "closeout-pr must block draft/open full closeout claims"
  require_literal "$WORKFLOW_STAGE" "Never report a patch, checkpoint, or branch-local commit as landed." "workflow blocks false landed claims" "workflow must block false landed claims"
  require_yq "$WORKTREE_CONTRACT" '.helpers.git_branch_land.route_guard == "branch-no-pr only"' "branch landing helper is route guarded" "branch landing helper must be route guarded"
}

validate_receipt() {
  [[ -f "$RECEIPT_PATH" ]] || { fail "receipt exists: $RECEIPT_PATH"; return; }
  jq -e '.' "$RECEIPT_PATH" >/dev/null 2>&1 && pass "receipt parses as JSON" || { fail "receipt parses as JSON"; return; }

  local route outcome integration publication cleanup durable_kind closeout_outcome
  route="$(json_value '.selected_route')"
  outcome="$(json_value '.lifecycle_outcome')"
  integration="$(json_value '.integration_status')"
  publication="$(json_value '.publication_status')"
  cleanup="$(json_value '.cleanup_status')"
  durable_kind="$(json_value '.durable_history.kind')"
  closeout_outcome="$(json_value '.closeout_outcome')"

  [[ -n "$route" ]] && pass "receipt has selected route" || fail "receipt missing selected route"
  [[ -n "$outcome" ]] && pass "receipt has lifecycle outcome" || fail "receipt missing lifecycle outcome"
  [[ -n "$integration" ]] && pass "receipt has integration status" || fail "receipt missing integration status"
  [[ -n "$publication" ]] && pass "receipt has publication status" || fail "receipt missing publication status"
  [[ -n "$cleanup" ]] && pass "receipt has cleanup status" || fail "receipt missing cleanup status"

  case "$route" in
    direct-main)
      case "$outcome" in
        landed|cleaned) pass "direct-main outcome is landing-scoped" ;;
        *) fail "direct-main outcome must be landed or cleaned" ;;
      esac
      ;;
    branch-no-pr)
      case "$outcome" in
        preserved|branch-local-complete|published-branch|landed|cleaned|blocked|escalated|denied)
          pass "branch-no-pr outcome is branch-only scoped"
          ;;
        *)
          fail "branch-no-pr outcome must not use PR lifecycle states"
          ;;
      esac
      ;;
    branch-pr)
      case "$outcome" in
        preserved|published|ready|landed|cleaned|blocked|escalated|denied)
          pass "branch-pr outcome is PR-route scoped"
          ;;
        *)
          fail "branch-pr outcome must not use branch-only lifecycle states"
          ;;
      esac
      ;;
    stage-only-escalate)
      case "$outcome" in
        preserved|blocked|escalated|denied) pass "stage-only outcome is preservation or blocker scoped" ;;
        *) fail "stage-only-escalate outcome must not claim completion lifecycle states" ;;
      esac
      ;;
  esac

  if [[ "$route" == "branch-no-pr" ]]; then
    if jq -e '(.durable_history.kind == "pr") or (.durable_history.pr_url? // "" | length > 0) or (.pr_url? // "" | length > 0) or (.pr_number? // "" | tostring | length > 0)' "$RECEIPT_PATH" >/dev/null; then
      fail "branch-no-pr receipt must not include PR metadata"
    else
      pass "branch-no-pr receipt has no PR metadata"
    fi
    if [[ "$publication" == pr-* ]]; then
      fail "branch-no-pr receipt must not use PR publication status"
    else
      pass "branch-no-pr receipt avoids PR publication status"
    fi
    if [[ "$outcome" == "branch-local-complete" ]]; then
      [[ "$integration" != "landed" ]] && pass "branch-local-complete is not landed" || fail "branch-local-complete must not claim landed integration"
      [[ "$durable_kind" == "commit" ]] && pass "branch-local-complete has branch commit evidence" || fail "branch-local-complete requires commit durable history"
    fi
    if [[ "$outcome" == "published-branch" ]]; then
      [[ "$publication" == "pushed-branch" ]] && pass "published-branch has pushed branch publication status" || fail "published-branch requires pushed-branch publication status"
      json_has_nonempty '.remote_branch_ref' && pass "published-branch has remote branch ref" || fail "published-branch requires remote_branch_ref"
    fi
  fi

  if [[ "$outcome" == "preserved" && "$integration" == "landed" ]]; then
    fail "preserved outcome must not claim landed integration"
  elif [[ "$outcome" == "preserved" ]]; then
    pass "preserved outcome does not claim landed integration"
  fi

  if [[ "$integration" == "landed" || "$outcome" == "landed" || "$outcome" == "cleaned" ]]; then
    json_has_nonempty '.landed_ref' && pass "landed claim has landed ref" || fail "landed claim requires landed_ref"
    json_has_nonempty '.target_branch_ref' && pass "landed claim has target branch ref" || fail "landed claim requires target_branch_ref"
    json_has_nonempty '.rollback_handle.ref' && pass "landed claim has rollback handle" || fail "landed claim requires rollback handle"
    json_array_nonempty '.validation_evidence_refs' && pass "landed claim has validation evidence" || fail "landed claim requires validation evidence"
    if [[ "$durable_kind" == "patch" || "$durable_kind" == "checkpoint" ]]; then
      fail "patch or checkpoint durable history cannot claim landed"
    else
      pass "landed claim uses commit, branch, or PR durable history"
    fi
  fi

  if [[ "$route" == "branch-pr" ]]; then
    if [[ "$outcome" == "preserved" ]]; then
      [[ "$publication" == "none" ]] && pass "branch-pr preserved has no PR publication" || fail "branch-pr preserved must not claim PR publication"
    fi
    if [[ "$outcome" == "published" ]]; then
      [[ "$publication" == "pr-opened" ]] && pass "branch-pr published has opened PR status" || fail "branch-pr published requires pr-opened publication status"
      [[ "$durable_kind" == "pr" ]] && pass "branch-pr published uses PR durable history" || fail "branch-pr published requires PR durable history"
      json_has_nonempty '.durable_history.pr_url' && pass "branch-pr published has PR URL" || fail "branch-pr published requires PR URL"
    fi
    if [[ "$outcome" == "ready" ]]; then
      [[ "$publication" == "pr-ready" ]] && pass "branch-pr ready has ready PR status" || fail "branch-pr ready requires pr-ready publication status"
      [[ "$durable_kind" == "pr" ]] && pass "branch-pr ready uses PR durable history" || fail "branch-pr ready requires PR durable history"
      json_has_nonempty '.durable_history.pr_url' && pass "branch-pr ready has PR URL" || fail "branch-pr ready requires PR URL"
    fi
    if [[ "$closeout_outcome" == "completed" && ( "$outcome" == "published" || "$outcome" == "ready" || "$publication" == "pr-opened" || "$publication" == "pr-ready" ) ]]; then
      fail "branch-pr cannot claim full closeout from draft/open/ready PR state"
    else
      pass "branch-pr full closeout is not based only on draft/open/ready state"
    fi
    if [[ "$outcome" == "landed" || "$outcome" == "cleaned" ]]; then
      [[ "$publication" == "pr-merged" ]] && pass "PR landed claim has merged publication status" || fail "PR landed claim requires pr-merged publication status"
      json_has_nonempty '.durable_history.pr_url' && pass "PR landed claim has PR URL" || fail "PR landed claim requires PR URL"
    fi
  fi

  if [[ "$cleanup" == "completed" ]]; then
    json_array_nonempty '.cleanup_evidence_refs' && pass "completed cleanup has evidence refs" || fail "completed cleanup requires cleanup_evidence_refs"
  elif [[ "$cleanup" == "deferred" ]]; then
    if json_array_nonempty '.cleanup_evidence_refs' || json_array_nonempty '.external_blocker_refs'; then
      pass "deferred cleanup has evidence or blocker refs"
    else
      fail "deferred cleanup requires cleanup evidence or external blocker refs"
    fi
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --receipt)
      shift
      [[ $# -gt 0 ]] || { usage >&2; exit 2; }
      RECEIPT_PATH="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ -n "$RECEIPT_PATH" && "$RECEIPT_PATH" != /* ]]; then
  RECEIPT_PATH="$ROOT_DIR/$RECEIPT_PATH"
fi

command -v jq >/dev/null 2>&1 || { echo "[ERROR] jq is required" >&2; exit 1; }
command -v yq >/dev/null 2>&1 || { echo "[ERROR] yq is required" >&2; exit 1; }

echo "== Change Closeout Lifecycle Alignment Validation =="
validate_contracts
[[ -z "$RECEIPT_PATH" ]] || validate_receipt

echo
echo "Validation summary: errors=$errors"
[[ "$errors" -eq 0 ]]
