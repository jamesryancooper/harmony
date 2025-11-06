# Contracts (OpenAPI + JSON Schema)

This folder contains the **source-of-truth** for component boundaries.

- `openapi.yaml` — top-level API contract for endpoints under `/v1/{{feature-name}}`
- `schemas/{{feature-name}}.schema.json` — payload schema used by requests/responses and events

## CI suggestions

- **oasdiff**: fail PRs on breaking changes
- **jsonschema**: validate payloads in tests
- **contract tests**: use Pact (or similar) if you have consumer/provider repos

### Example (pseudo)

- Run diff: `oasdiff breaking --fail-on-diff packages/contracts/openapi.yaml origin/main:packages/contracts/openapi.yaml`
- Validate schema in unit tests using a JSON Schema validator
