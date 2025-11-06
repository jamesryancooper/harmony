# Harmony Documentation Stubs

For full guidance on how these stubs fit together and how to use them, see the Documentation Standards guide: [docs/handbook/documentation-standards/README.md](../README.md).

This bundle contains **ready-to-rename** stubs for the Harmony workflow:

- `Spec One-Pager` + lightweight `ADR`
- `BMAD Story` (execution plan) + **Contracts** (OpenAPI + JSON Schema)
- `Component/Developer Guide`
- `Operations Runbook`

> Rename `{{feature-name}}` and `{{component-name}}` to your real names. Then do a global find/replace inside files.

## Suggested next steps

1. Rename folders and file placeholders.
2. Edit `packages/contracts/openapi.yaml` and `schemas/{{feature-name}}.schema.json` to match your API/events.
3. Enable CI checks (oasdiff, schema validation, contract tests) as described in `packages/contracts/README.md`.
4. Keep features **behind a feature flag** until rollout.
