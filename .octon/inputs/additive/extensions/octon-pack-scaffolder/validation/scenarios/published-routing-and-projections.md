# Published Routing And Projections

## Target Kind

`publication`

## Preconditions

- `octon-pack-scaffolder` is enabled in `instance/extensions.yml`
- extension, capability, and host projections have been republished

## Invocation

- `resolve-extension-route.sh` against the published
  `octon-pack-scaffolder` dispatcher
- host projection validation for `.claude/`, `.cursor/`, and `.codex/`

## Expected Outputs

- one published dispatcher entry for `octon-pack-scaffolder`
- resolved route receipts for all six supported targets
- compiled extension projections for exported commands and skills
- host-projected command files and skill directories for all three hosts

## Forbidden Outputs

- raw `inputs/**` paths treated as runtime authority
- missing dispatcher metadata for the family root
- missing host projections after publish
