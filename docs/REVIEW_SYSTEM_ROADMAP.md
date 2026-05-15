# CodeBite Review System — Roadmap (post-v2)

## Context

The spaced-repetition review system shipped in two passes:

- **v1** — per-problem confidence ratings, SM-2 lite scheduler, due-for-review widget on the profile page, informational badge on the description tab.
- **v2** — refactored ratings to be per-submission (1:1 with `submissions`), added the confetti + modal flow on accepted submissions, structured `solve_time_seconds` capture from the existing timer widget, edit-rating-from-detail flow.

See `docs/SYSTEM_DESIGN.md` for the current schema and live API.

This roadmap covers the four work items deferred from v1/v2. Each is **scoped independently** — pick one and implement without depending on the others. Listed in suggested execution order (impact × cost).

---

## 1. Per-problem progression timeline

**Why**: This was an explicit goal during the v2 design conversation — _"so the user can see: 'last month, when I first solved this question I gave Hard, last week was Good, today it was Easy, I'm clearly progressing'"_. Today the per-row chip in `SubmissionsPanel` shows the data, but the *progression* itself is not visualized — the user has to scan a column. This makes it pop.

### UX

A compact horizontal strip in `DescriptionPanel`, just below the existing `ReviewBadge`:

```
Progression:  ▣ Hard  ▣ Hard  ▣ Good  ▣ Easy   (4 reviews)
              Mar 1   Mar 18  Apr 12  May 3
```

- Each pill colored by rating (same palette as the chip column).
- Hovering shows the language + status of the underlying submission.
- Clicking a pill switches the left tab to Submissions and opens that submission's detail panel.

### Data

No schema change. Data already exists on `submissions` (`confidence`, `reviewed_at`, `language`, `status`).

### Backend

- New: `ReviewService.getReviewHistory(slug, userId)` returning a list of `{submissionId, confidence, reviewedAt, language, status}` ordered by `reviewed_at` ascending.
- New DTO: `RatingHistoryItem`.
- New endpoint: `GET /api/problems/{slug}/review-history` (JWT, 200 + array; empty array if none).

### Frontend

- New: `frontend/src/components/review/ProgressionStrip.tsx` — pure presentation component taking the history array + an `onPillClick(submissionId)` callback.
- New: `getReviewHistory(slug)` in `api/reviews.ts`.
- Extend `useReviewState` (or a sibling `useReviewHistory` hook) to fetch history alongside the badge state.
- Wire into `DescriptionPanel.tsx`. The click handler needs a way to bubble up to `LeftPanel` to switch tabs and select a submission — same pattern as the existing `onLoadIntoEditor` callback prop chain.

### Reuse

- Color palette already defined in `SubmissionsPanel.tsx` (`confidenceChipClass`) — extract to a shared `lib/confidenceColors.ts` and reuse in both places.
- The `Submissions` tab + `SubmissionDetail` overlay flow in `LeftPanel.tsx` is the existing pattern for "open a submission from elsewhere."

### Estimate

~1-2 hours. No new dependencies.

---

## 2. Reviews stats page (`/reviews`)

**Why**: Dedicated home for browsing history, spotting weak tags, and seeing time investment trends. Replaces the placeholder "View all" link on `DueReviewsCard`.

### UX

New route `/reviews` (auth-required). Four sections, top to bottom:

1. **Header summary cards** — total ratings, current streak (consecutive days with ≥1 rating), longest streak, total solve time across rated submissions.
2. **Calendar heatmap** of reviews per day for the past year. Mirrors the existing activity heatmap visually.
3. **Per-tag confidence distribution** — one row per tag, stacked horizontal bar with segments for AGAIN / HARD / GOOD / EASY counts. "You're weak in DP" should be obvious at a glance.
4. **Filterable history feed** — paginated list of all rated submissions. Filters: due / overdue / mastered, by tag, by difficulty, by confidence. Each row: problem title (link), language chip, confidence chip, reviewed-at, solve-time, "Open" affordance.

### Data

No schema change. Three new aggregation queries on `submissions`:

- Daily review counts: `SELECT CAST(reviewed_at AS LocalDate), COUNT(*) FROM submissions WHERE user_id=? AND confidence IS NOT NULL AND reviewed_at >= ? GROUP BY 1`.
- Per-tag confidence distribution: join `submissions × problem_tags × tags`, group by tag + confidence.
- History feed: filtered scan of `submissions` joined to `problem`.

Streak computation can run client-side from the daily heatmap data — saves a round trip.

### Backend

- `ReviewService.getStats(userId)` → totals + total solve-time-seconds.
- `ReviewService.getReviewActivity(userId, sinceMonths)` → daily counts.
- `ReviewService.getTagConfidenceDistribution(userId)` → `{tagSlug, tagName, again, hard, good, easy}[]`.
- `ReviewService.getReviewHistory(userId, filters, page, size)` → `Page<ReviewHistoryItem>`.
- Endpoints (all JWT):
  - `GET /api/reviews/stats`
  - `GET /api/reviews/activity?months=12`
  - `GET /api/reviews/tag-confidence`
  - `GET /api/reviews/history?status=&tag=&difficulty=&confidence=&page=&size=`

### Frontend

