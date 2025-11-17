# FlowKit `/run-flow`

Run any FlowKit LangGraph flow by pointing to its `.flow.json` config file.

## Usage

```
/run-flow @packages/prompts/.../<flow-name>.flow.json
```

## Instructions

1. Confirm the user included **exactly one** `@Files`/`@Code` reference that resolves to a `.flow.json` file. If not, ask them to rerun the command and select the desired config via `@Files`.
2. Resolve the referenced path relative to the repo root (for example, `packages/prompts/assessment/architecture/architecture-assessment.flow.json`). If it does **not** end with `.flow.json`, respond with a friendly error and stop.
3. Read the JSON config so you can surface:
   - `id`, `displayName`, and `description`.
   - `workflowManifestPath`, `workflowEntrypoint`, and optional `workspaceRoot`.
   - Anything else needed to cite results/artifacts. If the JSON is invalid or missing required fields, return the parse error and stop.
4. Announce which flow is about to run (e.g., “Running FlowKit flow `<id>` — `<displayName>` from `<configPath>`”) so the user can confirm they selected the right file.
5. Use the terminal `run` tool from the repo root to execute:
   ```
   pnpm flowkit:run <resolved-config-path>
   ```
6. Wait for the CLI to finish. If it fails (bad path, missing runner deps, runtime error, etc.), surface stderr/stdout so the user can fix the issue.
7. Craft a response with two sections:
   - **Flow result** — summarize success/failure, include the config path, flow id/display name, notable output, and link any artifacts reported by the CLI.
   - **LangGraph Studio** — instruct the user how to launch Studio for the **same** flow without running it for them. Use the fields you read from the config to populate this snippet:
     ```
     FLOWKIT_STUDIO_WORKFLOW_MANIFEST=<workflowManifestPath>
     FLOWKIT_STUDIO_WORKFLOW_ENTRYPOINT=<workflowEntrypoint>
     FLOWKIT_STUDIO_WORKSPACE_ROOT=<workspaceRoot-or-repo-root>
     langgraph dev --config langgraph.json
     ```
     - Only include the workspace-root line when the config defines one; otherwise remind the user to run the command from the repo root.
     - Mention that `langgraph.json` must contain an entry for this flow (add one if new flows are introduced) or set the env vars shown above before running `langgraph dev`.
     - Do **not** launch Studio automatically; simply share the instructions so the user can copy/paste.
8. Remind the user that `/run-flow` always derives these instructions from the selected `.flow.json`, so multiple flows are supported as long as each flow ships a config and (optionally) a LangGraph Studio entry.

> `/run-flow` only accepts `.flow.json` configs. It does **not** take canonical prompts or manifests directly.

