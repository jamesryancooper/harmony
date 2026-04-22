#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"

require_yq

OUT_DIR="$OCTON_DIR/generated/cognition/projections/materialized"
RUNTIME_BUNDLE="$OCTON_DIR/generated/effective/runtime/route-bundle.yml"
RUNTIME_LOCK="$OCTON_DIR/generated/effective/runtime/route-bundle.lock.yml"
PACK_ROUTES="$OCTON_DIR/generated/effective/capabilities/pack-routes.effective.yml"
PACK_LOCK="$OCTON_DIR/generated/effective/capabilities/pack-routes.lock.yml"
EVIDENCE_ROOT="$OCTON_DIR/state/evidence/validation/architecture/10of10-target-transition/operator-views"
mkdir -p "$OUT_DIR" "$EVIDENCE_ROOT"

generated_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

cat >"$OUT_DIR/runtime-route-map.md" <<EOF
# Runtime Route Map

Generated at: \`$generated_at\`

Non-authority disclaimer: this map is derived from canonical authored authority, retained evidence, and freshness-gated generated/effective outputs. It does not mint authority.

Source refs:

- \`/.octon/framework/engine/runtime/spec/runtime-resolution-v1.md\`
- \`/.octon/instance/governance/runtime-resolution.yml\`
- \`/.octon/generated/effective/runtime/route-bundle.yml\`
- \`/.octon/generated/effective/runtime/route-bundle.lock.yml\`
- \`/.octon/state/evidence/validation/architecture/10of10-target-transition/publication/freshness.yml\`

Route bundle generation: \`$(yq -r '.generation_id // ""' "$RUNTIME_BUNDLE")\`
Publication receipt: \`$(yq -r '.publication_receipt_path // ""' "$RUNTIME_LOCK")\`
Freshness mode: \`$(yq -r '.freshness.mode // ""' "$RUNTIME_LOCK")\`
Validator refs:

- \`/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-route-bundle.sh\`
- \`/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-artifact-handles.sh\`
- \`/.octon/framework/assurance/runtime/_ops/scripts/validate-no-raw-generated-effective-runtime-reads.sh\`

Runtime consumers: \`runtime_resolver\`, \`validators\`
Forbidden consumers: \`direct_runtime_raw_path_read\`, \`generated_cognition_as_authority\`

## Tuple Routes
EOF

while IFS=$'\t' read -r tuple_id claim_effect route; do
  [[ -n "$tuple_id" ]] || continue
  {
    echo "- \`$tuple_id\`: \`$claim_effect\`, route=\`$route\`"
  } >>"$OUT_DIR/runtime-route-map.md"
done < <(yq -r '.routes[]? | [.tuple_id, .claim_effect, .route] | @tsv' "$RUNTIME_BUNDLE")

cat >"$OUT_DIR/support-pack-route-map.md" <<EOF
# Support Pack Route Map

Generated at: \`$generated_at\`

Non-authority disclaimer: this derived read model traces support tuples, pack routes, and retained receipts. Canonical authority remains in \`framework/**\`, \`instance/**\`, \`state/**\`, and freshness-gated generated/effective outputs.

Source refs:

- \`/.octon/framework/engine/runtime/spec/runtime-resolution-v1.md\`
- \`/.octon/instance/governance/support-targets.yml\`
- \`/.octon/generated/effective/capabilities/pack-routes.effective.yml\`
- \`/.octon/generated/effective/capabilities/pack-routes.lock.yml\`
- \`/.octon/state/evidence/validation/architecture/10of10-target-transition/capabilities/pack-route-no-widening.yml\`

## Pack Routes
Publication receipt: \`$(yq -r '.publication_receipt_path // ""' "$PACK_LOCK")\`
Freshness mode: \`$(yq -r '.freshness.mode // ""' "$PACK_LOCK")\`
Validator refs:

- \`/.octon/framework/assurance/runtime/_ops/scripts/validate-support-pack-admission-alignment.sh\`
- \`/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-artifact-handles.sh\`

Runtime consumers: \`runtime_resolver\`, \`validators\`
Forbidden consumers: \`direct_runtime_raw_path_read\`, \`generated_cognition_as_authority\`
EOF

while IFS=$'\t' read -r pack_id status; do
  [[ -n "$pack_id" ]] || continue
  {
    echo "- \`$pack_id\`: status=\`$status\`"
    while IFS=$'\t' read -r tuple_id claim_effect route; do
      [[ -n "$tuple_id" ]] || continue
      echo "  - \`$tuple_id\`: \`$claim_effect\`, route=\`$route\`"
    done < <(yq -r ".packs[] | select(.pack_id == \"$pack_id\") | .tuple_routes[]? | [.tuple_id, .claim_effect, .route] | @tsv" "$PACK_ROUTES")
  } >>"$OUT_DIR/support-pack-route-map.md"
done < <(yq -r '.packs[]? | [.pack_id, .admission_status] | @tsv' "$PACK_ROUTES")

cat >"$EVIDENCE_ROOT/generation.yml" <<EOF
schema_version: "operator-read-model-publication-v1"
generated_at: "$generated_at"
view_contract_ref: ".octon/framework/engine/runtime/spec/operator-read-models-v1.md"
published_views:
  - view_kind: "runtime-route"
    projection_ref: ".octon/generated/cognition/projections/materialized/runtime-route-map.md"
    summary_ref: ".octon/generated/effective/runtime/route-bundle.yml"
    publication_receipt_ref: "$(yq -r '.publication_receipt_path // ""' "$RUNTIME_LOCK")"
    freshness_mode: "$(yq -r '.freshness.mode // ""' "$RUNTIME_LOCK")"
    validator_ref: ".octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-route-bundle.sh"
    runtime_consumers:
      - "runtime_resolver"
      - "validators"
    forbidden_consumers:
      - "direct_runtime_raw_path_read"
      - "generated_cognition_as_authority"
  - view_kind: "support-pack-route"
    projection_ref: ".octon/generated/cognition/projections/materialized/support-pack-route-map.md"
    summary_ref: ".octon/generated/effective/capabilities/pack-routes.effective.yml"
    publication_receipt_ref: "$(yq -r '.publication_receipt_path // ""' "$PACK_LOCK")"
    freshness_mode: "$(yq -r '.freshness.mode // ""' "$PACK_LOCK")"
    validator_ref: ".octon/framework/assurance/runtime/_ops/scripts/validate-support-pack-admission-alignment.sh"
    runtime_consumers:
      - "runtime_resolver"
      - "validators"
    forbidden_consumers:
      - "direct_runtime_raw_path_read"
      - "generated_cognition_as_authority"
  - view_kind: "architecture"
    projection_ref: ".octon/generated/cognition/projections/materialized/architecture-map.md"
    summary_ref: ".octon/state/evidence/validation/architecture/10of10-target-transition/manifest.yml"
    publication_receipt_ref: ".octon/state/evidence/validation/architecture/10of10-target-transition/operator-views/generation.yml"
    freshness_mode: "receipt_bound"
    validator_ref: ".octon/framework/assurance/runtime/_ops/scripts/validate-operator-read-models.sh"
    runtime_consumers:
      - "operators"
      - "validators"
    forbidden_consumers:
      - "runtime"
      - "policy"
      - "support-claim-evaluation"
EOF
