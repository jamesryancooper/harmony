# FlowKit `/run-flow`

Run any FlowKit LangGraph flow by pointing to its `.flow.json` config file.

## Usage

```
/run-flow @packages/prompts/.../<flow-name>.flow.json
```

## Instructions

1. Confirm the user included **exactly one** `@Files` or `@Code` reference that resolves to a `.flow.json` file. If they did not, tell them to rerun the command and select the desired config file via `@Files`.
2. Resolve the referenced file path (for example, `packages/prompts/assessment/architecture/architecture-assessment.flow.json`). If it does **not** end with `.flow.json`, reply with a friendly error and stop.
3. Optionally read the config to echo back the `id` and `displayName`, e.g., “Running FlowKit flow `architecture_assessment` — Architecture Assessment”.
4. Use the terminal `run` tool with working directory set to the repo root to execute:
   ```
   pnpm flowkit:run <resolved-config-path>
   ```
5. Wait for the command to finish. If it fails, surface the stderr output so the user can fix the issue (bad path, invalid JSON, runtime failure, etc.).
6. Summarize the FlowKit result for the user and link to any artifacts listed in the CLI output. Mention the config path you ran for traceability.

> This command does **not** accept canonical prompts or manifest files. Always select a `.flow.json` config via the `@` symbol for validation and discoverability.

