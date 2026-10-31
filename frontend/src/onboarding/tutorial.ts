import type { OnboardingStorage } from "./seenTips";

/** The Tutorial Problem (GLOSSARY.md, docs/adr/0007), where every way into the Tutorial leads. */
export const TUTORIAL_PROBLEM_SLUG = "piggy-bank-total";

/**
 * The six steps of the Tutorial (GLOSSARY.md), in order: read the problem, the function, Run, read a
 * failure (only after a failing Run), Submit, Accepted.
 */
export const TUTORIAL_STEPS = ["read", "function", "run", "readFailure", "submit", "accepted"] as const;

export type TutorialStepName = (typeof TUTORIAL_STEPS)[number];

/**
 * Where the Tutorial stands in this browser. It never opens by itself: only `replayed` takes it out
 * of `notStarted`, `skipped` or `finished`.
 */
export type TutorialState =
  | { status: "notStarted" }
  | { status: "active"; step: TutorialStepName }
  | { status: "skipped" }
  | { status: "finished" };

/**
 * What happens to the Tutorial. `replayed` is every way in (the "How CodeBite works" link, and
 * later the landing call to action and the /problems banner): it starts at step 1 from anywhere.
 * `read` is the user moving past a reading step (1 or 2). `skipped` closes it; after the
 * celebration that is finishing it.
 */
export type TutorialEvent =
  | { type: "replayed" }
  | { type: "read" }
  | { type: "edited" }
  | { type: "ran"; passed: boolean }
  | { type: "submitted" }
  | { type: "accepted" }
  | { type: "skipped" };

export const NOT_STARTED: TutorialState = { status: "notStarted" };

const at = (step: TutorialStepName): TutorialState => ({ status: "active", step });

/** True while `step` comes before `limit`: the steps a later event may still move past. */
function before(step: TutorialStepName, limit: TutorialStepName): boolean {
  return TUTORIAL_STEPS.indexOf(step) < TUTORIAL_STEPS.indexOf(limit);
}

/** The Tutorial after `event`. It only moves forward, except that `replayed` starts it again. */
export function tutorialStep(state: TutorialState, event: TutorialEvent): TutorialState {
  if (event.type === "replayed") return at("read");
  if (state.status !== "active") return state;
  const { step } = state;
  switch (event.type) {
    case "read":
      return step === "read" ? at("function") : step === "function" ? at("run") : state;
    case "edited":
      return before(step, "run") ? at("run") : state;
    case "ran":
      // A Run made before editing counts as the Run step; a first Run that passes skips step 4.
      if (!before(step, "submit")) return state;
      return at(event.passed ? "submit" : "readFailure");
    case "submitted":
      return before(step, "submit") ? at("submit") : state;
    case "accepted":
      return at("accepted");
    case "skipped":
      return { status: step === "accepted" ? "finished" : "skipped" };
  }
}

const TUTORIAL_KEY = "onboarding-tutorial";

function isTutorialState(value: unknown): value is TutorialState {
  if (typeof value !== "object" || value == null) return false;
  const { status, step } = value as { status?: unknown; step?: unknown };
  if (status === "active") return (TUTORIAL_STEPS as readonly unknown[]).includes(step);
  return status === "notStarted" || status === "skipped" || status === "finished";
}

/**
 * The Tutorial as this browser left it. Storage that throws, holds nothing or holds something
 * unreadable means not started: it never opens by itself, so nothing is lost but a resume.
 */
export function readTutorial(storage: OnboardingStorage): TutorialState {
  try {
    const stored: unknown = JSON.parse(storage.getItem(TUTORIAL_KEY) ?? "null");
    return isTutorialState(stored) ? stored : NOT_STARTED;
  } catch {
    return NOT_STARTED;
  }
}

/**
 * Applies `event` to `current` (what the page holds; the stored Tutorial when left out), keeps the
 * result in storage and returns it. A write that fails is dropped: the page carries on with the
 * returned state, and a reload starts from what storage last kept.
 */
export function advanceTutorial(
  storage: OnboardingStorage,
  event: TutorialEvent,
  current: TutorialState = readTutorial(storage),
): TutorialState {
  const next = tutorialStep(current, event);
  try {
    storage.setItem(TUTORIAL_KEY, JSON.stringify(next));
  } catch {
    // storage full / disabled
  }
  return next;
}
