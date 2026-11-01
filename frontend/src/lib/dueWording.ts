/**
 * Every review date the frontend words counts whole UTC calendar days, following ADR 0001's rule
 * for Streak Days (docs/adr/0009), never 24-hour blocks from now. This module is the only place
 * that count lives.
 */

const DAY_MS = 86_400_000;

/** The UTC day number a timestamp falls on. */
const utcDay = (time: number) => Math.floor(time / DAY_MS);

/** Where a review's due moment stands at `now`. */
type DueStanding =
  | { kind: "overdue"; days: number }
  | { kind: "dueNow" }
  | { kind: "upcoming"; days: number };

/**
 * `daysOverdue` is the server's whole-day count; at 1 or more the review is overdue. Otherwise it
 * is due now once the due moment is at or before now (GLOSSARY's Due), and upcoming in N UTC
 * calendar days (0 = later today) before that.
 */
function dueStanding(nextDueAt: string, daysOverdue: number, now: number): DueStanding {
  if (daysOverdue >= 1) return { kind: "overdue", days: daysOverdue };
  const due = new Date(nextDueAt).getTime();
  if (due <= now) return { kind: "dueNow" };
  return { kind: "upcoming", days: utcDay(due) - utcDay(now) };
}

/** What the due-reviews card says about a review's due date, as an i18n key and its values. */
export type DueWording =
  | { key: "dueReviews.overdue"; count: number }
  | { key: "dueReviews.dueNow" }
  | { key: "dueReviews.due"; when: string };

/** Words for the due-reviews card for a review due at `nextDueAt`, seen at `now` (epoch ms). */
export function dueWording(
  nextDueAt: string,
  daysOverdue: number,
  now: number,
  locale: string,
): DueWording {
  const standing = dueStanding(nextDueAt, daysOverdue, now);
  if (standing.kind === "overdue") return { key: "dueReviews.overdue", count: standing.days };
  if (standing.kind === "dueNow") return { key: "dueReviews.dueNow" };
  const relative = new Intl.RelativeTimeFormat(locale, { numeric: "auto" });
  return { key: "dueReviews.due", when: relative.format(standing.days, "day") };
}

/** What the review badge says about a review's due date, as an i18n key and its values. */
export type BadgeDueWording =
  | { key: "review.badge.overdue"; count: number }
  | { key: "review.badge.dueNow" }
  | { key: "review.badge.dueToday" }
  | { key: "review.badge.dueTomorrow" }
  | { key: "review.badge.dueIn"; count: number };

/** Words for the review badge, by the same rule as the due-reviews card. */
export function badgeDueWording(nextDueAt: string, daysOverdue: number, now: number): BadgeDueWording {
  const standing = dueStanding(nextDueAt, daysOverdue, now);
  if (standing.kind === "overdue") return { key: "review.badge.overdue", count: standing.days };
  if (standing.kind === "dueNow") return { key: "review.badge.dueNow" };
  if (standing.days === 0) return { key: "review.badge.dueToday" };
  if (standing.days === 1) return { key: "review.badge.dueTomorrow" };
  return { key: "review.badge.dueIn", count: standing.days };
}

/** What the review badge says about when a problem was last reviewed. */
export type LastReviewedWording =
  | { key: "review.badge.today" }
  | { key: "review.badge.yesterday" }
  | { key: "review.badge.daysAgo"; count: number }
  | { key: "review.badge.monthsAgo"; count: number };

/** Words for a review made at `reviewedAt`, seen at `now` (epoch ms), counted in UTC calendar days. */
export function lastReviewedWording(reviewedAt: string, now: number): LastReviewedWording {
  const days = utcDay(now) - utcDay(new Date(reviewedAt).getTime());
  if (days < 1) return { key: "review.badge.today" };
  if (days === 1) return { key: "review.badge.yesterday" };
  if (days < 30) return { key: "review.badge.daysAgo", count: days };
  return { key: "review.badge.monthsAgo", count: Math.floor(days / 30) };
}

/** The calendar date a review is due on, as in "Mon, Nov 2": the UTC date, the day the words above count to. */
export function dueDateLabel(nextDueAt: string, locale: string): string {
  return new Date(nextDueAt).toLocaleDateString(locale, {
    weekday: "short",
    month: "short",
    day: "numeric",
    timeZone: "UTC",
  });
}
