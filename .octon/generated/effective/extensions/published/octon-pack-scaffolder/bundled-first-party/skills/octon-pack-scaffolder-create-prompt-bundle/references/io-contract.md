# IO Contract

## Inputs

- `pack_id` - required pack id
- `bundle_id` - required prompt bundle id
- `summary` - optional bundle summary
- `stage_id` - optional stage id, default `run`

## Outputs

- `prompts/<bundle-id>/README.md`
- `prompts/<bundle-id>/manifest.yml`
- `prompts/<bundle-id>/companions/01-align-bundle.md`
- `prompts/<bundle-id>/stages/01-<stage-id>.md`
- `prompts/<bundle-id>/references/bundle-contract.md`

## Source Of Truth

- `context/output-shapes.md#create-prompt-bundle`
- `context/examples/create-prompt-bundle-minimal.md`
