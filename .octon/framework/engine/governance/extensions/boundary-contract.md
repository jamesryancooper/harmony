# Extension Boundary Contract

Extensions are additive source inputs, not a second authority surface.

## Allowed Raw Pack Buckets

- `skills/`
- `commands/`
- `templates/`
- `prompts/`
- `context/`
- `validation/`

## Disallowed Raw Pack Content

- governance contracts
- practices or methodology authority
- `agency/`, `orchestration/`, or `engine/` authority
- assurance authority
- services and runtime service contracts
- mutable operational state
- compiled effective indexes

## Runtime Rule

Runtime and policy surfaces must consume generated effective extension views
only. Compilation, validation, export, and publication tooling may read raw
pack paths to build those views.
