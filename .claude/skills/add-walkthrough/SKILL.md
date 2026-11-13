---
name: add-walkthrough
description: Add a Walkthrough (a stepped picture of the reference solution running on each sample Test Case) to a CodeBite problem, in English and Korean, or regenerate one after its samples or solution change. Use when a problem should get a Walkthrough, or the Walkthrough answer test fails.
---

# Add a Walkthrough

A **Walkthrough** (GLOSSARY.md) is one approach stepped through on each of a problem's sample Test Cases, shown in the problem's Walkthrough tab. It is one generated file, `common/src/main/resources/walkthroughs/<slug>.json` (docs/adr/0011), written by a committed tracer, `scripts/walkthroughs/<slug>.py`: the reference solution with frame calls added. Nobody edits the JSON by hand; change the tracer and run it again.

The public `walkthrough` skill (`~/.agents/skills/walkthrough/SKILL.md`) owns everything generic: the format, finding the lesson, choosing views and marks, instrumenting, captions and the review checklist. Read it, its `references/format.md` and `references/instrumenting.md`, and the example closest to your problem before step 2. This skill holds only what is CodeBite's.

## 1. Collect the truth

1. From your worktree, start `scripts/dev-branch-servers.sh` in the background. Its database is at this checkout's migrations, which the tracer needs: `scripts/db-sql.sh`, which the tracer reads samples through, refuses a database behind them (the local `codebite` usually is).
2. `CODEBITE_DB=<the database it prints> scripts/problem-text.sh <slug>`: the English and Korean statement and the sample Test Cases. The Korean statement's words for the problem's things (카페, 구간) are the Korean captions' words.
3. The reference solution is `scripts/replay-solutions/<slug>.py`. `CODEBITE_DB=<database> scripts/judge-local.sh <slug> --languages python` must pass every case.

Done when you can say what each sample's answer is and why, and the reference solution passes.

## 2. Write the tracer

Copy the tracer closest to your problem's shape: one in `scripts/walkthroughs/` (`rotting-donuts.py`: grid, `cheapest-courier-route.py`: graph and cost table), or the public skill's example. Name it `scripts/walkthroughs/<slug>.py`, keep its `#!/usr/bin/env python3.12` shebang and `chmod +x` it. CodeBite's tracers differ from the public examples in three ways, all through `scripts/walkthroughs/codebite.py`:

- **Samples come from the database**, never a literal list: `sample_cases(slug)` returns them in `order_index` order as `{"input", "expected", "label"}`, input and expected verbatim. Parse `input` exactly as the problem's Python Driver (`common/src/main/resources/drivers/<slug>/python.py`) reads it: usually one parameter per line, a list as JSON.
- **One run per sample** through `sample_run(wt, n, sample, input=...)`: it pins the run to the sample (`sampleInput`, and `expected` as the sample's expected-output text) and labels it "Example N"/"예시 N" when the description shows that example, else "Case N"/"케이스 N" as the test panel numbers samples (a problem often has more samples than Examples). `input=` is the display line, written like the description's `Input:` line. An extra run is `wt.run(..., extra=True)` after the sample runs.
- **The last frame's answer is a string**, printed as the Driver prints it: `answer=str(result)` for a number, the Driver's own formatting for a list.

Every Text field (title, approach, view titles and labels, node tags, table columns, captions) is `{"en": ..., "ko": ...}`, both non-empty: the title is the problem's title in each language. Write the Korean caption from the same numbers as the English one, in the Korean statement's terms. A Korean particle after a number depends on how the number is read (`카페 3은`, `카페 4는`), so follow a number with a counter or noun (`200분이`, `구간 3개가`) or rephrase with `의` (`카페 3의 비용은`).

Run it with `python3.12` (local `python3` is 3.9): `CODEBITE_DB=<database> scripts/walkthroughs/<slug>.py`. Done when it prints the JSON's path; the recorder has already refused a run whose answer isn't the expected output.

## 3. Review the frames

The public skill's steps 5 and 6, with the page kept out of the repo:

```sh
node ~/.agents/skills/walkthrough/scripts/build.mjs common/src/main/resources/walkthroughs/<slug>.json --out <scratch>/<slug>.html
node ~/.agents/skills/walkthrough/scripts/capture.mjs <scratch>/<slug>.html --review --dir <scratch>/<slug>-review
```

and again with `--lang ko` on the build, into a `-ko` page and review directory. Build prints the page's path; when it prints nothing, no page was written (an older `build.mjs` run through the `~/.agents` symlink exits 0 silently: run `~/Work/walkthrough-skill/scripts/build.mjs` instead, or update the skill). Read every PNG against the public skill's `references/verify.md`, the Korean sheets too (a caption cut short, a label that wraps over a value). Fix the tracer, run it, rebuild, shoot again.

Done when both captures end `✓ no console errors, no sideways scroll` and every checklist item holds in every shot, in both languages.

## 4. Run the answer test

```sh
./gradlew :backend:test --tests 'com.codebite.problem.WalkthroughsMatchSamplesTest' --tests 'com.codebite.problem.ProblemSlugsTest'
```

`WalkthroughsMatchSamplesTest` checks every file in `walkthroughs/` against the migrated samples (one run per sample, in order, by `sampleInput` and `expected`, each ending on its answer) and the format; `ProblemSlugsTest` that the file names a current Slug. Don't run it while `dev-branch-servers.sh` is compiling the backend: two Gradle builds in one worktree corrupt the backend build output (`./gradlew :backend:clean` recovers). Done when both are green.

## 5. Check the tab

The backend reads `walkthroughs/` once at startup, so restart the branch servers (`stop`, then start again) after the file changes. Then run the app check headless against the URLs the servers printed:

```bash
node scripts/walkthrough-app-check.mjs <vite url> <backend api url> <scratchpad>/shots/<slug>-app <slug>
```

It drives `/problems/<slug>` signed out and signed in, at 1440 and 390, dark and light, English and Korean: the tab, the reveal, the player's theme, language and labels, sideways scroll, ←/→ stepping only while the player has focus and never from the editor, the run kept across a tab switch, and no tab on a problem without a Walkthrough. Read its shots, the `-3b-last` ones above all: the last frame is where a wrong answer path or an unexplained value shows.

Done when the check exits 0 and the shots show the drawing as the capture.mjs sheets did. Stop the servers with `scripts/dev-branch-servers.sh stop`.

Commit `feat(problem): Walkthrough for <slug>` with the tracer and the JSON together.

## When a problem changes

- **A sample Test Case changes** (`correct-test-cases`): `WalkthroughsMatchSamplesTest` goes red; run the tracer against a database with the correction and commit the new JSON with it.
- **The Slug, title or parameter names change**: `.claude/skills/restate-problem/SKILL.md`, step 4, moves or regenerates the Walkthrough.