- New: `frontend/src/pages/reviews/ReviewsPage.tsx` and route entry.
- New: `ReviewActivityHeatmap.tsx` — likely a copy-and-tweak of `frontend/src/pages/profile/ActivityHeatmap.tsx` (or refactor that one to take a data-source prop and reuse).
- New: `TagConfidenceChart.tsx` — see open question below.
- New: `ReviewHistoryList.tsx` — paginated list with filter controls.
- New: `frontend/src/api/reviews.ts` additions for the four endpoints.
- Update: `DueReviewsCard.tsx` "View all" link → `/reviews`.

### Reuse

- `ActivityHeatmap.tsx` from the profile page is the established heatmap pattern.
- `Pagination.tsx` from `components/ui/`.
- `DifficultyBadge`, `StatusBadge`, and the confidence color palette.

### Open question

Chart library decision for the per-tag distribution. Two paths:

- **Hand-rolled SVG stacked bars** — zero deps, ~30 lines, matches the rest of the UI (no recharts elsewhere yet). Good enough for ≤13 tags.
- **Add `recharts`** (~70KB gzipped) — only worth it if other charts land soon (e.g., solve-time-trend per problem).

Default: hand-rolled until a second chart appears.

### Estimate

1-2 days. Largest single item on this list.

---

## 3. Recommendation feed beyond the raw due list

**Why**: Move from "what's due" to "what to do next." Two surfaces, both **revision-only** (per the v1 decision — no new-problem suggestions).

### UX

Add to the profile page, alongside `DueReviewsCard` and `RecentSubmissionsCard`. Could be one card with two sub-sections, or split into two cards.

- **Weak categories** (top 3 tags by lowest avg confidence): _"Dynamic Programming — avg Hard, 5 solved problems"_. Each row links to a filtered review-history view (`/reviews?tag=dynamic-programming`) once the stats page exists, or to `/problems?tag=dynamic-programming&status=SOLVED` until then.
- **Roadmap next**: leverage the existing `RoadmapCategory` + prerequisites entity (`common/src/main/java/com/codebite/roadmap/entity/RoadmapCategory.java`). Suggest the next category whose prerequisites the user has solved. Useful for sequencing.

### Data

No schema change. Aggregations:

- Per-tag avg confidence: map enum to numeric (AGAIN=1, HARD=2, GOOD=3, EASY=4), average per tag, sort ascending.
- Roadmap next: existing roadmap query, filtered by "all prerequisites solved AND this category not yet fully covered."

### Backend

- `RecommendationService` (new):
  - `getWeakTags(userId, limit)` → `{tagSlug, tagName, avgConfidence, ratedProblemCount}[]`.
  - `getRoadmapNext(userId)` → list of suggested categories/problems.
- Endpoints: `GET /api/recommendations/weak-tags`, `GET /api/recommendations/roadmap-next`.

### Frontend

- `frontend/src/pages/profile/WeakCategoriesCard.tsx`.
- `frontend/src/pages/profile/RoadmapNextCard.tsx`.
- Or fold both into a single `RecommendationsCard.tsx`.

### Open question

Should "Weak categories" suggest *the specific solved problem* to revisit (e.g., the one with the lowest confidence in that tag), or just the tag with a count? The latter is simpler and lets the user choose; the former is more directive. Default: just the tag for v1, refine later.

### Estimate

~half-day to a day, depending on roadmap query complexity.

### Dependency

Easier to build *after* the stats page (#2) — many of the same queries; cards can just deep-link into stats views.

---

## 4. Polish — small standalone improvements

Each ships in 1-2 hours. Pick opportunistically.

### 4a. "Mastered" badge

- A problem is **Mastered** once `problem_review_state.review_count >= 3` AND the last 2+ ratings (read from `submissions`) are GOOD or EASY AND `interval_days >= 30`.
- Add `mastered BOOLEAN` to `problem_review_state`, computed during the existing replay in `ReviewService.replayState`.
- Show a small ★ in the `ReviewBadge` and next to the problem title in `SubmissionsPanel` rows.
- Optional: do not pop the post-accept modal for Mastered problems (or change copy: _"Just keeping it sharp."_).

### 4b. Review streak pill

- Already computed for the stats page header. Surface a small "🔥 5d" pill near `DueReviewsCard` on the profile.
- Lightweight; no separate endpoint if `/api/reviews/stats` exists.

### 4c. Clear rating (undo)

- Today: rating is editable but not erasable. If the user mis-clicked, they're stuck cycling through ratings.
- New: "Clear rating" affordance in `ConfidencePrompt` edit mode (visible only when `currentRating != null`).
- Add `DELETE /api/submissions/{id}/review` — clears `confidence` + `reviewed_at` on the submission, triggers `replayState` (which may delete the `problem_review_state` row if this was the only rating).
- Existing replay logic in `ReviewService` already handles the empty-replay case (`stateRepository.deleteByUserIdAndProblemId`).

---

## Intentionally not planned

For the record:

- **CSV export** of review history — declined.
- **Bulk import** of the existing markdown note as backfilled ratings — declined.
- **Manual reviews not tied to a submission** — decided against in v2; reviews are strictly per-submission.
- **New-problem suggestions** in weak categories — v1 decided revision-only, still holds.

---

## Working order

1. **#1 Progression timeline** — smallest, highest-visibility, addresses the explicit "I'm clearly progressing" goal.
2. **#2 Stats page** — biggest payoff but biggest build; tackle when ready for a multi-day push.
3. **#3 Recommendations** — best built after #2 since it shares queries and links into stats views.
4. **#4 Polish** — drop in opportunistically, no ordering dependency.
