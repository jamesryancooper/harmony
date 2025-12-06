/**
 * Onboarding state management and workflows.
 *
 * Provides AI-assisted onboarding that guides new developers through
 * their first tasks in Harmony.
 */

import { readFileSync, writeFileSync, existsSync, mkdirSync } from "node:fs";
import { join, dirname } from "node:path";
import type {
  OnboardingProgress,
  OnboardingStep,
  OnboardingStepType,
  OnboardingStepStatus,
  OnboardingStepResult,
  OnboardingCandidate,
  HarmonyTask,
  RiskTier,
} from "../types/index.js";
import {
  createTask,
  updateTask,
  getTask,
  getActiveTasks,
} from "./state.js";
import { buildTask, shipTask } from "./workflow.js";

const STATE_DIR = ".harmony";
const ONBOARDING_FILE = "onboarding.json";

// ============================================================================
// Default Onboarding Steps
// ============================================================================

const DEFAULT_STEPS: OnboardingStep[] = [
  {
    id: "welcome",
    title: "Welcome to Harmony",
    description: "Learn the mental model: you orchestrate, AI executes",
    status: "pending",
    estimatedMinutes: 2,
    guidance: `
Welcome to Harmony! Here's what you need to know:

• You describe what you want → AI does the heavy lifting
• You review and approve → AI ships it safely
• Complexity is hidden → You stay focused on outcomes

Let's get you productive in about 15 minutes.
    `.trim(),
  },
  {
    id: "environment_check",
    title: "Environment Check",
    description: "Verify your environment is set up correctly",
    status: "pending",
    estimatedMinutes: 1,
    guidance: `
Let's make sure everything is working:
• AI Runner: connected
• Git: clean working tree
• Project: recognized

If anything looks wrong, we'll help you fix it.
    `.trim(),
  },
  {
    id: "first_status",
    title: "Your First Command",
    description: "Learn to check on AI progress with 'harmony status'",
    status: "pending",
    estimatedMinutes: 1,
    guidance: `
The 'harmony status' command is your window into what's happening.
Run it anytime to see:
• Active tasks AI is working on
• Tasks waiting for your review
• System health

Try it now to see the current state.
    `.trim(),
  },
  {
    id: "guided_fix",
    title: "Guided Bug Fix",
    description: "Fix a real bug with AI assistance",
    status: "pending",
    estimatedMinutes: 5,
    guidance: `
Now let's fix a real bug together.
I'll guide you through each step:

1. AI generates a spec (you'll see a summary)
2. AI implements the fix
3. You review the result
4. You approve or ask for changes

This is a T1 (trivial) fix, so review will be quick.
    `.trim(),
  },
  {
    id: "guided_feature",
    title: "Add a Small Feature",
    description: "Add a feature with more complexity",
    status: "pending",
    estimatedMinutes: 8,
    guidance: `
Features are T2 (standard) by default, which means:
• AI does more thorough analysis
• You'll see a spec summary to review
• There's a feature flag for safe rollout

Let's add something small but useful.
    `.trim(),
  },
  {
    id: "review_pr",
    title: "Review a PR",
    description: "Learn to review AI-generated PRs effectively",
    status: "pending",
    estimatedMinutes: 3,
    guidance: `
When reviewing AI's work:

✓ Check the summary matches your intent
✓ Look for any warnings AI flagged
✓ Verify tests are passing
✓ Spot-check code if T2/T3

For T1: Summary is usually enough.
For T2: Read the spec summary and key changes.
For T3: Review everything carefully.
    `.trim(),
  },
  {
    id: "ship",
    title: "Ship to Production",
    description: "Deploy your changes safely",
    status: "pending",
    estimatedMinutes: 2,
    guidance: `
Shipping in Harmony is safe:

1. Features go behind flags (default OFF)
2. Deploy to preview first
3. Promote to production
4. Enable the flag gradually
5. Rollback instantly if needed

Let's ship what we built!
    `.trim(),
  },
  {
    id: "complete",
    title: "Onboarding Complete!",
    description: "You're ready to use Harmony",
    status: "pending",
    estimatedMinutes: 1,
    guidance: `
🎉 Congratulations! You've completed onboarding.

You now know how to:
• Start features and fixes
• Review AI's work
• Ship safely with flags
• Rollback if needed

Quick reference:
  harmony feature "what I want"
  harmony fix "bug description"
  harmony status
  harmony build
  harmony ship
  harmony explain "question"
  harmony rollback

See docs/harmony/human/START-HERE.md for more.
    `.trim(),
  },
];

