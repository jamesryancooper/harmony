# Create Command Minimal

## Invocation

`/octon-pack-scaffolder-create-command --pack-id demo-pack --command-id demo-pack-review --display-name "Demo Pack Review" --summary "Review one demo surface." --argument-hint "[target-path]"`

## Expected Additions

- `/.octon/inputs/additive/extensions/demo-pack/commands/demo-pack-review.md`

## Expected Update

- a lexical `demo-pack-review` entry in `commands/manifest.fragment.yml`

## Refusal Case

- block if the existing command markdown or fragment entry conflicts
