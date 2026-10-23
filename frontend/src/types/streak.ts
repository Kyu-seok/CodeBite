/** The signed-in user's Streak. Mirrors the backend `StreakSummary`. */
export interface StreakSummary {
  currentStreak: number;
  bestStreak: number;
  /** False until today (UTC) has an Accepted submission; drives the greyed-out nav flame. */
  solvedToday: boolean;
  repairs: number;
  /** Streak Days toward the next Repair, 0–4. */
  repairProgress: number;
}

export interface StreakCalendarDay {
  /** `YYYY-MM-DD`, a UTC date. */
  date: string;
  repaired: boolean;
}

/**
 * One month of the Streak calendar. Days missing from `days` that fall after
 * `firstStreakDate` and before `today` are Missed Days.
 */
export interface StreakCalendar {
  /** `YYYY-MM` */
  month: string;
  today: string;
  firstStreakDate: string | null;
  days: StreakCalendarDay[];
}
