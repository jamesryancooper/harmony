# Commands

- `cargo check --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_core -p octon_wasm_host -p octon_kernel`
- `cargo test --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_core execution_integrity`
- `cargo test --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_kernel authorization::tests`
- `bash .octon/framework/capabilities/_ops/tests/test-policy-receipt-write-budget-metadata.sh`
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-architecture-conformance.sh`
- `bash .octon/framework/assurance/runtime/_ops/tests/test-validate-runtime-effective-state.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh`
- `bash .octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-state.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-continuity-memory.sh`
- `bash .octon/framework/capabilities/_ops/scripts/publish-host-projections.sh` (elevated)
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness` (elevated)
