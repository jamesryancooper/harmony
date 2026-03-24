# Commands

Retained command log for the Mission-Scoped Reversible Autonomy cutover.

- `bash .octon/framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh`
- `cargo test --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_kernel autonomous_request_requires_mission_context`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-proposal-package.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-authority.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-runtime-contracts.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-control-state.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-control-evidence.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-generated-summaries.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-mission-source-of-truth.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/test-mission-autonomy-scenarios.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile mission-autonomy`
- `bash .octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh`
- `bash .octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh`
- `bash .octon/framework/capabilities/_ops/scripts/publish-host-projections.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-state.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/alignment-check.sh --profile harness,mission-autonomy`
