# Plan Rust Tool Migration I/O Contract

Parameters are defined in the skills registry. This reference describes their
intended semantics for operators and agents.

## Parameters

- `target_path`: required folder containing the Rust script, crate, CLI utility,
  automation tool, or repo-local Rust scope to plan.
- `desired_target`: optional text selector; supported values are `auto`,
  `main-modules`, `bin-lib-split`, `multiple-binaries`, `workspace`, and
  `internal-crates`.
- `migration_depth`: optional text selector; supported values are `minimal`,
  `sufficient`, and `comprehensive`.
- `preserve_cli_contract`: optional boolean; when true, preserve existing CLI
  behavior unless a breaking change is explicitly requested.
- `include_file_moves`: optional boolean controlling whether the plan includes
  source-to-target path movement details.
- `evidence_depth`: optional text selector; supported values are `quick`,
  `standard`, and `deep`.
- `post_remediation`: optional boolean enabling verification-oriented plan
  formatting after implementation.

## Outputs

- advisory migration plan
- machine-readable migration summary JSON
- skill run log
- per-skill and top-level log indexes

All output paths are registry-declared. Do not write ad hoc plan paths.
