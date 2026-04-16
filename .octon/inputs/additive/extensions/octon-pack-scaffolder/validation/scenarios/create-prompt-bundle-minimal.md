# Create Prompt Bundle Minimal

## Target Kind

`prompt-bundle`

## Preconditions

- `demo-pack` already exists as an additive extension pack root
- `content_entrypoints.prompts` may still be `null`

## Invocation

- `/octon-pack-scaffolder-create-prompt-bundle --pack-id demo-pack --bundle-id review-surface`

## Expected Outputs

- a prompt bundle folder under `prompts/review-surface/`
- a one-stage `manifest.yml`
- a minimal `companions/01-align-bundle.md` asset and matching manifest entry
- `pack.yml` updated to publish `prompts/`

## Forbidden Outputs

- routing contracts
- prompt alignment receipts
- activation or publication changes
