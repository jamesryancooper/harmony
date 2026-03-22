# Validation

- `cargo check --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_core -p octon_wasm_host -p octon_kernel` passed.
- `cargo test --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_core execution_integrity` passed.
- `cargo test --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_kernel authorization::tests` passed.
- `bash .octon/framework/capabilities/_ops/tests/test-policy-receipt-write-budget-metadata.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-architecture-conformance.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-runtime-effective-state.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh` passed after republishing capability routing.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-state.sh` passed.
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-continuity-memory.sh` passed after updating retained-run retention prefixes for live `tool-*`, `service-*`, and `acp-*` evidence classes.
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness` completed with `Alignment check summary: errors=0` under elevated host-projection access.