// ============================================================================
// State Management
// ============================================================================

/**
 * Get the onboarding file path.
 */
export function getOnboardingPath(workspaceRoot: string): string {
  return join(workspaceRoot, STATE_DIR, ONBOARDING_FILE);
}

/**
 * Load onboarding progress from disk.
 */
export function loadOnboardingProgress(workspaceRoot: string): OnboardingProgress | null {
  const filePath = getOnboardingPath(workspaceRoot);

  if (!existsSync(filePath)) {
    return null;
  }

  try {
    const raw = readFileSync(filePath, "utf8");
    const parsed = JSON.parse(raw) as OnboardingProgress;

    // Convert date strings back to Date objects
    parsed.startedAt = new Date(parsed.startedAt);
    if (parsed.completedAt) {
      parsed.completedAt = new Date(parsed.completedAt);
    }
    parsed.steps = parsed.steps.map((step) => ({
      ...step,
      startedAt: step.startedAt ? new Date(step.startedAt) : undefined,
      completedAt: step.completedAt ? new Date(step.completedAt) : undefined,
    }));

    return parsed;
  } catch {
    return null;
  }
}

/**
 * Save onboarding progress to disk.
 */
export function saveOnboardingProgress(
  workspaceRoot: string,
  progress: OnboardingProgress
): void {
  const filePath = getOnboardingPath(workspaceRoot);
  const dir = dirname(filePath);

  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }

  writeFileSync(filePath, JSON.stringify(progress, null, 2), "utf8");
}

/**
 * Initialize a new onboarding session.
 */
export function initializeOnboarding(
  workspaceRoot: string,
  userName?: string
): OnboardingProgress {
  const progress: OnboardingProgress = {
    version: 1,
    startedAt: new Date(),
    currentStep: "welcome",
    steps: DEFAULT_STEPS.map((step) => ({ ...step })),
    userName,
    isComplete: false,
    totalMinutesSpent: 0,
  };

  saveOnboardingProgress(workspaceRoot, progress);
  return progress;
}

/**
 * Get or create onboarding progress.
 */
export function getOrCreateOnboarding(
  workspaceRoot: string,
  userName?: string
): OnboardingProgress {
  const existing = loadOnboardingProgress(workspaceRoot);
  if (existing && !existing.isComplete) {
    return existing;
  }
  return initializeOnboarding(workspaceRoot, userName);
}

/**
 * Get the current step details.
 */
export function getCurrentStep(progress: OnboardingProgress): OnboardingStep | null {
  return progress.steps.find((s) => s.id === progress.currentStep) ?? null;
}

/**
 * Get the next step after the current one.
 */
export function getNextStep(progress: OnboardingProgress): OnboardingStep | null {
  const currentIndex = progress.steps.findIndex((s) => s.id === progress.currentStep);
  if (currentIndex === -1 || currentIndex >= progress.steps.length - 1) {
    return null;
  }
  return progress.steps[currentIndex + 1];
}

/**
 * Update a step's status.
 */
export function updateStepStatus(
  workspaceRoot: string,
  progress: OnboardingProgress,
  stepId: OnboardingStepType,
  status: OnboardingStepStatus,
  taskId?: string
): OnboardingProgress {
  const step = progress.steps.find((s) => s.id === stepId);
  if (!step) return progress;

  step.status = status;

  if (status === "in_progress" && !step.startedAt) {
    step.startedAt = new Date();
  }

  if (status === "completed") {
    step.completedAt = new Date();
    if (step.startedAt) {
      progress.totalMinutesSpent += Math.round(
        (step.completedAt.getTime() - step.startedAt.getTime()) / 60000
      );
    }
  }

  if (taskId) {
    step.taskId = taskId;
  }

  saveOnboardingProgress(workspaceRoot, progress);
  return progress;
}

/**
 * Advance to the next step.
 */
export function advanceToNextStep(
  workspaceRoot: string,
  progress: OnboardingProgress
): OnboardingProgress {
  const nextStep = getNextStep(progress);
  if (nextStep) {
    progress.currentStep = nextStep.id;
  } else {
    progress.isComplete = true;
    progress.completedAt = new Date();
  }

  saveOnboardingProgress(workspaceRoot, progress);
  return progress;
}

// ============================================================================
// Onboarding Workflows
// ============================================================================

/**
 * Find suitable onboarding candidates from the codebase.
 */
