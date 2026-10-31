import client from "./client";
import type { TutorialMilestone } from "@/onboarding";

/**
 * Counts a Tutorial milestone on the server (`codebite.tutorial.milestones`), anonymously. Fire-and-forget:
 * a failed request is dropped, so it never affects the user.
 */
export function reportTutorialMilestone(milestone: TutorialMilestone): void {
  try {
    // eslint-disable-next-line no-restricted-syntax -- a lost milestone count is not the user's concern
    client.post(`/tutorial/milestones/${milestone}`).catch(() => {});
  } catch {
    // never let a counter break the Tutorial
  }
}
