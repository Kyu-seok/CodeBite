import client from "./client";
import type { TutorialMilestone } from "@/onboarding";

/**
 * Counts a Tutorial step on the server (`codebite.tutorial.steps`), anonymously. Fire-and-forget:
 * a failed request is dropped, so it never affects the user.
 */
export function reportTutorialStep(step: TutorialMilestone): void {
  try {
    // eslint-disable-next-line no-restricted-syntax -- a lost step count is not the user's concern
    client.post(`/tutorial/steps/${step}`).catch(() => {});
  } catch {
    // never let a counter break the Tutorial
  }
}
