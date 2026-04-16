# Create Pack Minimal

## Target Kind

`pack`

## Preconditions

- `/.octon/inputs/additive/extensions/demo-pack/` does not exist

## Invocation

- `/octon-pack-scaffolder-create-pack --pack-id demo-pack`

## Expected Outputs

- a valid `pack.yml` with `schema_version: "octon-extension-pack-v4"`
- MVP fragment files under `commands/` and `skills/`
- `context/overview.md`
- `validation/compatibility.yml`

## Forbidden Outputs

- `/.octon/instance/**`
- `/.octon/state/**`
- `/.octon/generated/**`
