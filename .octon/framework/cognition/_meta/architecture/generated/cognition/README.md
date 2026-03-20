# Generated Cognition Outputs

`generated/cognition/**` contains derived cognition read models only.

## Families

- `summaries/**`
- `graph/**`
- `projections/definitions/**`
- `projections/materialized/**`

## Commit Policy

- `summaries/**` is committed by default
- `projections/definitions/**` is committed by default
- `graph/**` rebuilds locally by default
- `projections/materialized/**` rebuilds locally by default

## Boundary

Generated cognition outputs aid navigation, inspection, and tooling. They do
not replace `instance/cognition/**` or `state/**` as authority.
