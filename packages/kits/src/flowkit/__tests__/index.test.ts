import assert from "node:assert/strict";
import { EventEmitter } from "node:events";
import { test } from "node:test";
import type { spawn as SpawnFn } from "node:child_process";

import { createPythonModuleFlowRunner } from "../index";

interface SpawnStubOptions {
  stdoutChunks?: string[];
  stderrChunks?: string[];
  exitCode?: number;
  error?: Error;
}

const createStream = () => {
  const stream = new EventEmitter() as unknown as NodeJS.ReadableStream & {
    setEncoding: (encoding: BufferEncoding) => void;
  };
  stream.setEncoding = () => {};
  return stream;
};

const createSpawnStub = (options: SpawnStubOptions): SpawnFn => {
  const { stdoutChunks = [], stderrChunks = [], exitCode = 0, error } = options;

  const spawnStub: SpawnFn = ((() => {
    const stdout = createStream();
    const stderr = createStream();
    const child = new EventEmitter() as unknown as ReturnType<SpawnFn>;
    (child as any).stdout = stdout;
    (child as any).stderr = stderr;

    setImmediate(() => {
      if (error) {
        child.emit("error", error);
        return;
      }

      stdoutChunks.forEach((chunk) => stdout.emit("data", chunk));
      stderrChunks.forEach((chunk) => stderr.emit("data", chunk));
      child.emit("close", exitCode);
    });

    return child;
  }) as unknown) as SpawnFn;

  return spawnStub;
};

const baseConfig = {
  flowName: "architecture_assessment",
  canonicalPromptPath:
    "packages/prompts/assessment/architecture/architecture-assessment.md",
  workspaceRoot: "/tmp/harmony",
  workflowManifestPath:
    "packages/prompts/assessment/architecture/workflows/architecture-assessment.yaml"
};

test("createPythonModuleFlowRunner parses JSON output and surfaces metadata", async () => {
  const spawnStub = createSpawnStub({
    stdoutChunks: ['{"ok":true,"score":95}']
  });

  const runner = createPythonModuleFlowRunner(
    { module: "agents.runner.runtime.architecture_assessment.run" },
    { spawn: spawnStub }
  );

  const result = await runner.run({ config: baseConfig });

  assert.deepEqual(result.result, { ok: true, score: 95 });
  assert.equal(result.metadata?.flowName, baseConfig.flowName);
  assert.equal(
    result.metadata?.workflowManifestPath,
    baseConfig.workflowManifestPath
  );
  assert.equal(
    result.metadata?.canonicalPromptPath,
    baseConfig.canonicalPromptPath
  );
});

test("createPythonModuleFlowRunner falls back to plain text when stdout is not JSON", async () => {
  const spawnStub = createSpawnStub({
    stdoutChunks: ["alignment complete"]
  });

  const runner = createPythonModuleFlowRunner(
    { module: "agents.runner.runtime.architecture_assessment.run" },
    { spawn: spawnStub }
  );

  const result = await runner.run({ config: baseConfig });
  assert.equal(result.result, "alignment complete");
});

test("createPythonModuleFlowRunner surfaces stderr when the Python process exits non-zero", async () => {
  const spawnStub = createSpawnStub({
    stderrChunks: ["runtime failure"],
    exitCode: 1
  });

  const runner = createPythonModuleFlowRunner(
    { module: "agents.runner.runtime.architecture_assessment.run" },
    { spawn: spawnStub }
  );

  await assert.rejects(
    runner.run({ config: baseConfig }),
    /FlowKit runtime failed: runtime failure/
  );
});

test("createPythonModuleFlowRunner returns a helpful error when spawn fails", async () => {
  const spawnStub = createSpawnStub({
    error: new Error("ENOENT python")
  });

  const runner = createPythonModuleFlowRunner(
    { module: "agents.runner.runtime.architecture_assessment.run" },
    { spawn: spawnStub }
  );

  await assert.rejects(
    runner.run({ config: baseConfig }),
    /Failed to start FlowKit Python runtime/
  );
});

