# Create Pack Minimal

## Invocation

`/octon-pack-scaffolder-create-pack --pack-id demo-pack --display-name "Demo Pack" --summary "Demo additive pack."`

## Expected Additions

- `/.octon/inputs/additive/extensions/demo-pack/pack.yml`
- `/.octon/inputs/additive/extensions/demo-pack/README.md`
- `/.octon/inputs/additive/extensions/demo-pack/commands/manifest.fragment.yml`
- `/.octon/inputs/additive/extensions/demo-pack/skills/manifest.fragment.yml`
- `/.octon/inputs/additive/extensions/demo-pack/skills/registry.fragment.yml`
- `/.octon/inputs/additive/extensions/demo-pack/context/overview.md`
- `/.octon/inputs/additive/extensions/demo-pack/validation/compatibility.yml`

## Expected Empty Directories

- `templates/`
- `prompts/`
- `validation/scenarios/`
- `validation/tests/`

## Refusal Case

- block if `pack.yml` already exists with conflicting `pack_id` or
  `content_entrypoints`
