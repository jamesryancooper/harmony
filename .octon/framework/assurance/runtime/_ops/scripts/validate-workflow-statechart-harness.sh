#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
EVIDENCE_ROOT=""

usage() {
  cat <<'EOF'
Usage: validate-workflow-statechart-harness.sh [--evidence-root <path>]

Validates Workflow Statechart v1 and Task-Specific Execution Harness v1
contracts, schema strength, Run Lifecycle v1 parity, placement boundaries,
negative fixtures, and generated projection non-authority.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --evidence-root)
      EVIDENCE_ROOT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[ERROR] unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

rel() {
  local path="$1"
  printf '%s\n' "${path#$ROOT_DIR/}"
}

require_tool() {
  if command -v "$1" >/dev/null 2>&1; then
    pass "$1 available"
  else
    fail "$1 is required"
  fi
}

require_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    pass "found $(rel "$file")"
  else
    fail "missing $(rel "$file")"
  fi
}

require_text() {
  local needle="$1"
  local file="$2"
  local label="$3"
  if rg -Fq -- "$needle" "$file"; then
    pass "$label"
  else
    fail "$label"
  fi
}

check_static_files() {
  echo "== Workflow Statechart Harness Static Contract Validation =="
  local files=(
    "$OCTON_DIR/framework/engine/runtime/spec/workflow-statechart-v1.md"
    "$OCTON_DIR/framework/engine/runtime/spec/task-specific-execution-harness-v1.md"
    "$OCTON_DIR/framework/engine/runtime/spec/workflow-statechart-v1.schema.json"
    "$OCTON_DIR/framework/engine/runtime/spec/task-specific-execution-harness-v1.schema.json"
    "$OCTON_DIR/framework/engine/runtime/spec/task-specific-execution-harness-compile-receipt-v1.schema.json"
    "$OCTON_DIR/framework/constitution/contracts/runtime/workflow-statechart-v1.schema.json"
    "$OCTON_DIR/framework/constitution/contracts/runtime/task-specific-execution-harness-v1.schema.json"
    "$OCTON_DIR/framework/constitution/contracts/runtime/task-specific-execution-harness-compile-receipt-v1.schema.json"
    "$OCTON_DIR/generated/cognition/projections/materialized/workflow-statechart-harness.yml"
  )
  local file
  for file in "${files[@]}"; do
    require_file "$file"
  done

  require_text "does not create a second control plane" "$OCTON_DIR/framework/engine/runtime/spec/workflow-statechart-v1.md" "statechart spec rejects second control plane"
  require_text "authorize material execution" "$OCTON_DIR/framework/engine/runtime/spec/task-specific-execution-harness-v1.md" "harness spec rejects authorization authority"
  require_text "generated_projection_is_authority" "$OCTON_DIR/framework/engine/runtime/spec/workflow-statechart-v1.schema.json" "statechart schema carries generated projection authority flag"
  require_text "proposal_lineage_is_authority" "$OCTON_DIR/framework/engine/runtime/spec/workflow-statechart-v1.schema.json" "statechart schema carries proposal lineage authority flag"
}

check_generated_projection() {
  echo "== Generated Projection Non-Authority Validation =="
  local projection="$OCTON_DIR/generated/cognition/projections/materialized/workflow-statechart-harness.yml"
  yq -e '.authority_status == "derived-only"' "$projection" >/dev/null 2>&1 \
    && pass "projection is derived-only" \
    || fail "projection must be derived-only"
  yq -e '.non_authority_notice != null' "$projection" >/dev/null 2>&1 \
    && pass "projection carries non-authority notice" \
    || fail "projection must carry non-authority notice"
  local missing_forbidden=0
  local projection_forbidden
  projection_forbidden="$(yq -r '.forbidden_consumers[]?' "$projection")"
  local forbidden
  for forbidden in runtime_authority policy_authority control_truth support_claim_authority closeout_evidence; do
    if ! grep -Fxq "$forbidden" <<<"$projection_forbidden"; then
      missing_forbidden=1
    fi
  done
  [[ "$missing_forbidden" == "0" ]] \
    && pass "projection forbids authority consumers" \
    || fail "projection must forbid authority consumers"
  if yq -r '.source_refs[]?' "$projection" | rg -n '(^|/)\.octon/inputs/' >/dev/null 2>&1; then
    fail "projection source refs must not cite raw input roots"
  else
    pass "projection source refs avoid raw input roots"
  fi
  yq -e '.files[] | select(.id == "workflow-statechart-harness" and .path == "workflow-statechart-harness.yml")' "$OCTON_DIR/generated/cognition/projections/materialized/index.yml" >/dev/null 2>&1 \
    && pass "projection index includes workflow-statechart-harness" \
    || fail "projection index must include workflow-statechart-harness"
}

