import { spawn } from "node:child_process";
import { randomUUID } from "node:crypto";
import { resolve } from "node:path";

export interface FlowConfig {
  /**
   * Identifier for the flow to run (e.g., "architecture_assessment").
   */
  flowName: string;

  /**
   * Absolute or repo-relative path to the canonical prompt that defines the flow.
   * Example: "packages/prompts/assessment/architecture/architecture-assessment.md"
   */
  canonicalPromptPath: string;

  /**
   * Optional workspace root to resolve relative paths against.
   */
  workspaceRoot?: string;

  /**
   * Optional workflow manifest path to propagate in metadata.
   */
  workflowManifestPath?: string;
}

export interface FlowRunRequest {
  config: FlowConfig;

  /**
   * Optional initial state or parameters to seed the flow.
   * Concrete flows should define a typed shape and validate it at the edge.
   */
  params?: Record<string, unknown>;
}

export interface FlowRunResult {
  /**
   * Opaque flow-specific result payload, typically a structured summary
   * or report (for example, an alignment report).
   */
  result: unknown;

  /**
   * Stable identifier for this run, used for telemetry and correlation.
   */
  runId: string;

  /**
   * Optional path(s) to artifacts produced by the flow (for example, reports).
   */
  artifacts?: string[];

  /**
   * Optional metadata about the flow run (model config, manifest path, etc.).
   */
  metadata?: {
    flowName?: string;
    workflowManifestPath?: string;
    canonicalPromptPath?: string;
    repoRoot?: string;
  };
}

/**
 * FlowRunner defines the minimal contract for running a FlowKit flow.
 *
 * Runtime implementations (for example, a Python LangGraph runner, HTTP service,
 * or local Node orchestration) should implement this interface and be wired up
 * via composition. This package does not prescribe a specific runtime.
 */
export interface FlowRunner {
  run(request: FlowRunRequest): Promise<FlowRunResult>;
}

/**
 * Placeholder/no-op FlowRunner.
 *
 * This default implementation exists so callers can depend on FlowKit types
 * without immediately wiring a runtime. In production, provide a concrete
 * FlowRunner (for example, one that shells out to a Python LangGraph runner
 * or calls a dedicated HTTP service).
 */
export const notImplementedFlowRunner: FlowRunner = {
  async run() {
    throw new Error(
      "FlowKit notImplementedFlowRunner was called. Provide a concrete FlowRunner implementation for your runtime (e.g., Python LangGraph runner or HTTP service)."
    );
  }
};

export interface PythonModuleFlowRunnerOptions {
  /**
   * Python module path to invoke via `python -m`.
   * Example: "agents.runner.runtime.architecture_assessment.run".
   */
  module: string;

  /**
   * Python command to use. Defaults to "python".
   * Override via env (e.g., FLOWKIT_PYTHON_CMD) or caller options if needed.
   */
  pythonCommand?: string;
}

export interface PythonModuleFlowRunnerDependencies {
  /**
   * Override spawn implementation (used by tests).
   */
  spawn?: typeof spawn;
}

/**
 * Create a FlowRunner that shells out to a Python module using
 * `python -m <module> <canonicalPromptPath>`, with cwd set to
 * the configured workspace root (or process.cwd()).
 *
 * The Python module is expected to print either:
 * - JSON to stdout (which will be parsed), or
 * - plain text (which will be returned as a string).
 */
export function createPythonModuleFlowRunner(
  options: PythonModuleFlowRunnerOptions,
  dependencies?: PythonModuleFlowRunnerDependencies
): FlowRunner {
  const pythonCmd =
    options.pythonCommand || process.env.FLOWKIT_PYTHON_CMD || "python";
  const spawnImpl = dependencies?.spawn || spawn;

  return {
    async run(request: FlowRunRequest): Promise<FlowRunResult> {
      const { config } = request;
      const runId = randomUUID();

      const cwd = config.workspaceRoot
        ? resolve(config.workspaceRoot)
        : process.cwd();

      const args = [
        "-m",
        options.module,
        config.canonicalPromptPath
      ];

      const stdout = await new Promise<string>((resolveStdout, reject) => {
        const child = spawnImpl(pythonCmd, args, {
          cwd,
          stdio: ["ignore", "pipe", "pipe"]
        });

        let out = "";
        let err = "";

        child.stdout.setEncoding("utf8");
        child.stdout.on("data", (chunk) => {
          out += chunk;
        });

        child.stderr.setEncoding("utf8");
        child.stderr.on("data", (chunk) => {
          err += chunk;
        });

        child.on("error", (e) => {
          reject(
            new Error(
              `Failed to start FlowKit Python runtime with '${pythonCmd}': ${e.message}\n\nEnsure:\n- Python is installed and accessible as '${pythonCmd}'\n- The canonical prompt exists at '${config.canonicalPromptPath}'\n- Required Python dependencies are installed`
            )
          );
        });

        child.on("close", (code) => {
          if (code !== 0) {
            const msg =
              err ||
              `Python process exited with code ${code}. Module: ${options.module}, Path: ${config.canonicalPromptPath}`;
            reject(
              new Error(
                `FlowKit runtime failed: ${msg}\n\nEnsure:\n- Python is installed and accessible as '${pythonCmd}'\n- The canonical prompt exists at '${config.canonicalPromptPath}'\n- Required Python dependencies are installed`
              )
            );
            return;
          }
          resolveStdout(out.trim());
        });
      });

      let parsed: unknown = stdout;
      if (stdout) {
        try {
          parsed = JSON.parse(stdout);
        } catch {
          // keep raw string if not valid JSON
          parsed = stdout;
        }
      }

      return {
        result: parsed,
        runId,
        metadata: {
          flowName: config.flowName,
          workflowManifestPath: config.workflowManifestPath,
          canonicalPromptPath: config.canonicalPromptPath,
          repoRoot: config.workspaceRoot || process.cwd()
        },
      };
    }
  };
}

/**
 * Convenience FlowRunner for the Architecture Assessment flow.
 *
 * This uses the Python LangGraph runtime hosted at:
 *   agents/runner/runtime/architecture_assessment/run.py
 *
 * and invokes it as:
 *   python -m agents.runner.runtime.architecture_assessment.run <canonicalPromptPath>
 */
export const architectureAssessmentCliRunner: FlowRunner =
  createPythonModuleFlowRunner({
    module: "agents.runner.runtime.architecture_assessment.run"
  });

