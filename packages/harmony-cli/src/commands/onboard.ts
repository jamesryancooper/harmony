/**
 * `harmony onboard` - AI-assisted onboarding for new developers.
 *
 * Guides new team members through their first tasks with step-by-step
 * assistance, turning weeks of onboarding into days.
 */

import type { CommandResult, OnboardingProgress, OnboardingStepType } from "../types/index.js";
import {
  loadOnboardingProgress,
  getOrCreateOnboarding,
  getCurrentStep,
  getProgressSummary,
  startWelcome,
  completeWelcome,
  runEnvironmentCheck,
  guideFirstStatus,
  completeFirstStatus,
  startGuidedFix,
  buildOnboardingTask,
  completeGuidedFix,
  startGuidedFeature,
  completeGuidedFeature,
  startShipStep,
  completeOnboarding,
  skipToStep,
  updateStepStatus,
  advanceToNextStep,
} from "../orchestrator/index.js";
import {
  bold,
  muted,
  success,
  info,
  warning,
  highlight,
  dim,
} from "../ui/index.js";
import { createSpinner } from "../ui/index.js";
import { header } from "../ui/format.js";

export interface OnboardOptions {
  name?: string;
  skip?: boolean;
}

/**
 * Get the workspace root.
 */
function getWorkspaceRoot(): string {
  return process.env.HARMONY_WORKSPACE_ROOT ?? process.cwd();
}

/**
 * Format the onboarding progress display.
 */
function formatOnboardingProgress(progress: OnboardingProgress): string {
  const lines: string[] = [];
  const current = getCurrentStep(progress);

  lines.push(header("Onboarding Progress"));
  lines.push("");

  // Progress bar
  const completed = progress.steps.filter((s) => s.status === "completed").length;
  const total = progress.steps.length;
  const pct = Math.round((completed / total) * 100);
  const barWidth = 30;
  const filledWidth = Math.round((completed / total) * barWidth);
  const bar = "█".repeat(filledWidth) + "░".repeat(barWidth - filledWidth);

  lines.push(`${bar} ${pct}%`);
  lines.push("");

  // Step list
  for (const step of progress.steps) {
    let icon: string;
    let color: (s: string) => string;

    switch (step.status) {
      case "completed":
        icon = "✓";
        color = success;
        break;
      case "in_progress":
        icon = "▶";
        color = info;
        break;
      case "waiting_input":
        icon = "…";
        color = warning;
        break;
      case "skipped":
        icon = "○";
        color = muted;
        break;
      default:
        icon = "·";
        color = muted;
    }

    const title = step.id === current?.id ? bold(step.title) : step.title;
    const time = step.completedAt && step.startedAt
      ? ` (${Math.round((step.completedAt.getTime() - step.startedAt.getTime()) / 60000)}m)`
      : step.status === "pending"
        ? ` ~${step.estimatedMinutes}m`
        : "";

    lines.push(`  ${color(icon)} ${color(title)}${muted(time)}`);
  }

  lines.push("");

  if (progress.isComplete) {
    lines.push(success(bold("🎉 Onboarding complete!")));
    lines.push(muted(`Total time: ${progress.totalMinutesSpent} minutes`));
  } else if (current) {
    lines.push(info(`Current step: ${bold(current.title)}`));
    if (current.guidance) {
      lines.push("");
      lines.push(muted("─".repeat(50)));
      lines.push("");
      lines.push(current.guidance);
    }
  }

  return lines.join("\n");
}

/**
 * Format a step result for display.
 */
function formatStepResult(
  result: { success: boolean; message: string; celebration?: string; nextAction?: string }
): void {
  console.log("");

  if (result.celebration) {
    console.log(success(bold(result.celebration)));
    console.log("");
  }

  console.log(result.message);

  if (result.nextAction) {
    console.log("");
    console.log(highlight("Next:"), result.nextAction);
  }

  console.log("");
}

/**
 * Main onboard command - routes to sub-commands.
 */