export function findOnboardingCandidates(
  _workspaceRoot: string
): OnboardingCandidate[] {
  // TODO: In a real implementation, this would:
  // 1. Scan for labeled issues (good-first-issue, onboarding)
  // 2. Analyze codebase for simple improvements
  // 3. Check for common patterns (missing tests, typos, etc.)

  // For now, return some sensible defaults
  return [
    {
      type: "bug",
      title: "Fix a typo in documentation",
      reason: "Documentation-only, zero risk, perfect for learning the flow",
      tier: "T1",
      estimatedMinutes: 3,
    },
    {
      type: "bug",
      title: "Add missing error message",
      reason: "Simple code change, easy to verify, builds confidence",
      tier: "T1",
      estimatedMinutes: 5,
    },
    {
      type: "feature",
      title: "Add a helpful log message",
      reason: "Small feature, introduces observability concepts",
      tier: "T1",
      estimatedMinutes: 5,
    },
    {
      type: "feature",
      title: "Add input validation to an endpoint",
      reason: "Slightly more complex, good introduction to T2 workflows",
      tier: "T2",
      estimatedMinutes: 10,
    },
  ];
}

/**
 * Start the welcome step.
 */
export async function startWelcome(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  const step = getCurrentStep(progress);
  if (!step || step.id !== "welcome") {
    return {
      success: false,
      message: "Not on the welcome step",
      progress,
    };
  }

  updateStepStatus(workspaceRoot, progress, "welcome", "in_progress");

  return {
    success: true,
    message: step.guidance ?? "Welcome to Harmony!",
    progress,
    nextAction: 'Press Enter or run "harmony onboard next" to continue',
  };
}

/**
 * Complete the welcome step and move to environment check.
 */
export async function completeWelcome(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  updateStepStatus(workspaceRoot, progress, "welcome", "completed");
  const updated = advanceToNextStep(workspaceRoot, progress);

  return {
    success: true,
    message: "Great! Let's check your environment.",
    progress: updated,
    celebration: "✅ Step 1 complete!",
  };
}

/**
 * Run environment check.
 */
export async function runEnvironmentCheck(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  updateStepStatus(workspaceRoot, progress, "environment_check", "in_progress");

  // Check environment
  const checks = [
    { name: "Workspace", ok: existsSync(join(workspaceRoot, "package.json")) },
    { name: "State directory", ok: existsSync(join(workspaceRoot, ".harmony")) },
    { name: "Git", ok: existsSync(join(workspaceRoot, ".git")) },
  ];

  const allOk = checks.every((c) => c.ok);

  if (allOk) {
    updateStepStatus(workspaceRoot, progress, "environment_check", "completed");
    const updated = advanceToNextStep(workspaceRoot, progress);

    return {
      success: true,
      message: "Environment looks good!\n\n" + checks.map((c) => `  ✓ ${c.name}`).join("\n"),
      progress: updated,
      celebration: "✅ Environment verified!",
      nextAction: 'Run "harmony status" to see the current state',
    };
  }

  return {
    success: false,
    message:
      "Some checks failed:\n\n" +
      checks.map((c) => `  ${c.ok ? "✓" : "✗"} ${c.name}`).join("\n"),
    progress,
    nextAction: "Fix the issues above and run the check again",
  };
}

/**
 * Guide user through their first status command.
 */
export async function guideFirstStatus(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  const step = getCurrentStep(progress);
  if (!step || step.id !== "first_status") {
    return {
      success: false,
      message: "Not on the first_status step",
      progress,
    };
  }

  updateStepStatus(workspaceRoot, progress, "first_status", "in_progress");

  return {
    success: true,
    message: step.guidance ?? "Run 'harmony status' to see what's happening",
    progress,
    nextAction: 'Run "harmony status" now, then "harmony onboard next" to continue',
  };
}

/**
 * Complete the first status step.
 */
export async function completeFirstStatus(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  updateStepStatus(workspaceRoot, progress, "first_status", "completed");
  const updated = advanceToNextStep(workspaceRoot, progress);

  return {
    success: true,
    message: "You've learned the status command! Now let's fix something.",
    progress: updated,
    celebration: "✅ You can now check on AI progress anytime!",
  };
}

/**
 * Start a guided bug fix.
 */
