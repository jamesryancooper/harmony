# Closure Certification Plan

## Certification objective

The transition closes only when Octon's promoted architecture is able to pass a rigorous 10/10 architecture review because its strongest claims are structurally simplified, runtime-enforced, freshness-aware, proof-backed, and operator-traceable.

## Certificate root

The final certificate should be retained at:

```text
.octon/state/evidence/validation/architecture/10of10-target-transition/closure/certificate.yml
```

## Required certificate sections

```yaml
schema_version: architecture-closure-certificate-v1
proposal_id: octon-architecture-10of10-target-state-transition
closed_at: <timestamp>
result: pass|fail
closure_grade: closure-grade
validated_dimensions:
  structural_contract: pass|fail
  runtime_effective_handles: pass|fail
  freshness_modes: pass|fail
  authorization_coverage: pass|fail
  capability_pack_cutover: pass|fail
  extension_lifecycle: pass|fail
  support_proof: pass|fail
  operator_read_models: pass|fail
  compatibility_retirement: pass|fail
  architecture_health_v2: pass|fail
negative_controls:
  stale_route_bundle_denial: pass|fail
  raw_generated_effective_read_denial: pass|fail
  pack_route_widening_denial: pass|fail
  quarantined_extension_denial: pass|fail
  generated_read_model_authority_denial: pass|fail
publication_receipts:
  runtime_route_bundle: <path>
  capability_pack_routes: <path>
  extension_catalog: <path>
  support_matrix: <path>
proof_bundle_refs:
  - <path>
remaining_exceptions:
  - id: <id>
    reason: <reason>
    expiry: <timestamp>
```

## Closure levels

| Level | Meaning | Accepted for 10/10? |
|---|---|---:|
| existence | Required files exist. | No |
| schema | Files validate against schema. | No |
| semantic | Relationships and source refs are coherent. | Partial |
| runtime | Runtime denies bad states and consumes correct handles. | Required |
| proof | Claims are backed by executable evidence. | Required |
| closure-grade | All required semantic, runtime, proof, publication, and compatibility gates pass. | Yes |

## Closure blockers

The certificate must fail if any of the following remain true:

- Route-bundle lock still relies on fake far-future freshness rather than explicit freshness mode.
- Runtime can read generated/effective files by raw path for grant decisions.
- Any material side-effect path lacks authorization-boundary coverage.
- `instance/capabilities/runtime/packs/**` remains a steady-state runtime route source.
- Support claims depend on summary-only proof bundles.
- Generated support cards, support matrices, or operator read models can widen claims.
- Architecture health only proves file existence/schema rather than semantic/runtime/proof depth.
