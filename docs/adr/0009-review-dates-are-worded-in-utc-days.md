# Review dates are worded in UTC calendar days

A review's next due moment is an instant (the last review plus its interval). Wherever the frontend puts it into words (the review badge, the Accepted modal, the due-reviews card), "today", "tomorrow" and "in N days" count UTC calendar days between now and that moment, and so do "today", "yesterday" and "N days ago" for the last review. A date shown beside the words, such as the modal's "Mon, Nov 2", is the moment's UTC date. This is the rule ADR 0001 set for Streak Days, so a review due "tomorrow" falls on the same day as tomorrow's Streak Day and GitHub square. The count lives in one module, `frontend/src/lib/dueWording.ts`.

"Due now" appears only once the due moment is at or before now (GLOSSARY's **Due**), the same moment the backend's due list uses. "Overdue by N days" is the server's whole-day count (`daysOverdue`, on both the due list and the review state), not a count made in the browser, so the badge and the card agree.

## Considered Options

- **Whole 24-hour blocks from now.** What the badge used to do. Right after a rating with a 2-day interval it said "tomorrow", and it said "Due now" for anything due within 24 hours, before the problem was on the due list.
- **The user's local calendar.** It matches the user's day, but it would put a review's day and a Streak Day on different dates for every submission between 00:00 and 09:00 KST, which is the disagreement ADR 0001 rejected.

## Consequences

For Korean users a review's day ends at 09:00 KST, so a problem reviewed on an evening in KST still reads "reviewed today" the next morning until 09:00. Wording a review date in the browser's time zone, or by dividing by 24 hours, reintroduces the disagreement this decision fixed.
