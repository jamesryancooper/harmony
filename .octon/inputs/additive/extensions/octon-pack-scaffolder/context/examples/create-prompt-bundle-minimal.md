# Create Prompt Bundle Minimal

## Invocation

`/octon-pack-scaffolder-create-prompt-bundle --pack-id demo-pack --bundle-id review-surface --stage-id inspect --summary "Inspect one surface."`

## Expected Additions

- `/.octon/inputs/additive/extensions/demo-pack/prompts/review-surface/README.md`
- `/.octon/inputs/additive/extensions/demo-pack/prompts/review-surface/manifest.yml`
- `/.octon/inputs/additive/extensions/demo-pack/prompts/review-surface/companions/01-align-bundle.md`
- `/.octon/inputs/additive/extensions/demo-pack/prompts/review-surface/stages/01-inspect.md`
- `/.octon/inputs/additive/extensions/demo-pack/prompts/review-surface/references/bundle-contract.md`

## Expected Update

- `pack.yml` updates `content_entrypoints.prompts` from `null` to `prompts/`
  when needed

## Refusal Case

- block if the bundle manifest already exists with conflicting `prompt_set_id`
