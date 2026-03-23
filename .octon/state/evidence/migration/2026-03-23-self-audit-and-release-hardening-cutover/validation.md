# Validation

- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-alignment-profile-registry.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-authoritative-doc-triggers.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-github-action-pins.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-runtime-target-parity.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/tests/test-alignment-profile-registry.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-authoritative-doc-triggers.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-github-action-pins.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-runtime-target-parity.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-harness-structure.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh` passed.
- `cargo check --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_kernel` passed.
- `bash .octon/framework/capabilities/_ops/scripts/publish-host-projections.sh` passed under elevated access after the sandboxed run could not refresh `.codex/**`.
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness` passed under elevated access with `Alignment check summary: errors=0`.
