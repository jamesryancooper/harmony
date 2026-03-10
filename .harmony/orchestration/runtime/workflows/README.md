# Workflows

`/.harmony/orchestration/runtime/workflows/` is the single canonical
orchestration surface in Harmony.

Each workflow unit contains:

- `workflow.yml` as the canonical machine-readable contract
- `stages/` as the canonical executor-facing stage assets
- `README.md` as the generated human-readable and slash-facing facet

## Discovery

1. Read `manifest.yml` for workflow discovery.
2. Read `registry.yml` for extended workflow metadata.
3. Load `<group>/<id>/workflow.yml` as the authoritative contract.
4. Load `README.md` only when human-readable staged guidance is needed.

## Authority Model

- Canonical authority lives in `workflow.yml` and `stages/`.
- `README.md` is generated and must not be treated as authoritative.
- No peer legacy orchestration surface remains.

## Groups

- `meta/`
- `audit/`
- `refactor/`
- `foundations/`
- `missions/`
- `projects/`
- `ideation/`
- `tasks/`
