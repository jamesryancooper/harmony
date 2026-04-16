# IO Contract

## Inputs

- `pack_id` - required pack id
- `display_name` - optional human-readable pack name
- `summary` - optional README summary
- `version` - optional pack version, default `0.1.0`
- `origin_class` - optional pack origin class, default `first_party_bundled`

## Outputs

- `pack.yml`
- `README.md`
- `commands/manifest.fragment.yml`
- `skills/manifest.fragment.yml`
- `skills/registry.fragment.yml`
- `context/overview.md`
- `validation/compatibility.yml`
- empty `templates/`, `prompts/`, `validation/scenarios/`, and
  `validation/tests/` directories

## Source Of Truth

- `context/output-shapes.md#create-pack`
- `context/examples/create-pack-minimal.md`
