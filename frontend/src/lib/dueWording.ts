/** What the due-reviews card says about a review's due date, as an i18n key and its values. */
export type DueWording =
  | { key: "dueReviews.overdue"; count: number }
  | { key: "dueReviews.dueNow" }
  | { key: "dueReviews.due"; when: string };

const DAY_MS = 86_400_000;

/** The UTC day number a timestamp falls on. Reviews count whole UTC days, following ADR 0001's rule for Streak Days. */
const utcDay = (time: number) => Math.floor(time / DAY_MS);

/**
 * Words for a review due at `nextDueAt`, seen at `now` (epoch ms). `daysOverdue` is the server's
 * whole-day count; at 1 or more the review reads as overdue. A future due date reads as today,
 * tomorrow or in N days by UTC calendar day, never by 24-hour blocks from now.
 */
export function dueWording(
  nextDueAt: string,
  daysOverdue: number,
  now: number,
  locale: string,
): DueWording {
  if (daysOverdue >= 1) return { key: "dueReviews.overdue", count: daysOverdue };
  const due = new Date(nextDueAt).getTime();
  if (due <= now) return { key: "dueReviews.dueNow" };
  const relative = new Intl.RelativeTimeFormat(locale, { numeric: "auto" });
  return { key: "dueReviews.due", when: relative.format(utcDay(due) - utcDay(now), "day") };
}
