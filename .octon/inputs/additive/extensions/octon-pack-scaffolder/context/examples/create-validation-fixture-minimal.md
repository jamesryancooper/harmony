# Create Validation Fixture Minimal

## Invocation

`/octon-pack-scaffolder-create-validation-fixture --pack-id demo-pack --fixture-id create-pack-smoke --target-kind pack`

## Expected Additions

- `/.octon/inputs/additive/extensions/demo-pack/validation/scenarios/create-pack-smoke.md`

## Expected Fixture Coverage

- preconditions
- invocation
- expected additive outputs
- forbidden outputs

## Refusal Case

- block if the existing scenario fixture conflicts with the requested target
  kind
