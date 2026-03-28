# Command Log

- `bash .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh backfill-wave4 --run-id run-wave3-runtime-bridge-20260327`
- `bash .octon/framework/orchestration/runtime/_ops/scripts/write-run.sh backfill-wave4 --run-id run-wave4-benchmark-evaluator-20260327`
- `bash .octon/framework/orchestration/runtime/runs/_ops/scripts/validate-runs.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-execution-constitution-closeout.sh`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-assurance-disclosure-expansion.sh`
- `cargo test --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_core orchestration::tests::snapshot_reports_surface_health -- --exact`
- `cargo test --manifest-path .octon/framework/engine/runtime/crates/Cargo.toml -p octon_kernel authorization::tests::autonomous_request_allows_seeded_mission_context -- --exact`
- `mv .octon/inputs/exploratory/proposals/architecture/execution-constitution-completion-closeout .octon/inputs/exploratory/proposals/.archive/architecture/execution-constitution-completion-closeout`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-proposal-standard.sh --package .octon/inputs/exploratory/proposals/.archive/architecture/execution-constitution-completion-closeout`
- `bash .octon/framework/assurance/runtime/_ops/scripts/validate-architecture-proposal.sh --package .octon/inputs/exploratory/proposals/.archive/architecture/execution-constitution-completion-closeout`
- `bash .octon/framework/assurance/runtime/_ops/scripts/generate-proposal-registry.sh --write`
