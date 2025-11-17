import assert from "node:assert/strict";
import { EventEmitter } from "node:events";
import { mkdtemp, mkdir, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { test } from "node:test";

import { runFlowFromConfigPath } from "../cli";

const BASE_CONFIG = {
  id: "architecture_assessment",
  displayName: "Architecture Assessment",
  description: "Alignment flow",
  type: "assessment",
  subject: "architecture",
  mode: "full",
  subtype: "alignment",
  canonicalPromptPath:
    "packages/prompts/assessment/architecture/architecture-assessment.md",
  workflowManifestPath:
    "packages/prompts/assessment/architecture/workflows/architecture-assessment.yaml",
  workflowEntrypoint: "architecture-inventory",
  runtime: {
    type: "http-service",
    url: "http://127.0.0.1:9000",
    autoStart: {
      pythonCommand: "agents/runner/runtime/.venv/bin/python",
      module: "agents.runner.runtime.server"
    }
  }
};

const createTempConfigFile = async (
  contents: Record<string, unknown>,
  filename = "flow.flow.json"
) => {
  const dir = await mkdtemp(join(tmpdir(), "flowkit-cli-"));
  const filePath = join(dir, filename);
  await writeFile(filePath, JSON.stringify(contents), "utf8");
  return filePath;
};

test("runFlowFromConfigPath executes the FlowRunner for a valid config", async () => {
  const configPath = await createTempConfigFile(BASE_CONFIG);

  let receivedUrl: string | undefined;
  const previousRunnerUrl = process.env.FLOWKIT_RUNNER_URL;
  process.env.FLOWKIT_RUNNER_URL = "http://runner.internal";

  try {
    const result = await runFlowFromConfigPath(configPath, {
      createHttpRunner: (options) => {
        receivedUrl = options.baseUrl;
        return {
          async run() {
            return {
              result: { ok: true },
              runId: "test-run",
              metadata: { flowName: "architecture_assessment" }
            };
          }
        };
      }
    });

    assert.equal(receivedUrl, "http://runner.internal");
    assert.deepEqual(result.result, { ok: true });
    assert.equal(result.runId, "test-run");
  } finally {
    if (previousRunnerUrl === undefined) {
      delete process.env.FLOWKIT_RUNNER_URL;
    } else {
      process.env.FLOWKIT_RUNNER_URL = previousRunnerUrl;
    }
  }
});

test("runFlowFromConfigPath fails when the config path does not exist", async () => {
  const missingPath = join(
    tmpdir(),
    `missing-${Date.now()}.flow.json`
  );

  await assert.rejects(
    runFlowFromConfigPath(missingPath),
    /Flow config not found/
  );
});

test("runFlowFromConfigPath rejects non .flow.json files", async () => {
  const invalidPath = await createTempConfigFile(BASE_CONFIG, "flow.json");

  await assert.rejects(
    runFlowFromConfigPath(invalidPath),
    /must end with '.flow\.json'/
  );
});

test("runFlowFromConfigPath surfaces JSON parse errors", async () => {
  const dir = await mkdtemp(join(tmpdir(), "flowkit-cli-invalid-"));
  const filePath = join(dir, "broken.flow.json");
  await writeFile(filePath, "{", "utf8");

  await assert.rejects(
    runFlowFromConfigPath(filePath),
    /Failed to parse JSON/
  );
});

test("runFlowFromConfigPath fails for unsupported runtime types", async () => {
  const configPath = await createTempConfigFile({
    ...BASE_CONFIG,
    runtime: {
      type: "python-module",
      pythonModule: "agents.runner.runtime.assessment.run"
    }
  });

  await assert.rejects(
    runFlowFromConfigPath(configPath),
    /unsupported runtime type/i
  );
});

test("runFlowFromConfigPath resolves relative paths against INIT_CWD", async () => {
  const repoRoot = await mkdtemp(join(tmpdir(), "flowkit-root-"));
  const relativePath =
    "packages/prompts/assessment/architecture/architecture-assessment.flow.json";
  const absoluteConfigPath = join(repoRoot, relativePath);
  await mkdir(dirname(absoluteConfigPath), { recursive: true });
  await writeFile(absoluteConfigPath, JSON.stringify(BASE_CONFIG), "utf8");

  const originalInitCwd = process.env.INIT_CWD;
  const originalWorkspaceRoot = process.env.FLOWKIT_WORKSPACE_ROOT;
  process.env.INIT_CWD = repoRoot;
  delete process.env.FLOWKIT_WORKSPACE_ROOT;
  const originalRunnerUrl = process.env.FLOWKIT_RUNNER_URL;
  process.env.FLOWKIT_RUNNER_URL = "http://runner.internal";

  let receivedWorkspaceRoot: string | undefined;
  try {
    await runFlowFromConfigPath(relativePath, {
      createHttpRunner: () => ({
        async run(request) {
          receivedWorkspaceRoot = request.config.workspaceRoot;
          return {
            result: { ok: true },
            runId: "relative-run",
            metadata: { flowName: request.config.flowName }
          };
        }
      })
    });
  } finally {
    if (originalInitCwd === undefined) {
      delete process.env.INIT_CWD;
    } else {
      process.env.INIT_CWD = originalInitCwd;
    }
    if (originalWorkspaceRoot === undefined) {
      delete process.env.FLOWKIT_WORKSPACE_ROOT;
    } else {
      process.env.FLOWKIT_WORKSPACE_ROOT = originalWorkspaceRoot;
    }
    if (originalRunnerUrl === undefined) {
      delete process.env.FLOWKIT_RUNNER_URL;
    } else {
      process.env.FLOWKIT_RUNNER_URL = originalRunnerUrl;
    }
  }

  assert.equal(receivedWorkspaceRoot, repoRoot);
});

test("runFlowFromConfigPath auto-starts the runner when no FLOWKIT_RUNNER_URL is set", async () => {
  const repoRoot = await mkdtemp(join(tmpdir(), "flowkit-autostart-"));
  const configPath = await createTempConfigFile({
    ...BASE_CONFIG,
    workspaceRoot: repoRoot,
    runtime: {
      type: "http-service",
      url: "http://127.0.0.1:9123",
      autoStart: {
        pythonCommand: "agents/runner/runtime/.venv/bin/python",
        module: "agents.runner.runtime.server",
        host: "127.0.0.1",
        port: 9123,
        readyTimeoutSeconds: 1
      }
    }
  });

  class FakeChild extends EventEmitter {
    kill() {
      this.emit("exit", 0);
      return true;
    }
  }

  const spawnCalls: Array<{ command: string; args: string[] }> = [];
  let healthChecks = 0;

  const result = await runFlowFromConfigPath(configPath, {
    spawnImpl: (command, args) => {
      spawnCalls.push({ command, args: args as string[] });
      return new FakeChild() as unknown as ChildProcess;
    },
    fetchImpl: async () => {
      healthChecks += 1;
      return {
        ok: true,
        status: 200,
        statusText: "OK",
        json: async () => ({}),
        text: async () => ""
      } as Awaited<ReturnType<typeof fetch>>;
    },
    createHttpRunner: (options) => ({
      async run() {
        return {
          result: { ok: true },
          runId: "auto-start",
          metadata: { runnerEndpoint: options.baseUrl }
        };
      }
    })
  });

  assert.equal(result.metadata?.runnerEndpoint, "http://127.0.0.1:9123");
  assert.equal(spawnCalls.length, 1);
  assert.equal(
    spawnCalls[0].command,
    join(repoRoot, "agents/runner/runtime/.venv/bin/python")
  );
  assert.deepEqual(spawnCalls[0].args.slice(0, 2), [
    "-m",
    "agents.runner.runtime.server"
  ]);
  assert.deepEqual(spawnCalls[0].args.slice(2), [
    "--host",
    "127.0.0.1",
    "--port",
    "9123"
  ]);
  assert.equal(healthChecks > 0, true);
});

test("runFlowFromConfigPath rejects configs with invalid classification metadata", async () => {
  const configPath = await createTempConfigFile({
    ...BASE_CONFIG,
    type: 123
  } as Record<string, unknown>);

  await assert.rejects(
    runFlowFromConfigPath(configPath),
    /invalid 'type' metadata/i
  );
});

