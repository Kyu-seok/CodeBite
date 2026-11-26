# Frontend layout

Which directory of `frontend/src/` holds what. Open it to find where a module lives or where a new one goes; the rules an `ls` would not tell you are the Frontend gotchas in CLAUDE.md.

- `api/` — Axios client (`client.ts`, JWT interceptor) and one module per backend area (auth, problems, submissions, reviews, streak, github, profile, roadmap, recommendations, solutions, tags, tutorial, user, admin)
- `types/` — TypeScript interfaces matching backend DTOs
- `context/` — AuthContext (JWT auth state + localStorage persistence)
- `components/layout/` — Layout (nav bar), ProtectedRoute; `components/ui/` — primitives (Badge, Button, Card, Dialog, DifficultyBadge, StatusBadge, Spinner, Tabs, …); `components/markdown/` — the description renderer and its `diagrams/`; `components/review/` — the rating widgets; `components/walkthrough/` — the Walkthrough player, a verbatim copy of the walkthrough kit (never edited here: `scripts/copy-walkthrough-kit.py` copies it in and records the kit commit in its `KIT_VERSION.json`)
- `judge/` — `watchSubmission.ts`: how a Verdict is awaited (SSE, polling as the fallback)
- `pages/` — LoginPage, OAuthCallbackPage, GitHubCallbackPage, ProblemListPage, NotFoundPage, TutorialBanner; `problem/` (the workspace: editor, TestPanel, SubmissionDetail, TutorialSpotlight; `memberCompletion/`: what the editor suggests after `.` in Java, Python and C++, curated member tables and the pure `memberCompletions`; `walkthrough/`: the Walkthrough tab, lazy, its decisions in the pure `walkthroughTab.ts`), `profile/` (incl. GitHubLinkCard), `reviews/`, `roadmap/`, `landing/`, `admin/`, `dev/` (the Diagram gallery, Vite dev mode only)
- `lib/` — pure helpers with their Vitest files beside them (dueWording, headMeta, jsonLd, persistedDraft, signInReturn, i18n, …)
- `locales/en/`, `locales/ko/` — UI strings
- `onboarding/` — every Tutorial and Tip decision, free of React, with storage injected (`storage.ts`: `OnboardingStorage`, `browserStorage`, `readStored`/`writeStored`): `tutorial` (the six steps, `tutorialStep`), `spotlight` (what each step spotlights, which elements stay usable, what Tab and Escape do), `milestones` (what the Tutorial reports to `/api/tutorial/milestones`), `tips` + `seenTips`, `banner` (the /problems banner rule)
- `hooks/` — data hooks (useProblems, useProblem, useSubmissions, useSubmissionWatch, useReviewState, useRoadmap, …), `useDocumentMeta` (a route's title, description, canonical, Open Graph, JSON-LD and noindex, from the pure `lib/headMeta` and `lib/jsonLd`; `useDocumentTitle` delegates to it), `usePersistedDraft`, `useKeyboardShortcuts`, `useTutorial`

## Tech stack

- React 19, TypeScript, Vite
- Tailwind CSS v4 with `@tailwindcss/typography`
- Axios (HTTP client with JWT interceptor)
- Monaco Editor (`@monaco-editor/react`)
- React Router v7 (`react-router-dom`), React Context for auth state

## Routes

Declared in `frontend/src/App.tsx`; `scripts/check-doc-references.py` fails when a route and this table disagree.

| Path | Page | Auth |
|------|------|------|
| `/login` | LoginPage | No |
| `/auth/callback/:provider` | OAuthCallbackPage | No |
| `/admin/dashboard` | AdminDashboardPage (`pages/admin/DashboardPage`) | ADMIN (`AdminLayout` sends anyone else to `/`) |
| `/admin/problems` | AdminProblemListPage | ADMIN |
| `/admin/problems/:id` | AdminProblemEditPage | ADMIN |
| `/admin/users` | AdminUserListPage | ADMIN |
| `/admin/users/:userId/submissions` | AdminUserSubmissionsPage | ADMIN |
| `/` | LandingPage | No |
| `/problems` | ProblemListPage | No |
| `/problems/:slug` | ProblemDetailPage | No (submit requires auth) |
| `/problems/:slug/solutions/new` | SolutionEditorPage (create) | Yes |
| `/problems/:slug/solutions/:solutionId` | SolutionDetailPage | No |
| `/problems/:slug/solutions/:solutionId/edit` | SolutionEditorPage (edit) | Yes |
| `/roadmap` | RoadmapPage | No |
| `/profile` | ProfilePage | Yes |
| `/github/callback` | GitHubCallbackPage (GitHub App install redirect; links the Solution Repository named on the profile card, with a retry on failure) | Yes |
| `/reviews` | ReviewsPage | Yes |
| `/dev/diagrams` | DiagramGalleryPage (Vite dev mode only, see Diagrams in CLAUDE.md; 404 in a production build) | ADMIN |
| `*` | NotFoundPage | No |
