# Contracts (OpenAPI + JSON Schema) — SpecKit Wrapper

Source-of-truth contracts for the SpecKit wrapper (thin HTTP/MCP facade) and optional schemas.

- `openapi.yaml` — API contract exposing wrapper operations under `/v1/speckit/*`
- `schemas/spec-frontmatter.schema.json` — Optional JSON Schema for spec front matter (if you use one)

## CI suggestions

- oasdiff: fail PRs on breaking changes to `openapi.yaml`
- jsonschema: validate spec front matter (if applicable)
- contract tests: parity tests for CLI vs HTTP/MCP wrapper

### Example (pseudo)

- Run diff: `oasdiff breaking --fail-on-diff packages/contracts/openapi.yaml origin/main:packages/contracts/openapi.yaml`
- Validate schema in unit tests using a JSON Schema validator