export async function startGuidedFix(
  workspaceRoot: string,
  progress: OnboardingProgress,
  description?: string
): Promise<OnboardingStepResult> {
  const step = getCurrentStep(progress);
  if (!step || step.id !== "guided_fix") {
    return {
      success: false,
      message: "Not on the guided_fix step",
      progress,
    };
  }

  updateStepStatus(workspaceRoot, progress, "guided_fix", "in_progress");

  // If no description provided, suggest one
  if (!description) {
    const candidates = findOnboardingCandidates(workspaceRoot);
    const bugCandidate = candidates.find((c) => c.type === "bug" && c.tier === "T1");

    return {
      success: true,
      message: `${step.guidance}\n\nSuggested task: "${bugCandidate?.title ?? "Fix a typo in the README"}"`,
      progress,
      nextAction: `Run: harmony onboard fix "${bugCandidate?.title ?? "Fix a typo in the README"}"`,
    };
  }

  // Create a T1 fix task
  const task = createTask(workspaceRoot, {
    title: `[Onboarding] ${description}`,
    description: `Onboarding fix: ${description}`,
    tier: "T1",
    status: "planning",
    flagName: undefined, // T1 fixes usually don't need flags
  });

  updateStepStatus(workspaceRoot, progress, "guided_fix", "in_progress", task.id);

  return {
    success: true,
    message: `Great choice! AI is working on: "${description}"\n\nThis is a T1 (trivial) fix, so it will be quick.`,
    progress,
    nextAction: 'Run "harmony onboard build" to see AI implement it',
  };
}

/**
 * Build the current onboarding task.
 */
export async function buildOnboardingTask(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  const step = getCurrentStep(progress);
  if (!step || !step.taskId) {
    return {
      success: false,
      message: "No active onboarding task to build",
      progress,
    };
  }

  const task = getTask(workspaceRoot, step.taskId);
  if (!task) {
    return {
      success: false,
      message: "Task not found",
      progress,
    };
  }

  // Build the task
  const result = await buildTask(task.id);

  if (!result.success) {
    return {
      success: false,
      message: `Build failed: ${result.message}`,
      progress,
    };
  }

  // For onboarding, provide extra guidance about review
  const updatedTask = result.task ?? task;
  const reviewGuidance =
    updatedTask.tier === "T1"
      ? "Since this is T1, you can approve quickly after checking the summary."
      : "Take a moment to review the spec summary and code changes.";

  return {
    success: true,
    message: `Build complete!\n\n${reviewGuidance}`,
    progress,
    nextAction: 'Review the PR, then run "harmony onboard approve" to continue',
  };
}

/**
 * Complete the guided fix step.
 */
export async function completeGuidedFix(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  const step = progress.steps.find((s) => s.id === "guided_fix");
  if (!step?.taskId) {
    return {
      success: false,
      message: "No fix task to complete",
      progress,
    };
  }

  // Mark task as shipped
  const task = getTask(workspaceRoot, step.taskId);
  if (task) {
    updateTask(workspaceRoot, task.id, { status: "shipped" });
  }

  updateStepStatus(workspaceRoot, progress, "guided_fix", "completed");
  const updated = advanceToNextStep(workspaceRoot, progress);

  return {
    success: true,
    message: "You've completed your first bug fix with Harmony! 🎉",
    progress: updated,
    celebration: "✅ First fix shipped!",
    nextAction: "Now let's try a slightly bigger feature",
  };
}

/**
 * Start a guided feature.
 */
export async function startGuidedFeature(
  workspaceRoot: string,
  progress: OnboardingProgress,
  description?: string
): Promise<OnboardingStepResult> {
  const step = getCurrentStep(progress);
  if (!step || step.id !== "guided_feature") {
    return {
      success: false,
      message: "Not on the guided_feature step",
      progress,
    };
  }

  updateStepStatus(workspaceRoot, progress, "guided_feature", "in_progress");

  if (!description) {
    const candidates = findOnboardingCandidates(workspaceRoot);
    const featureCandidate = candidates.find((c) => c.type === "feature");

    return {
      success: true,
      message: `${step.guidance}\n\nSuggested task: "${featureCandidate?.title ?? "Add a helpful log message"}"`,
      progress,
      nextAction: `Run: harmony onboard feature "${featureCandidate?.title ?? "Add a helpful log message"}"`,
    };
  }

  // Create a T2 feature task (or T1 for simple ones)
  const tier: RiskTier = description.toLowerCase().includes("log") ? "T1" : "T2";
  const task = createTask(workspaceRoot, {
    title: `[Onboarding] ${description}`,
    description: `Onboarding feature: ${description}`,
    tier,
    status: "planning",
    flagName: tier === "T2" ? `feature.onboarding-${Date.now()}` : undefined,
  });

  updateStepStatus(workspaceRoot, progress, "guided_feature", "in_progress", task.id);

  return {
    success: true,
    message: `Feature started: "${description}"\n\nThis is ${tier === "T2" ? "T2 (standard)" : "T1 (trivial)"}, so AI will ${tier === "T2" ? "do more thorough analysis" : "be quick"}.`,
    progress,
    nextAction: 'Run "harmony onboard build" to see AI implement it',
  };
}

