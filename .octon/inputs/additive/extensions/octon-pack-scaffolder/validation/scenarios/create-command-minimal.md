# Create Command Minimal

## Target Kind

`command`

## Preconditions

- `demo-pack` already exists
- `commands/manifest.fragment.yml` exists

## Invocation

- `/octon-pack-scaffolder-create-command --pack-id demo-pack --command-id demo-pack-review`

## Expected Outputs

- `commands/demo-pack-review.md`
- a lexical `demo-pack-review` entry in `commands/manifest.fragment.yml`

## Forbidden Outputs

- repo-native command manifests
- runtime or governance artifacts
