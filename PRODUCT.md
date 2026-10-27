# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Primary: Korean developers (students, junior engineers, career changers) preparing for coding interviews by practising algorithm problems. They come back to the product daily or near-daily, sit in a desktop editor for focused sessions, and want to know what to solve next rather than picking problems by gut.

Secondary: hiring reviewers and recruiters who meet CodeBite as the author's backend portfolio project (README, `docs/portfolio/`). They evaluate it; they do not practise on it. Design decisions favour the learner.

Admins maintain problems, test cases and users through the admin dashboard.

## Product Purpose

CodeBite turns deliberate practice (Anders Ericsson, *Peak*) into software. Its three conditions map onto three product systems:

- **Problems at the right level** → the learning roadmap: 19 topics in prerequisite order. Every topic is open; the arrows show what to learn first, and each topic shows its progress.
- **Immediate feedback** → Run (synchronous, sample cases) and Submit (asynchronous judging via Kafka + Judge0, results pushed over SSE).
- **Spaced repetition** → after an Accepted submission the learner rates confidence (Again / Hard / Good / Easy), which schedules when the problem returns, Anki-style.

Success means a learner's practice time drifts toward their weak problems and topics, and they keep practising daily.

## Positioning

LeetCode and NeetCode give you problems and lists; CodeBite schedules your practice. It combines a prerequisite-ordered roadmap, instant judging and spaced review in one loop, with problem descriptions served in Korean and a curated set (CB50 / CB100 / CB200, 200 problems total) for Korean developers for whom Grind75/NeetCode are unknown or held back by English.

## Operating Context

- Code workspace: three-pane layout (description · Monaco editor · test results), resizable and collapsible panels, Vim/Emacs keybindings, custom test cases, problem diagrams (trees, graphs, grids, linked lists), solve timer, per-language autosave, shortcuts (`Cmd/Ctrl + '` run, `Cmd/Ctrl + Enter` submit).
- Languages: Java, Python, JavaScript, C++, C.
- Daily-habit mechanics: Streaks, Repairs and Repair Progress, Review Streak (terms in `GLOSSARY.md`; days are UTC per `docs/adr/0001`).
- GitHub Link: Accepted submissions become Solution Commits in the learner's own Solution Repository; a one-time Import backfills earlier ones.
- Surfaces: landing page, problem list, problem workspace, roadmap, reviews dashboard, profile, admin.
- Sign-in with Google or GitHub. Dark mode exists.
- Runs in production at code-bite.com on a single home mini PC.

## Capabilities and Constraints

- Korean and English are equal locales: every surface must work equally well in both, including text length, line breaking and type rendering. Problem translations are served by the backend.
- Domain vocabulary is fixed by `GLOSSARY.md` (Streak, Streak Day, Missed Day, Repaired Day, Repair, GitHub Link, Solution Repository, Solution Commit, Import); UI copy uses those terms and avoids the listed alternatives.
- Submission feedback latency is a product promise: measured submit-to-result is ~1.9s for Python/JavaScript, ~3.6s C++, ~8.3s Java (bounded by per-case compile/startup). UI must handle that waiting honestly.
- Existing stack: React 19 + TypeScript + Vite, Tailwind CSS v4, Radix primitives, Monaco, React Flow (roadmap), Recharts.

## Brand Commitments

- Name: CodeBite.
- Logo assets: `Logo/`, `frontend/public/logo.svg`, `frontend/public/navbar_logo.svg`, `frontend/public/favicon.png`.

## Evidence on Hand

- Product screenshots: `docs/screenshots/` (landing, problems, editor, roadmap, reviews, profile, review-prompt).
- Real measurements: submission-latency work (30s+ → 1.9s) in `README.md` and `docs/제출-지연-분석.md`; load tests in `docs/LOAD_TEST_RESULTS.md`.
- Real content: 200 curated problems, 19 roadmap topics.
- No user testimonials, user counts, or third-party endorsements exist. Do not fabricate them.

## Product Principles

1. **Tell the learner what to do next.** Every surface should reduce "what do I solve now?" to an obvious answer: the roadmap, due reviews, weakest tags.
2. **Feedback is immediate and honest.** Judging state, latency and failures are shown plainly; never fake progress.
3. **Practice beats volume.** Favour signals of retention and weak spots over raw solved counts.
4. **Daily return without guilt.** Habit mechanics (Streaks, Repairs) reward consistency and forgive gaps; they never punish.
5. **Bilingual by construction.** Korean and English are both first-class; nothing is designed for one and patched for the other.