export async function onboardCommand(
  subCommand?: string,
  args: string[] = [],
  options?: OnboardOptions
): Promise<CommandResult> {
  const workspaceRoot = getWorkspaceRoot();

  // Route to appropriate handler
  switch (subCommand?.toLowerCase()) {
    case "start":
      return onboardStart(workspaceRoot, options?.name);

    case "status":
      return onboardStatus(workspaceRoot);

    case "next":
      return onboardNext(workspaceRoot);

    case "fix":
      return onboardFix(workspaceRoot, args.join(" "));

    case "feature":
      return onboardFeature(workspaceRoot, args.join(" "));

    case "build":
      return onboardBuild(workspaceRoot);

    case "approve":
      return onboardApprove(workspaceRoot);

    case "skip":
      return onboardSkip(workspaceRoot, args[0] as OnboardingStepType);

    case "reset":
      return onboardReset(workspaceRoot);

    case undefined:
    case "":
      // Check if onboarding is in progress
      const existing = loadOnboardingProgress(workspaceRoot);
      if (existing && !existing.isComplete) {
        return onboardStatus(workspaceRoot);
      }
      return onboardStart(workspaceRoot, options?.name);

    default:
      return {
        success: false,
        message: `Unknown onboard sub-command: ${subCommand}\n\nAvailable: start, status, next, fix, feature, build, approve, skip, reset`,
      };
  }
}

/**
 * Start onboarding.
 */
async function onboardStart(
  workspaceRoot: string,
  userName?: string
): Promise<CommandResult> {
  const progress = getOrCreateOnboarding(workspaceRoot, userName);
  const current = getCurrentStep(progress);

  console.log("");
  console.log(success(bold("🚀 Welcome to Harmony Onboarding!")));
  console.log("");

  if (userName) {
    console.log(`Hi ${highlight(userName)}! Let's get you productive.`);
  } else {
    console.log("Let's get you productive in about 15 minutes.");
  }

  console.log("");
  console.log(muted("─".repeat(50)));

  // Start the welcome step
  const result = await startWelcome(workspaceRoot, progress);

  formatStepResult(result);

  return {
    success: true,
    message: "Onboarding started",
    data: { progress },
    nextAction: 'Run "harmony onboard next" to continue',
  };
}

/**
 * Show onboarding status.
 */
async function onboardStatus(workspaceRoot: string): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    console.log("");
    console.log(muted("No onboarding in progress."));
    console.log("");
    console.log(highlight("Start onboarding:"), 'harmony onboard start');
    console.log("");

    return {
      success: true,
      message: "No onboarding in progress",
      nextAction: 'Run "harmony onboard start" to begin',
    };
  }

  console.log(formatOnboardingProgress(progress));

  return {
    success: true,
    message: "Onboarding status displayed",
    data: { progress },
  };
}

/**
 * Advance to the next onboarding step.
 */
async function onboardNext(workspaceRoot: string): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    return {
      success: false,
      message: 'No onboarding in progress. Run "harmony onboard start" first.',
    };
  }

  if (progress.isComplete) {
    console.log("");
    console.log(success("🎉 You've already completed onboarding!"));
    console.log("");
    console.log(muted("Run 'harmony onboard reset' to start fresh."));
    console.log("");

    return {
      success: true,
      message: "Onboarding already complete",
    };
  }

  const current = getCurrentStep(progress);
  if (!current) {
    return {
      success: false,
      message: "No current step found",
    };
  }

  const spinner = createSpinner();
  let result: { success: boolean; message: string; progress: OnboardingProgress; celebration?: string; nextAction?: string };

  // Handle each step type
  switch (current.id) {
    case "welcome":
      if (current.status === "in_progress") {
        result = await completeWelcome(workspaceRoot, progress);
      } else {
        result = await startWelcome(workspaceRoot, progress);
      }
      break;

    case "environment_check":
      spinner.start("Checking environment...");
      result = await runEnvironmentCheck(workspaceRoot, progress);
      if (result.success) {
        spinner.succeed("Environment OK");
      } else {
        spinner.fail("Environment issues found");
      }
      break;

    case "first_status":
      if (current.status === "in_progress") {
        result = await completeFirstStatus(workspaceRoot, progress);
      } else {
        result = await guideFirstStatus(workspaceRoot, progress);
      }
      break;

    case "guided_fix":
      if (current.status === "in_progress" && current.taskId) {
        // Task exists, might be ready to complete
        result = await completeGuidedFix(workspaceRoot, progress);
      } else {
        result = await startGuidedFix(workspaceRoot, progress);
      }
      break;

    case "guided_feature":
      if (current.status === "in_progress" && current.taskId) {
        result = await completeGuidedFeature(workspaceRoot, progress);
      } else {
        result = await startGuidedFeature(workspaceRoot, progress);
      }
      break;

    case "review_pr":
    case "ship":
      if (current.status === "in_progress") {
        // Skip ahead
        updateStepStatus(workspaceRoot, progress, current.id, "completed");
        result = {
          success: true,
          message: "Step completed!",
          progress: advanceToNextStep(workspaceRoot, progress),
          celebration: `✅ ${current.title} done!`,
        };
      } else {
        result = await startShipStep(workspaceRoot, progress);
      }
      break;

    case "complete":
      result = await completeOnboarding(workspaceRoot, progress);
      break;

    default:
      result = {
        success: false,
        message: `Unknown step: ${current.id}`,
        progress,
      };
  }

  formatStepResult(result);

  return {
    success: result.success,
    message: result.message,
    data: { progress: result.progress },
    nextAction: result.nextAction,
  };
}

