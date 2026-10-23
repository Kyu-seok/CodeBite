import client from "./client";
import type { StreakCalendar, StreakSummary } from "../types/streak";

export function getStreak() {
  return client.get<StreakSummary>("/streak");
}

/** `month` is `YYYY-MM`. */
export function getStreakCalendar(month: string) {
  return client.get<StreakCalendar>("/streak/days", { params: { month } });
}

/** Spends one Repair on a Missed Day (`YYYY-MM-DD`). */
export function repairStreakDay(date: string) {
  return client.post<StreakSummary>("/streak/repairs", { date });
}

/** Fired on `window` whenever the user's Streak may have changed. */
export const STREAK_CHANGED_EVENT = "codebite:streak-changed";

export function notifyStreakChanged() {
  window.dispatchEvent(new Event(STREAK_CHANGED_EVENT));
}
