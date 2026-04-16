# IO Contract

## Inputs

- `pack_id` - required pack id
- `skill_id` - required skill id
- `display_name` - optional skill display name
- `summary` - optional skill summary

## Outputs

- `skills/<skill-id>/SKILL.md`
- `skills/<skill-id>/references/phases.md`
- `skills/<skill-id>/references/io-contract.md`
- `skills/<skill-id>/references/validation.md`
- lexical entries in `skills/manifest.fragment.yml`
- lexical entries in `skills/registry.fragment.yml`

## Source Of Truth

- `context/output-shapes.md#create-skill`
- `context/examples/create-skill-minimal.md`
