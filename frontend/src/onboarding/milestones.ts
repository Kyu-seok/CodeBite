import { readStored, writeStored, type OnboardingStorage } from "./storage";
import type { TutorialEvent, TutorialState } from "./tutorial";

/**
 * What the Tutorial reports, so the milestone counters (`codebite.tutorial.milestones`) show where
 * newcomers drop off. Only the milestone name leaves the browser.
 */
export const TUTORIAL_MILESTONES = ["started", "ran", "submitted", "accepted", "skipped"] as const;

export type TutorialMilestone = (typeof TUTORIAL_MILESTONES)[number];

/**
 * The milestone the Tutorial reached when `event` moved it from `before` to `after`, or null.
 * Runs and Submits count only while the Tutorial is under way, before its celebration; closing it
 * after the celebration is finishing it, not skipping.
 */
export function tutorialMilestone(
  before: TutorialState,
  event: TutorialEvent,
  after: TutorialState,
): TutorialMilestone | null {
  if (event.type === "replayed") return "started";
  const underWay = before.status === "active" && before.step !== "accepted";
  if (!underWay) return null;
  if (event.type === "ran") return "ran";
  if (event.type === "submitted") return "submitted";
  if (after.status === "active" && after.step === "accepted") return "accepted";
  if (after.status === "skipped") return "skipped";
  return null;
}

const REPORTED_KEY = "onboarding-tutorial-reported";

function isMilestone(value: unknown): value is TutorialMilestone {
  return (TUTORIAL_MILESTONES as readonly unknown[]).includes(value);
}

function readReported(storage: OnboardingStorage): TutorialMilestone[] {
  return readStored(storage, REPORTED_KEY, (stored) => (Array.isArray(stored) ? stored.filter(isMilestone) : []), []);
}

/**
 * The milestone to report for this move, or null: each milestone once per run of the Tutorial
 * (a restart begins a new run), remembered in `storage` across page loads. Storage that fails
 * means a milestone may be reported twice, never that it goes unreported.
 */
export function milestoneToReport(
  storage: OnboardingStorage,
  before: TutorialState,
  event: TutorialEvent,
  after: TutorialState,
): TutorialMilestone | null {
  const milestone = tutorialMilestone(before, event, after);
  if (milestone == null) return null;
  const reported = milestone === "started" ? [] : readReported(storage);
  if (reported.includes(milestone)) return null;
  writeStored(storage, REPORTED_KEY, [...reported, milestone]);
  return milestone;
}