/**
 * Start a guided bug fix as part of onboarding.
 */
async function onboardFix(
  workspaceRoot: string,
  description: string
): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    return {
      success: false,
      message: 'No onboarding in progress. Run "harmony onboard start" first.',
    };
  }

  const current = getCurrentStep(progress);
  if (current?.id !== "guided_fix") {
    console.log("");
    console.log(warning(`You're currently on "${current?.title ?? "unknown"}".`));
    console.log(muted("Complete that step first, or run 'harmony onboard skip guided_fix' to jump ahead."));
    console.log("");

    return {
      success: false,
      message: "Not on the guided_fix step",
    };
  }

  const spinner = createSpinner();
  spinner.start("AI is analyzing the fix...");

  const result = await startGuidedFix(workspaceRoot, progress, description || undefined);

  if (result.success && description) {
    spinner.succeed("Fix spec created");
  } else {
    spinner.stop();
  }

  formatStepResult(result);

  return {
    success: result.success,
    message: result.message,
    data: { progress: result.progress },
    nextAction: result.nextAction,
  };
}

/**
 * Start a guided feature as part of onboarding.
 */
async function onboardFeature(
  workspaceRoot: string,
  description: string
): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    return {
      success: false,
      message: 'No onboarding in progress. Run "harmony onboard start" first.',
    };
  }

  const current = getCurrentStep(progress);
  if (current?.id !== "guided_feature") {
    console.log("");
    console.log(warning(`You're currently on "${current?.title ?? "unknown"}".`));
    console.log(muted("Complete that step first, or run 'harmony onboard skip guided_feature' to jump ahead."));
    console.log("");

    return {
      success: false,
      message: "Not on the guided_feature step",
    };
  }

  const spinner = createSpinner();
  spinner.start("AI is analyzing the feature...");

  const result = await startGuidedFeature(workspaceRoot, progress, description || undefined);

  if (result.success && description) {
    spinner.succeed("Feature spec created");
  } else {
    spinner.stop();
  }

  formatStepResult(result);

  return {
    success: result.success,
    message: result.message,
    data: { progress: result.progress },
    nextAction: result.nextAction,
  };
}

/**
 * Build the current onboarding task.
 */
async function onboardBuild(workspaceRoot: string): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    return {
      success: false,
      message: 'No onboarding in progress. Run "harmony onboard start" first.',
    };
  }

  const current = getCurrentStep(progress);
  if (!current?.taskId) {
    return {
      success: false,
      message: "No active task to build. Start a fix or feature first.",
    };
  }

  const spinner = createSpinner();
  spinner.start("AI is implementing...");

  const result = await buildOnboardingTask(workspaceRoot, progress);

  if (result.success) {
    spinner.succeed("Build complete");
  } else {
    spinner.fail("Build failed");
  }

  formatStepResult(result);

  return {
    success: result.success,
    message: result.message,
    data: { progress: result.progress },
    nextAction: result.nextAction,
  };
}

/**
 * Approve the current onboarding task and continue.
 */
