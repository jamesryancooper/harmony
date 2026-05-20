# Audit Rust Tool Architecture I/O Contract

Parameters are defined in the skills registry. This reference describes their
intended semantics for operators and agents.

## Parameters

- `target_path`: required folder containing the Rust script, crate, CLI utility,
  automation tool, repo-maintenance tool, or repo-local Rust scope to audit.
- `mode`: optional text selector; supported values are `audit`,
  `migration-plan`, and `post-remediation`.
- `evidence_depth`: optional text selector; supported values are `quick`,
  `standard`, and `deep`.
- `include_workspace_advice`: optional boolean controlling whether workspace
  splitting is evaluated.
- `severity_threshold`: optional text selector; supported values are
  `critical`, `high`, `medium`, `low`, and `all`.
- `post_remediation`: optional boolean enabling strict verification after fixes.
- `convergence_k`: optional text value for controlled rerun count.
- `seed_list`: optional comma-separated deterministic seed list.

## Outputs

- human-readable audit report
- machine-readable summary JSON
- bounded audit bundle
- skill run log
- per-skill and top-level log indexes

All output paths are registry-declared. Do not write ad hoc report paths.