check_family_registration() {
  echo "== Runtime Family Registration Validation =="
  local family="$OCTON_DIR/framework/constitution/contracts/runtime/family.yml"
  yq -e '.workflow_statechart_task_harness.workflow_statechart.schema_ref == ".octon/framework/constitution/contracts/runtime/workflow-statechart-v1.schema.json"' "$family" >/dev/null 2>&1 \
    && pass "runtime family registers workflow statechart schema" \
    || fail "runtime family must register workflow statechart schema"
  yq -e '.workflow_statechart_task_harness.task_specific_execution_harness.schema_ref == ".octon/framework/constitution/contracts/runtime/task-specific-execution-harness-v1.schema.json"' "$family" >/dev/null 2>&1 \
    && pass "runtime family registers task-specific harness schema" \
    || fail "runtime family must register task-specific harness schema"
  yq -e '.workflow_statechart_task_harness.generated_projection.authority_status == "derived-only"' "$family" >/dev/null 2>&1 \
    && pass "runtime family records generated projection as derived-only" \
    || fail "runtime family must record generated projection as derived-only"
}

check_schema_fixtures() {
  echo "== Schema Fixture And Negative Control Validation =="
  python3 - "$ROOT_DIR" "$EVIDENCE_ROOT" <<'PY'
import copy
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

import subprocess

ROOT_DIR = Path(sys.argv[1])
EVIDENCE_ROOT = Path(sys.argv[2]) if sys.argv[2] else None
OCTON_DIR = ROOT_DIR / ".octon"

EXPECTED_TRANSITIONS = {
    "draft": {"bound", "denied"},
    "bound": {"authorized", "staged", "denied"},
    "authorized": {"running", "staged", "revoked", "denied"},
    "running": {"paused", "failed", "revoked", "succeeded", "staged"},
    "paused": {"running", "revoked", "failed"},
    "staged": {"authorized", "revoked", "closed"},
    "revoked": {"rolled_back", "closed"},
    "failed": {"rolled_back", "closed"},
    "rolled_back": {"closed"},
    "succeeded": {"closed"},
    "denied": {"closed"},
    "closed": set(),
}

REQUIRED_BINDINGS = [
    "objective_binding",
    "run_contract_binding",
    "support_target_binding",
    "capability_envelope_binding",
    "context_pack_binding",
    "authorization_route_binding",
    "effect_token_class_binding",
    "evidence_obligation_binding",
    "rollback_or_compensation_binding",
    "human_intervention_binding",
    "model_cost_policy_binding",
    "closeout_criteria_binding",
]

def load_json(rel):
    return json.loads((ROOT_DIR / rel).read_text(encoding="utf-8"))

def load_yaml(rel):
    return json.loads(subprocess.check_output(["yq", "-o=json", ".", str(ROOT_DIR / rel)], text=True))

def fail(message):
    print(f"[ERROR] {message}")
    raise SystemExit(1)

def pass_msg(message):
    print(f"[OK] {message}")

def schema_has_required(schema, required_fields):
    missing = [field for field in required_fields if field not in schema.get("required", [])]
    return missing

def assert_schema_shape(schema, label, required_fields):
    for key in ("$schema", "$id", "title", "type", "required", "properties"):
        if key not in schema:
            fail(f"{label} missing schema key: {key}")
    if schema["$schema"] != "https://json-schema.org/draft/2020-12/schema":
        fail(f"{label} must declare Draft 2020-12")
    missing = schema_has_required(schema, required_fields)
    if missing:
        fail(f"{label} missing required declarations: {', '.join(missing)}")
    pass_msg(f"{label} has required schema shape")

def ref_is_runtime_authority_safe(ref):
    return isinstance(ref, str) and "/.octon/generated/" not in ref and "/.octon/inputs/" not in ref and not ref.startswith(".octon/generated/") and not ref.startswith(".octon/inputs/")

def validate_statechart(data):
    errors = []
    required = [
        "schema_version",
        "statechart_id",
        "canonical_lifecycle_ref",
        "control_root",
        "retained_evidence_root",
        "generated_projection_root",
        "states",
        "allowed_transitions",
        "invalid_transition_policy",
        "run_lifecycle_mapping",
        "authority_boundary",
    ]
    errors.extend([f"missing {key}" for key in required if key not in data])
    if errors:
        return errors
    if data["schema_version"] != "workflow-statechart-v1":
        errors.append("schema_version mismatch")
    if data["canonical_lifecycle_ref"] != ".octon/framework/engine/runtime/spec/run-lifecycle-v1.md":
        errors.append("canonical lifecycle ref mismatch")
    if data["control_root"] != ".octon/state/control/execution/runs":
        errors.append("control root mismatch")
    if data["retained_evidence_root"] != ".octon/state/evidence/runs":
        errors.append("retained evidence root mismatch")
    if data["generated_projection_root"] != ".octon/generated/cognition/projections/materialized":
        errors.append("generated projection root mismatch")
    if set(data["states"]) != set(EXPECTED_TRANSITIONS):
        errors.append("state set mismatch")
    declared = {key: set(value) for key, value in data["allowed_transitions"].items()}
    if declared != EXPECTED_TRANSITIONS:
        errors.append("transition matrix mismatch")
    if data["run_lifecycle_mapping"] != {key: key for key in EXPECTED_TRANSITIONS}:
        errors.append("run lifecycle mapping mismatch")
    policy = data["invalid_transition_policy"]
    if policy.get("decision") != "failed-closed" or policy.get("reason_code_pattern") != "^FCR-[0-9]{3}$" or policy.get("may_advance_lifecycle_state") is not False:
        errors.append("invalid transition policy mismatch")
    boundary = data["authority_boundary"]
    for key in (
        "creates_second_control_root",
        "authorizes_execution",
        "replaces_run_lifecycle",
        "generated_projection_is_authority",
        "proposal_lineage_is_authority",
    ):
        if boundary.get(key) is not False:
            errors.append(f"authority boundary must keep {key}=false")
    return errors

def validate_harness(data):
    errors = []
    required = [
        "schema_version",
        "harness_id",
        "run_id",
        "task_ref",
        "statechart_ref",
        "bindings",
        "control_refs",
        "retained_evidence_refs",
        "generated_projection_policy",
        "authority_boundary",
    ]
    errors.extend([f"missing {key}" for key in required if key not in data])
    if errors:
        return errors
    if data["schema_version"] != "task-specific-execution-harness-v1":
        errors.append("schema_version mismatch")
    if not ref_is_runtime_authority_safe(data["task_ref"]):
        errors.append("task_ref uses generated or input authority")
    if data["statechart_ref"] != ".octon/framework/engine/runtime/spec/workflow-statechart-v1.schema.json":
        errors.append("statechart_ref mismatch")
    bindings = data["bindings"]
    for field in REQUIRED_BINDINGS:
        binding = bindings.get(field)
        if not binding:
            errors.append(f"missing binding {field}")
            continue
        if not ref_is_runtime_authority_safe(binding.get("ref")):
            errors.append(f"{field} uses generated or input authority")
        if binding.get("source_class") not in {"framework_authority", "instance_authority", "state_control", "state_evidence"}:
            errors.append(f"{field} source_class invalid")
        if not binding.get("binding_role"):
            errors.append(f"{field} binding_role missing")
    if any(not str(ref).startswith(".octon/state/control/") for ref in data["control_refs"]):
        errors.append("control_refs must stay under state/control")
    if any(not str(ref).startswith(".octon/state/evidence/") for ref in data["retained_evidence_refs"]):
        errors.append("retained_evidence_refs must stay under state/evidence")
    if any(not str(ref).startswith(".octon/generated/cognition/projections/materialized/") for ref in data.get("generated_projection_refs", [])):
        errors.append("generated_projection_refs must stay under generated cognition projections")
    policy = data["generated_projection_policy"]
    if policy.get("authority_status") != "non_authoritative":
        errors.append("generated projection policy must be non_authoritative")
    for key in ("may_satisfy_runtime_authority", "may_satisfy_policy_authority", "may_satisfy_closeout_evidence"):
        if policy.get(key) is not False:
            errors.append(f"generated projection policy must keep {key}=false")
    boundary = data["authority_boundary"]
    for key in (
        "harness_authorizes_execution",
        "harness_mints_grants",
        "harness_consumes_effect_tokens",
        "harness_closes_runs",
        "harness_widens_support_claims",
    ):
        if boundary.get(key) is not False:
            errors.append(f"authority boundary must keep {key}=false")
    return errors

def validate_receipt(data):
    errors = []
    required = [
        "schema_version",
        "receipt_id",
        "harness_ref",
        "statechart_ref",
        "compiled_at",
        "compiler_ref",
        "validated_binding_fields",
        "validation_result",
        "authorization_boundary",
        "evidence_refs",
    ]
    errors.extend([f"missing {key}" for key in required if key not in data])
    if errors:
        return errors
    if data["schema_version"] != "task-specific-execution-harness-compile-receipt-v1":
        errors.append("schema_version mismatch")
    if not ref_is_runtime_authority_safe(data["harness_ref"]):
        errors.append("harness_ref uses generated or input authority")
    if data["statechart_ref"] != ".octon/framework/engine/runtime/spec/workflow-statechart-v1.schema.json":
        errors.append("statechart_ref mismatch")
    if set(data["validated_binding_fields"]) != set(REQUIRED_BINDINGS):
        errors.append("validated binding fields mismatch")
    result = data["validation_result"]
    if result.get("verdict") not in {"pass", "fail"}:
        errors.append("validation_result verdict invalid")
    boundary = data["authorization_boundary"]
    if boundary.get("compile_receipt_authorizes_execution") is not False:
        errors.append("compile receipt must not authorize execution")
    if boundary.get("execution_authorization_required") is not True:
        errors.append("execution authorization must remain required")
    if boundary.get("effect_token_verification_required") is not True:
        errors.append("effect token verification must remain required")
    if any(not str(ref).startswith(".octon/state/evidence/") for ref in data["evidence_refs"]):
        errors.append("receipt evidence refs must stay under state/evidence")
    return errors

def expect_valid(errors, label):
    if errors:
        fail(f"{label} failed validation: {'; '.join(errors)}")
    pass_msg(f"{label} validates")

def expect_invalid(errors, label):
    if not errors:
        fail(f"{label} unexpectedly validated")
    pass_msg(f"{label} is rejected")

statechart_schema = load_json(".octon/framework/engine/runtime/spec/workflow-statechart-v1.schema.json")
harness_schema = load_json(".octon/framework/engine/runtime/spec/task-specific-execution-harness-v1.schema.json")
receipt_schema = load_json(".octon/framework/engine/runtime/spec/task-specific-execution-harness-compile-receipt-v1.schema.json")

assert_schema_shape(
    statechart_schema,
    "workflow statechart runtime schema",
    ["schema_version", "statechart_id", "canonical_lifecycle_ref", "states", "allowed_transitions", "authority_boundary"],
)
assert_schema_shape(
    harness_schema,
    "task-specific harness runtime schema",
    ["schema_version", "harness_id", "run_id", "statechart_ref", "bindings", "control_refs", "retained_evidence_refs", "generated_projection_policy", "authority_boundary"],
)
assert_schema_shape(
    receipt_schema,
    "task-specific harness compile receipt runtime schema",
    ["schema_version", "receipt_id", "harness_ref", "statechart_ref", "validated_binding_fields", "validation_result", "authorization_boundary", "evidence_refs"],
)

mirror_expectations = {
    ".octon/framework/constitution/contracts/runtime/workflow-statechart-v1.schema.json": "../../../engine/runtime/spec/workflow-statechart-v1.schema.json",
    ".octon/framework/constitution/contracts/runtime/task-specific-execution-harness-v1.schema.json": "../../../engine/runtime/spec/task-specific-execution-harness-v1.schema.json",
    ".octon/framework/constitution/contracts/runtime/task-specific-execution-harness-compile-receipt-v1.schema.json": "../../../engine/runtime/spec/task-specific-execution-harness-compile-receipt-v1.schema.json",
}
for rel, expected_ref in mirror_expectations.items():
    mirror = load_json(rel)
    refs = [item.get("$ref") for item in mirror.get("allOf", [])]
    if expected_ref not in refs:
        fail(f"{rel} must mirror {expected_ref}")
    pass_msg(f"{rel} mirrors runtime schema")

statechart = {
    "schema_version": "workflow-statechart-v1",
    "statechart_id": "default-run-lifecycle-overlay",
    "canonical_lifecycle_ref": ".octon/framework/engine/runtime/spec/run-lifecycle-v1.md",
    "control_root": ".octon/state/control/execution/runs",
    "retained_evidence_root": ".octon/state/evidence/runs",
    "generated_projection_root": ".octon/generated/cognition/projections/materialized",
    "states": list(EXPECTED_TRANSITIONS.keys()),
    "allowed_transitions": {key: sorted(value) for key, value in EXPECTED_TRANSITIONS.items()},
    "invalid_transition_policy": {
        "decision": "failed-closed",
        "reason_code_pattern": "^FCR-[0-9]{3}$",
        "may_advance_lifecycle_state": False,
    },
    "run_lifecycle_mapping": {key: key for key in EXPECTED_TRANSITIONS},
    "authority_boundary": {
        "creates_second_control_root": False,
        "authorizes_execution": False,
        "replaces_run_lifecycle": False,
        "generated_projection_is_authority": False,
        "proposal_lineage_is_authority": False,
    },
}
expect_valid(validate_statechart(statechart), "positive statechart fixture")

if {key: set(value) for key, value in statechart["allowed_transitions"].items()} != EXPECTED_TRANSITIONS:
    fail("statechart transition matrix does not match Run Lifecycle v1")
pass_msg("statechart transition matrix matches Run Lifecycle v1")

bad_transition = copy.deepcopy(statechart)
bad_transition["allowed_transitions"]["closed"] = ["running"]
expect_invalid(validate_statechart(bad_transition), "invalid transition negative fixture")

def binding(ref, source_class, role):
    return {"ref": ref, "source_class": source_class, "binding_role": role}

harness = {
    "schema_version": "task-specific-execution-harness-v1",
    "harness_id": "repo-change-validation-harness",
    "run_id": "run-workflow-statechart-fixture",
    "task_ref": ".octon/framework/orchestration/runtime/workflows/tasks/repo-consequential-preflight/workflow.yml",
    "statechart_ref": ".octon/framework/engine/runtime/spec/workflow-statechart-v1.schema.json",
    "bindings": {
        "objective_binding": binding(".octon/instance/charter/workspace.yml", "instance_authority", "workspace_objective"),
        "run_contract_binding": binding(".octon/state/control/execution/runs/run-workflow-statechart-fixture/run-contract.yml", "state_control", "run_contract"),
        "support_target_binding": binding(".octon/instance/governance/support-targets.yml", "instance_authority", "support_target"),
        "capability_envelope_binding": binding(".octon/framework/capabilities/packs/registry.yml", "framework_authority", "capability_envelope"),
        "context_pack_binding": binding(".octon/state/evidence/runs/run-workflow-statechart-fixture/context/context-pack-receipt.json", "state_evidence", "context_pack"),
        "authorization_route_binding": binding(".octon/framework/engine/runtime/spec/execution-authorization-v1.md", "framework_authority", "authorization_route"),
        "effect_token_class_binding": binding(".octon/framework/engine/runtime/spec/authorized-effect-token-v1.md", "framework_authority", "effect_token_classes"),
        "evidence_obligation_binding": binding(".octon/framework/constitution/obligations/evidence.yml", "framework_authority", "evidence_obligations"),
        "rollback_or_compensation_binding": binding(".octon/state/control/execution/runs/run-workflow-statechart-fixture/rollback-posture.yml", "state_control", "rollback_or_compensation"),
        "human_intervention_binding": binding(".octon/framework/constitution/ownership/roles.yml", "framework_authority", "human_intervention"),
        "model_cost_policy_binding": binding(".octon/framework/engine/runtime/spec/policy-interface-v1.md", "framework_authority", "model_cost_policy"),
        "closeout_criteria_binding": binding(".octon/framework/product/contracts/default-work-unit.yml", "framework_authority", "closeout_criteria"),
    },
    "control_refs": [
        ".octon/state/control/execution/runs/run-workflow-statechart-fixture/run-contract.yml",
        ".octon/state/control/execution/runs/run-workflow-statechart-fixture/runtime-state.yml",
    ],
    "retained_evidence_refs": [
        ".octon/state/evidence/runs/run-workflow-statechart-fixture/context/context-pack-receipt.json",
        ".octon/state/evidence/runs/run-workflow-statechart-fixture/receipts/authorization.yml",
    ],
    "generated_projection_refs": [
        ".octon/generated/cognition/projections/materialized/workflow-statechart-harness.yml"
    ],
    "generated_projection_policy": {
        "authority_status": "non_authoritative",
        "may_satisfy_runtime_authority": False,
        "may_satisfy_policy_authority": False,
        "may_satisfy_closeout_evidence": False,
    },
    "authority_boundary": {
        "harness_authorizes_execution": False,
        "harness_mints_grants": False,
        "harness_consumes_effect_tokens": False,
        "harness_closes_runs": False,
        "harness_widens_support_claims": False,
    },
}
expect_valid(validate_harness(harness), "positive harness fixture")

for field in REQUIRED_BINDINGS:
    negative = copy.deepcopy(harness)
    del negative["bindings"][field]
    if not validate_harness(negative):
        fail(f"missing required harness binding was accepted: {field}")
pass_msg("missing harness binding negative fixtures are rejected")

generated_authority = copy.deepcopy(harness)
generated_authority["bindings"]["run_contract_binding"]["ref"] = ".octon/generated/cognition/projections/materialized/runs/example.yml"
expect_invalid(validate_harness(generated_authority), "generated projection used as binding authority")

raw_input_authority = copy.deepcopy(harness)
raw_input_authority["bindings"]["objective_binding"]["ref"] = ".octon/inputs/example.yml"
expect_invalid(validate_harness(raw_input_authority), "raw input used as binding authority")

receipt = {
    "schema_version": "task-specific-execution-harness-compile-receipt-v1",
    "receipt_id": "harness-compile-receipt-fixture",
    "harness_ref": ".octon/state/evidence/runs/run-workflow-statechart-fixture/harness/harness.yml",
    "statechart_ref": ".octon/framework/engine/runtime/spec/workflow-statechart-v1.schema.json",
    "compiled_at": "2026-05-15T00:49:28Z",
    "compiler_ref": ".octon/framework/assurance/runtime/_ops/scripts/validate-workflow-statechart-harness.sh",
    "validated_binding_fields": REQUIRED_BINDINGS,
    "validation_result": {
        "verdict": "pass",
        "missing_required_bindings": [],
        "generated_projection_authority_violations": [],
        "proposal_authority_violations": [],
    },
    "authorization_boundary": {
        "compile_receipt_authorizes_execution": False,
        "execution_authorization_required": True,
        "effect_token_verification_required": True,
    },
    "evidence_refs": [
        ".octon/state/evidence/validation/workflow-statechart-harness/fixture.yml"
    ],
}
expect_valid(validate_receipt(receipt), "positive harness compile receipt fixture")

receipt_negative = copy.deepcopy(receipt)
receipt_negative["harness_ref"] = ".octon/generated/cognition/projections/materialized/workflow-statechart-harness.yml"
expect_invalid(validate_receipt(receipt_negative), "generated projection used as compile receipt harness ref")

projection = load_yaml(".octon/generated/cognition/projections/materialized/workflow-statechart-harness.yml")
if projection.get("authority_status") != "derived-only":
    fail("projection authority_status must be derived-only")
if any(ref.startswith(".octon/inputs/") for ref in projection.get("source_refs", [])):
    fail("projection must not source from raw input roots")
pass_msg("projection source and authority posture validated")

if EVIDENCE_ROOT:
    EVIDENCE_ROOT.mkdir(parents=True, exist_ok=True)
    validated_at = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
    report = f"""schema_version: workflow-statechart-harness-validator-evidence-v1
validated_at: {validated_at}
validator_ref: .octon/framework/assurance/runtime/_ops/scripts/validate-workflow-statechart-harness.sh
verdict: pass
positive_fixtures:
  - workflow-statechart-v1
  - task-specific-execution-harness-v1
  - task-specific-execution-harness-compile-receipt-v1
negative_fixtures:
  - invalid-transition-matrix
  - missing-required-harness-bindings
  - generated-projection-binding-authority
  - raw-input-binding-authority
  - generated-projection-compile-receipt-authority
run_lifecycle_parity_ref: .octon/framework/engine/runtime/spec/run-lifecycle-v1.md
generated_projection_ref: .octon/generated/cognition/projections/materialized/workflow-statechart-harness.yml
"""
    (EVIDENCE_ROOT / "child-specific-validator.yml").write_text(report, encoding="utf-8")
    pass_msg(f"retained validator evidence written to {EVIDENCE_ROOT / 'child-specific-validator.yml'}")
PY
}

main() {
  require_tool rg
  require_tool jq
  require_tool yq
  require_tool python3
  check_static_files
  check_generated_projection
  check_family_registration
  check_schema_fixtures
  echo "Validation summary: errors=$errors"
  [[ "$errors" -eq 0 ]]
}

main "$@"
