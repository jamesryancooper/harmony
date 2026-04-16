# IO Contract

## Inputs

- `pack_id` - required pack id
- `command_id` - required command id
- `display_name` - optional command display name
- `summary` - optional command summary
- `argument_hint` - optional argument hint text

## Outputs

- `commands/<command-id>.md`
- a lexical entry in `commands/manifest.fragment.yml`

## Source Of Truth

- `context/output-shapes.md#create-command`
- `context/examples/create-command-minimal.md`