/**
 * Complete the guided feature step.
 */
export async function completeGuidedFeature(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  const step = progress.steps.find((s) => s.id === "guided_feature");
  if (!step?.taskId) {
    return {
      success: false,
      message: "No feature task to complete",
      progress,
    };
  }

  // Mark task as shipped
  const task = getTask(workspaceRoot, step.taskId);
  if (task) {
    updateTask(workspaceRoot, task.id, { status: "shipped" });
  }

  updateStepStatus(workspaceRoot, progress, "guided_feature", "completed");
  const updated = advanceToNextStep(workspaceRoot, progress);

  return {
    success: true,
    message: "Feature shipped! You're getting the hang of this. 🚀",
    progress: updated,
    celebration: "✅ First feature shipped!",
  };
}

/**
 * Start the ship step.
 */
export async function startShipStep(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  const step = getCurrentStep(progress);
  if (!step || (step.id !== "review_pr" && step.id !== "ship")) {
    return {
      success: false,
      message: "Not on a shipping-related step",
      progress,
    };
  }

  updateStepStatus(workspaceRoot, progress, step.id, "in_progress");

  return {
    success: true,
    message: step.guidance ?? "Let's ship your changes!",
    progress,
    nextAction: 'Run "harmony ship" to deploy',
  };
}

/**
 * Complete the onboarding.
 */
export async function completeOnboarding(
  workspaceRoot: string,
  progress: OnboardingProgress
): Promise<OnboardingStepResult> {
  // Complete any remaining steps and ensure time is accounted for
  for (const step of progress.steps) {
    if (step.status === "completed" || step.status === "skipped") continue;

    // If the step has started, treat it as completed so elapsed time is counted.
    // Otherwise, mark it as skipped so we don't artificially inflate time spent.
    if (step.startedAt) {
      updateStepStatus(workspaceRoot, progress, step.id, "completed");
    } else {
      updateStepStatus(workspaceRoot, progress, step.id, "skipped");
    }
  }

  progress.isComplete = true;
  progress.completedAt = new Date();
  progress.currentStep = "complete";

  saveOnboardingProgress(workspaceRoot, progress);

  const completeStep = progress.steps.find((s) => s.id === "complete");

  return {
    success: true,
    message: completeStep?.guidance ?? "Congratulations! You've completed onboarding.",
    progress,
    celebration: `
🎉 ONBOARDING COMPLETE! 🎉

You completed onboarding in ${progress.totalMinutesSpent} minutes.

You learned:
  ✓ How to check status with 'harmony status'
  ✓ How to fix bugs with AI assistance
  ✓ How to add features
  ✓ How to review and ship safely

You're now a Harmony developer!

Quick reference:
  harmony feature "what I want"
  harmony fix "bug description"  
  harmony status
  harmony build
  harmony ship
  harmony explain "question"
    `.trim(),
  };
}

/**
 * Skip to a specific step (for testing or resuming).
 */
export function skipToStep(
  workspaceRoot: string,
  progress: OnboardingProgress,
  targetStep: OnboardingStepType
): OnboardingProgress {
  const targetIndex = progress.steps.findIndex((s) => s.id === targetStep);
  if (targetIndex === -1) return progress;

  // Mark all previous steps as skipped
  for (let i = 0; i < targetIndex; i++) {
    if (progress.steps[i].status !== "completed") {
      progress.steps[i].status = "skipped";
    }
  }

  progress.currentStep = targetStep;
  saveOnboardingProgress(workspaceRoot, progress);

  return progress;
}

/**
 * Get onboarding progress summary.
 */
export function getProgressSummary(progress: OnboardingProgress): string {
  const completed = progress.steps.filter((s) => s.status === "completed").length;
  const total = progress.steps.length;
  const current = getCurrentStep(progress);

  const stepList = progress.steps
    .map((step) => {
      const icon =
        step.status === "completed"
          ? "✓"
          : step.status === "in_progress"
            ? "▶"
            : step.status === "skipped"
              ? "○"
              : "·";
      return `  ${icon} ${step.title}`;
    })
    .join("\n");

  return `
Onboarding Progress: ${completed}/${total} steps
${progress.isComplete ? "🎉 Complete!" : `Current: ${current?.title ?? "Unknown"}`}

${stepList}

Time spent: ${progress.totalMinutesSpent} minutes
  `.trim();
}

