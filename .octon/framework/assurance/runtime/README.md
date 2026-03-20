# Assurance Runtime

## Purpose

Canonical runtime surface for assurance execution and trust artifact runtime
contracts.

## Contents

- `_ops/scripts/` - assurance engine and alignment validation entrypoints.
- `/.octon/state/evidence/validation/assurance/` - retained assurance receipts,
  scorecards, effective-weight snapshots, and deviation reports.
- `/.octon/generated/.tmp/assurance/` - ephemeral rebuild intermediates used by
  assurance execution.
- `trust/` - trust artifact runtime surfaces (`attestations/`, `evidence/`,
  `audits/`).

## Boundary

Executable assurance behavior belongs in `runtime/`.
Policy contracts belong in `../governance/`; operating standards belong in
`../practices/`.
