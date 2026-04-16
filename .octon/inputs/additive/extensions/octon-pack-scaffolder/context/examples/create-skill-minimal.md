# Create Skill Minimal

## Invocation

`/octon-pack-scaffolder-create-skill --pack-id demo-pack --skill-id demo-pack-review --display-name "Demo Pack Review" --summary "Review one demo pack surface."`

## Expected Additions

- `/.octon/inputs/additive/extensions/demo-pack/skills/demo-pack-review/SKILL.md`
- `/.octon/inputs/additive/extensions/demo-pack/skills/demo-pack-review/references/phases.md`
- `/.octon/inputs/additive/extensions/demo-pack/skills/demo-pack-review/references/io-contract.md`
- `/.octon/inputs/additive/extensions/demo-pack/skills/demo-pack-review/references/validation.md`

## Expected Updates

- a lexical entry for `demo-pack-review` in `skills/manifest.fragment.yml`
- a lexical entry for `demo-pack-review` in `skills/registry.fragment.yml`

## Refusal Case

- block if the existing manifest or registry entry for the same id differs
