# Flow — Harness-Native Flow Execution Service

Flow forwards typed run requests to a runtime endpoint and normalizes responses for orchestration.

## Purpose

- Accept a typed flow run request.
- Validate required flow config fields.
- Optionally run in dry-run mode without network side effects.
- Forward live calls to a configured HTTP runtime endpoint.

## Inputs and Outputs

- Input schema: `schema/input.schema.json`
- Output schema: `schema/output.schema.json`

## Operation

- `run`

## Policy

- Rules: `workflow-exists`, `workflow-valid`, `runner-available`
- Enforcement: `block`
- Fail-closed: `true`

## Runtime

- Entrypoint: `impl/flow-client.sh`
- Runtime env vars:
  - `FLOW_SERVICE_URL` (default `http://127.0.0.1:8410/flows/run`)
  - `FLOW_SERVICE_TIMEOUT_SECONDS` (default `30`)

## Contract Artifacts

- Invariants: `contracts/invariants.md`
- Errors: `contracts/errors.yml`
- Rules: `rules/rules.yml`
- Fixtures: `fixtures/`
- Compatibility: `compatibility.yml`
- Generation provenance: `impl/generated.manifest.json`