async function onboardApprove(workspaceRoot: string): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    return {
      success: false,
      message: 'No onboarding in progress.',
    };
  }

  const current = getCurrentStep(progress);
  let result: { success: boolean; message: string; progress: OnboardingProgress; celebration?: string; nextAction?: string };

  // Complete the current step based on what it is
  if (current?.id === "guided_fix") {
    result = await completeGuidedFix(workspaceRoot, progress);
  } else if (current?.id === "guided_feature") {
    result = await completeGuidedFeature(workspaceRoot, progress);
  } else {
    // Generic approval - advance to next step
    updateStepStatus(workspaceRoot, progress, current?.id ?? "complete", "completed");
    result = {
      success: true,
      message: "Step approved!",
      progress: advanceToNextStep(workspaceRoot, progress),
      celebration: "✅ Approved!",
    };
  }

  formatStepResult(result);

  return {
    success: result.success,
    message: result.message,
    data: { progress: result.progress },
    nextAction: result.nextAction,
  };
}

/**
 * Skip to a specific step.
 */
async function onboardSkip(
  workspaceRoot: string,
  targetStep?: OnboardingStepType
): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    return {
      success: false,
      message: 'No onboarding in progress.',
    };
  }

  if (!targetStep) {
    // Skip current step
    const current = getCurrentStep(progress);
    if (!current) {
      return {
        success: false,
        message: "No current step to skip",
      };
    }

    updateStepStatus(workspaceRoot, progress, current.id, "skipped");
    const updated = advanceToNextStep(workspaceRoot, progress);

    console.log("");
    console.log(muted(`Skipped: ${current.title}`));

    const next = getCurrentStep(updated);
    if (next) {
      console.log(info(`Now on: ${next.title}`));
    }
    console.log("");

    return {
      success: true,
      message: `Skipped ${current.title}`,
      data: { progress: updated },
    };
  }

  // Skip to specific step
  const updated = skipToStep(workspaceRoot, progress, targetStep);
  const step = getCurrentStep(updated);

  console.log("");
  console.log(info(`Jumped to: ${step?.title ?? targetStep}`));
  console.log("");

  return {
    success: true,
    message: `Skipped to ${targetStep}`,
    data: { progress: updated },
  };
}

/**
 * Reset onboarding to start fresh.
 */
async function onboardReset(workspaceRoot: string): Promise<CommandResult> {
  const progress = loadOnboardingProgress(workspaceRoot);

  if (!progress) {
    console.log("");
    console.log(muted("No onboarding to reset."));
    console.log("");

    return {
      success: true,
      message: "No onboarding to reset",
    };
  }

  // Create fresh onboarding
  getOrCreateOnboarding(workspaceRoot, progress.userName);

  console.log("");
  console.log(success("Onboarding reset!"));
  console.log(muted('Run "harmony onboard start" to begin again.'));
  console.log("");

  return {
    success: true,
    message: "Onboarding reset",
    nextAction: 'Run "harmony onboard start" to begin',
  };
}

export const onboardHelp = {
  command: "onboard",
  description: "AI-assisted onboarding for new developers",
  usage: "harmony onboard [sub-command] [options]",
  options: [
    { flag: "--name <name>", description: "Your name (for personalization)" },
  ],
  examples: [
    "harmony onboard start",
    "harmony onboard start --name Alice",
    "harmony onboard status",
    "harmony onboard next",
    'harmony onboard fix "Fix typo in README"',
    'harmony onboard feature "Add log message"',
    "harmony onboard build",
    "harmony onboard approve",
    "harmony onboard skip",
    "harmony onboard reset",
  ],
  subCommands: [
    { name: "start", description: "Begin onboarding (or resume)" },
    { name: "status", description: "Show onboarding progress" },
    { name: "next", description: "Advance to the next step" },
    { name: "fix <desc>", description: "Start a guided bug fix" },
    { name: "feature <desc>", description: "Start a guided feature" },
    { name: "build", description: "Build the current onboarding task" },
    { name: "approve", description: "Approve and complete current step" },
    { name: "skip [step]", description: "Skip current or jump to a step" },
    { name: "reset", description: "Reset onboarding to start fresh" },
  ],
};

