# Plan: Refactor /problems List Page

## Context
The `/problems` page is a basic table with 3 columns (#, Title, Difficulty), a raw HTML difficulty filter, and Previous/Next pagination. It uses hardcoded light-mode colors and none of the shadcn components. We want to refactor it into a full-featured problem list (similar to LeetCode) with 8 features, each as an atomic commit.

## Feature Overview
1. Dark mode + shadcn components
2. Title search (server-side)
3. Sort options (clickable column headers)
4. Tags/topics (new entity + filtering)
5. Status column (solved/attempted/unsolved)
6. Acceptance rate column
7. Progress stats bar
8. Random problem button

---

## Feature 1: Dark mode + shadcn components

**Goal**: Replace hardcoded colors with theme-aware classes. Swap raw HTML elements for shadcn components.

**Files to modify:**
- `frontend/src/pages/ProblemListPage.tsx`

**Changes:**
- Replace `<select>` → shadcn `Select` / `SelectTrigger` / `SelectContent` / `SelectItem`
- Replace `<button>` pagination → shadcn `Button` (variant `outline`, size `sm`)
- Replace color classes:
  - `text-gray-900` → `text-foreground`
  - `bg-white` → `bg-card`
  - `bg-gray-50` → `bg-muted`
  - `border-gray-200` → `border-border`
  - `text-gray-500/600` → `text-muted-foreground`
  - `text-blue-600` → `text-primary`
  - `hover:bg-gray-50` → `hover:bg-muted/50`
- Note: Radix Select doesn't allow empty string values — use `"ALL"` for "All Difficulties" and convert to `undefined` when calling the API

**Verification:**
- `npm run build` passes
- Toggle light/dark — all colors adapt
- Difficulty filter and pagination still work

---

## Feature 2: Title search (server-side)

**Goal**: Add a search input that filters problems by title via the backend.

**Backend files:**
- `common/.../problem/repository/ProblemRepository.java` — add search queries
- `backend/.../problem/service/ProblemService.java` — add `search` param to `listPublishedProblems`
- `backend/.../problem/controller/ProblemController.java` — add `@RequestParam String search`

**Backend details:**

Add to `ProblemRepository`:
```java
@Query("SELECT p FROM Problem p WHERE p.published = true AND LOWER(p.title) LIKE LOWER(CONCAT('%', :search, '%'))")
Page<Problem> findByPublishedTrueAndTitleSearch(@Param("search") String search, Pageable pageable);

@Query("SELECT p FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty AND LOWER(p.title) LIKE LOWER(CONCAT('%', :search, '%'))")
Page<Problem> findByPublishedTrueAndDifficultyAndTitleSearch(@Param("difficulty") Difficulty difficulty, @Param("search") String search, Pageable pageable);
```

Update `ProblemService.listPublishedProblems(Difficulty difficulty, String search, Pageable pageable)` — branch on 4 combinations (difficulty × search).

**Frontend files:**
- `frontend/src/api/problems.ts` — add `search` param to `getProblems`
- `frontend/src/hooks/useProblems.ts` — add `search` param
- `frontend/src/pages/ProblemListPage.tsx` — add `Input` component with 300ms debounce, sync `search` to URL params

**Verification:**
- `./gradlew :backend:test` passes
- `npm run build` passes
- Typing "two" shows only matching problems
- Search + difficulty filter work together
- Search persists in URL across refresh

---

## Feature 3: Sort options

**Goal**: Allow sorting by clickable column headers with direction indicators.

**Backend files:**
- `backend/.../problem/controller/ProblemController.java` — validate sort fields against whitelist `{id, title, difficulty}`, keep `id,asc` as default

**Frontend files:**
- `frontend/src/api/problems.ts` — add `sort` param
- `frontend/src/hooks/useProblems.ts` — add `sort` param
- `frontend/src/pages/ProblemListPage.tsx` — create `SortableHeader` component, read/write `sort` URL param

**Details:**
- Sort param format: `"title,asc"` or `"difficulty,desc"`
- Clicking a header toggles direction; clicking a different header switches field
- Changing sort resets page to 0
- The whitelist is designed to be extended later (e.g., `acceptanceRate` in Feature 6)

**Verification:**
- `./gradlew :backend:test` passes
- `npm run build` passes
- Column headers sort correctly with direction arrows
- Sort + search + difficulty all compose correctly

---

## Feature 4: Tags/topics

**Goal**: Add topic tags to problems with tag-based filtering.

**New files:**
- `common/.../db/migration/V15__create_tags.sql` — `tags` table, `problem_tags` join table, seed data
- `common/.../problem/entity/Tag.java` — Tag entity (id, name, slug)
- `common/.../problem/repository/TagRepository.java`
- `backend/.../problem/dto/TagDto.java` — `record TagDto(String name, String slug)`
- `backend/.../problem/controller/TagController.java` — `GET /api/tags`
- `backend/.../problem/service/ProblemSpecifications.java` — JPA Specification builders
- `frontend/src/api/tags.ts` — `getTags()`
- `frontend/src/hooks/useTags.ts` — fetch tags on mount

**Modified files:**
- `common/.../problem/entity/Problem.java` — add `@ManyToMany Set<Tag> tags`
- `common/.../problem/repository/ProblemRepository.java` — extend `JpaSpecificationExecutor<Problem>`
- `backend/.../problem/dto/ProblemListItem.java` — add `List<String> tags`
- `backend/.../problem/service/ProblemService.java` — use Specifications for dynamic filtering (replaces manual branching from Feature 2), update `toListItem`
- `backend/.../problem/controller/ProblemController.java` — add `@RequestParam String tag`
- `backend/.../config/SecurityConfig.java` — add `GET /api/tags` to permitAll
- `frontend/src/types/problem.ts` — add `tags: string[]` to `ProblemListItem`
- `frontend/src/api/problems.ts` — add `tag` param
- `frontend/src/hooks/useProblems.ts` — add `tag` param
- `frontend/src/pages/ProblemListPage.tsx` — display tag badges in table, add tag filter chips

**Migration V15:**
```sql
CREATE TABLE tags (
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE problem_tags (
    problem_id BIGINT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    tag_id     BIGINT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (problem_id, tag_id)
);
INSERT INTO tags (name, slug) VALUES
    ('Array', 'array'), ('String', 'string'), ('Hash Table', 'hash-table'),
    ('Math', 'math'), ('Dynamic Programming', 'dynamic-programming'),
    ('Sorting', 'sorting'), ('Binary Search', 'binary-search'), ('Tree', 'tree'),
    ('Stack', 'stack'), ('Linked List', 'linked-list'), ('Two Pointers', 'two-pointers'),
    ('Recursion', 'recursion'), ('Graph', 'graph'), ('Greedy', 'greedy');
```

**JPA Specifications approach** (replaces combinatorial repository queries):
```java
public class ProblemSpecifications {
    public static Specification<Problem> isPublished() { ... }
    public static Specification<Problem> hasDifficulty(Difficulty d) { ... }
    public static Specification<Problem> titleContains(String search) { ... }
    public static Specification<Problem> hasTag(String tagSlug) { ... }
}
```
Compose in service: `Specification.where(isPublished()).and(hasDifficulty(d)).and(titleContains(s)).and(hasTag(t))`

**Verification:**
- `./gradlew :backend:test` passes
- `npm run build` passes
- Tags display as badges on problem rows
- Tag filter chips work alone and combined with search + difficulty
- `GET /api/tags` returns seeded tags

---

## Feature 5: Status column (solved/attempted/unsolved)

**Goal**: Show per-problem solve status for authenticated users.

**Modified files:**
- `common/.../submission/repository/SubmissionRepository.java` — add status aggregate query
- `backend/.../problem/dto/ProblemListItem.java` — add `String status` field
- `backend/.../problem/service/ProblemService.java` — accept optional `userId`, compute statuses
- `backend/.../problem/controller/ProblemController.java` — inject `@AuthenticationPrincipal JwtUserPrincipal` (nullable on permitAll routes)
- `frontend/src/types/problem.ts` — add `status?: "SOLVED" | "ATTEMPTED" | null`
- `frontend/src/pages/ProblemListPage.tsx` — add Status column (first column)

**Backend query:**
```java
@Query("SELECT s.problem.id, " +
       "CASE WHEN SUM(CASE WHEN s.status = 'ACCEPTED' THEN 1 ELSE 0 END) > 0 THEN 'SOLVED' " +
       "ELSE 'ATTEMPTED' END " +
       "FROM Submission s WHERE s.user.id = :userId GROUP BY s.problem.id")
List<Object[]> findProblemStatusesByUserId(@Param("userId") Long userId);
```
Convert to `Map<Long, String>` in service. Problems not in the map are unsolved.

**Frontend display:**
- Green checkmark (✓) for SOLVED
- Yellow/orange dot for ATTEMPTED
- Empty for null/unsolved
- Status only shows when user is authenticated (JWT interceptor auto-attaches token)

**Verification:**
- `./gradlew :backend:test` passes
- `npm run build` passes
- Unauthenticated: status column empty
- Authenticated: correct icons for solved/attempted problems

---

## Feature 6: Acceptance rate column

**Goal**: Show % of submissions accepted per problem.

**Modified files:**
- `common/.../submission/repository/SubmissionRepository.java` — add acceptance rate aggregate query
- `backend/.../problem/dto/ProblemListItem.java` — add `Double acceptanceRate`
- `backend/.../problem/service/ProblemService.java` — compute acceptance rates
- `frontend/src/types/problem.ts` — add `acceptanceRate: number | null`
- `frontend/src/pages/ProblemListPage.tsx` — add Acceptance column

**Backend query:**
```java
@Query("SELECT s.problem.id, COUNT(s), " +
       "SUM(CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED THEN 1 ELSE 0 END) " +
       "FROM Submission s WHERE s.status != com.codebite.submission.entity.SubmissionStatus.PENDING " +
       "GROUP BY s.problem.id")
List<Object[]> findAcceptanceRates();
```
Convert to `Map<Long, Double>` as `(accepted / total) * 100.0`. Problems with no submissions → `null`.

**Frontend display:** `XX.X%` or `—` for null.

**Note:** Sorting by acceptance rate is not supported since it's computed in memory, not a DB column. Can be added later with a DB view if needed.

**Verification:**
- `./gradlew :backend:test` passes
- `npm run build` passes
- Correct percentages for problems with submissions
- `—` for problems with no submissions

---

## Feature 7: Progress stats bar

**Goal**: Show "X / Y solved" breakdown by difficulty at the top of the page.

**New files:**
- `backend/.../problem/dto/ProblemStats.java` — `record ProblemStats(int totalEasy, int totalMedium, int totalHard, int solvedEasy, int solvedMedium, int solvedHard)`
- `frontend/src/hooks/useProblemStats.ts`

**Modified files:**
- `common/.../problem/repository/ProblemRepository.java` — add `countPublishedByDifficulty()` query
- `common/.../submission/repository/SubmissionRepository.java` — add `countSolvedByDifficultyAndUserId()` query
- `backend/.../problem/service/ProblemService.java` — add `getStats(Long userId)` method
- `backend/.../problem/controller/ProblemController.java` — add `GET /api/problems/stats` endpoint
- `frontend/src/api/problems.ts` — add `getProblemStats()`
- `frontend/src/types/problem.ts` — add `ProblemStats` interface
- `frontend/src/pages/ProblemListPage.tsx` — render progress bar above the table

**SecurityConfig note:** `/api/problems/stats` already matches the existing `GET /api/problems/*` permitAll rule (Spring `*` matches single path segments).

**Frontend display:**
- Card above the table with total "X / Y Solved"
- Three colored segments: Easy (green), Medium (yellow), Hard (red) with `solvedX / totalX`
- Unauthenticated: solved counts are 0, show "Sign in to track progress" or just totals

**Verification:**
- `./gradlew :backend:test` passes
- `npm run build` passes
- Correct totals and solved counts
- Works for both authenticated and unauthenticated users

---

## Feature 8: Random problem button

**Goal**: Navigate to a random problem on button click.

**Modified files:**
- `common/.../problem/repository/ProblemRepository.java` — add random slug queries
- `backend/.../problem/service/ProblemService.java` — add `getRandomProblemSlug(Difficulty, Long userId)`
- `backend/.../problem/controller/ProblemController.java` — add `GET /api/problems/random`
- `frontend/src/api/problems.ts` — add `getRandomProblem(difficulty?)`
- `frontend/src/pages/ProblemListPage.tsx` — add random button with shuffle/dice icon

**Backend queries:**
```java
@Query("SELECT p.slug FROM Problem p WHERE p.published = true ORDER BY RANDOM()")
List<String> findRandomPublishedSlugs(Pageable pageable);  // use PageRequest.of(0, 1)

@Query("SELECT p.slug FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty ORDER BY RANDOM()")
List<String> findRandomPublishedSlugsByDifficulty(@Param("difficulty") Difficulty difficulty, Pageable pageable);

@Query("SELECT p.slug FROM Problem p WHERE p.published = true " +
       "AND p.id NOT IN (SELECT DISTINCT s.problem.id FROM Submission s WHERE s.user.id = :userId AND s.status = 'ACCEPTED') " +
       "ORDER BY RANDOM()")
List<String> findRandomUnsolvedSlugs(@Param("userId") Long userId, Pageable pageable);
```

**Logic:** For authenticated users, try unsolved first; if none remain, fall back to any random. Respects current difficulty filter.

**Frontend:** Button with shuffle icon in the header area. On click → call API → `navigate(/problems/${slug})`. Show loading state on button during request.

**Verification:**
- `./gradlew :backend:test` passes
- `npm run build` passes
- Clicking random navigates to a problem detail page
- With difficulty filter set, picks from that difficulty
- Authenticated users get unsolved problems preferentially

---

## Files Summary

| Feature | Migration | Backend New | Backend Modify | Frontend New | Frontend Modify |
|---------|-----------|------------|----------------|--------------|-----------------|
| 1 | — | — | — | — | ProblemListPage |
| 2 | — | — | ProblemRepo, ProblemService, ProblemController | — | problems API, useProblems, ProblemListPage |
| 3 | — | — | ProblemController | — | problems API, useProblems, ProblemListPage |
| 4 | V15 | Tag entity, TagRepo, TagDto, TagController, ProblemSpecifications | Problem entity, ProblemRepo, ProblemListItem, ProblemService, ProblemController, SecurityConfig | tags API, useTags | problem types, problems API, useProblems, ProblemListPage |
| 5 | — | — | SubmissionRepo, ProblemListItem, ProblemService, ProblemController | — | problem types, ProblemListPage |
| 6 | — | — | SubmissionRepo, ProblemListItem, ProblemService | — | problem types, ProblemListPage |
| 7 | — | ProblemStats DTO, useProblemStats hook | ProblemRepo, SubmissionRepo, ProblemService, ProblemController | useProblemStats | problems API, problem types, ProblemListPage |
| 8 | — | — | ProblemRepo, ProblemService, ProblemController | — | problems API, ProblemListPage |

## Verification (end-to-end)
1. `./gradlew :backend:test` — all backend tests pass
2. `cd frontend && npm run build` — frontend compiles with no type errors
3. Manual: dark/light toggle works on the page
4. Manual: search "two" + filter by EASY + sort by title → correct filtered, sorted results
5. Manual: click a tag chip → filters by that tag
6. Manual: login → see status icons and solved progress bar
7. Manual: click random → navigates to a problem
