# Frontend layout

Which directory of `frontend/src/` holds what. Open it to find where a module lives or where a new one goes; the rules an `ls` would not tell you are the Frontend gotchas in CLAUDE.md.

- `api/` — Axios client (`client.ts`, JWT interceptor) and one module per backend area (auth, problems, submissions, reviews, streak, github, profile, roadmap, recommendations, solutions, tags, tutorial, user, admin)
- `types/` — TypeScript interfaces matching backend DTOs
- `context/` — AuthContext (JWT auth state + localStorage persistence)
- `components/layout/` — Layout (nav bar), ProtectedRoute; `components/ui/` — primitives (Badge, Button, Card, Dialog, DifficultyBadge, StatusBadge, Spinner, Tabs, …); `components/markdown/` — the description renderer and its `diagrams/`; `components/review/` — the rating widgets; `components/walkthrough/` — the Walkthrough player, a verbatim copy of the walkthrough kit (never edited here)
- `judge/` — `watchSubmission.ts`: how a Verdict is awaited (SSE, polling as the fallback)
- `pages/` — LoginPage, OAuthCallbackPage, GitHubCallbackPage, ProblemListPage, NotFoundPage, TutorialBanner; `problem/` (the workspace: editor, TestPanel, SubmissionDetail, TutorialSpotlight; `walkthrough/`: the Walkthrough tab, lazy, its decisions in the pure `walkthroughTab.ts`), `profile/` (incl. GitHubLinkCard), `reviews/`, `roadmap/`, `landing/`, `admin/`, `dev/` (the Diagram gallery, Vite dev mode only)
- `lib/` — pure helpers with their Vitest files beside them (dueWording, headMeta, jsonLd, persistedDraft, signInReturn, i18n, …)
- `locales/en/`, `locales/ko/` — UI strings
- `onboarding/` — every Tutorial and Tip decision, free of React, with storage injected (`storage.ts`: `OnboardingStorage`, `browserStorage`, `readStored`/`writeStored`): `tutorial` (the six steps, `tutorialStep`), `spotlight` (what each step spotlights, which elements stay usable, what Tab and Escape do), `milestones` (what the Tutorial reports to `/api/tutorial/milestones`), `tips` + `seenTips`, `banner` (the /problems banner rule)
- `hooks/` — data hooks (useProblems, useProblem, useSubmissions, useSubmissionWatch, useReviewState, useRoadmap, …), `useDocumentMeta` (a route's title, description, canonical, Open Graph, JSON-LD and noindex, from the pure `lib/headMeta` and `lib/jsonLd`; `useDocumentTitle` delegates to it), `usePersistedDraft`, `useKeyboardShortcuts`, `useTutorial`
