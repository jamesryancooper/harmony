# IO Contract

## Inputs

- `target` - optional scaffold target selector; required for leaf execution
- `pack_id` - optional additive extension pack id; required once a leaf target
  is selected
- target-specific fields such as `bundle_id`, `skill_id`, `command_id`,
  `doc_id`, or `fixture_id`

## Outputs

- dispatcher overview when `target` is omitted
- one scaffolded asset family under
  `/.octon/inputs/additive/extensions/<pack-id>/`
- a receipt covering created, reused, and blocked paths

## Source Of Truth

- `context/output-shapes.md`
- `context/routing.contract.yml`
- `context/examples/*.md`
