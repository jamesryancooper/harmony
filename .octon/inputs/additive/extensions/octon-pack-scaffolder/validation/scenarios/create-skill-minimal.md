# Create Skill Minimal

## Target Kind

`skill`

## Preconditions

- `demo-pack` already exists
- `skills/manifest.fragment.yml` and `skills/registry.fragment.yml` exist

## Invocation

- `/octon-pack-scaffolder-create-skill --pack-id demo-pack --skill-id demo-pack-review`

## Expected Outputs

- a skill directory with `SKILL.md` and three reference files
- lexical fragment entries in the skill manifest and registry

## Forbidden Outputs

- updates to core or instance skill manifests
- direct host projection files
