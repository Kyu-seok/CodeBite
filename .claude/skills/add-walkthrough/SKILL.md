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
3. The reference solution is `scripts/replay-solutions/<slug>.py`. When it is missing, write it first: the `Solution` class only, with the Starter Code's method name. `CODEBITE_DB=<database> scripts/judge-local.sh <slug> --languages python` must pass every case.

Done when you can say what each sample's answer is and why, and the reference solution passes.

## 2. Write the tracer

Copy the tracer closest to your problem's shape: one in `scripts/walkthroughs/` (`rotting-donuts.py`: grid and BFS queue, `cheapest-courier-route.py`: graph relaxations into cost arrays, `rotate-pixel-art.py`: a grid rotated through a one-cell temp, `valid-sudoku.py`: a board with boxes and a map per region, and the Arrays & Hashing ones for maps, sets, strings and windows), or the public skill's example. [views.md](views.md) says which view each common shape takes, and the marks and tags that read right. Name it `scripts/walkthroughs/<slug>.py`, keep its `#!/usr/bin/env python3.12` shebang and `chmod +x` it. CodeBite's tracers differ from the public examples in three ways, all through `scripts/walkthroughs/codebite.py`, which also holds the caption helpers `driver_list`, `plural` and `josa`:

- **Samples come from the database**, never a literal list: `sample_cases(slug)` returns them in `order_index` order as `{"input", "expected", "label"}`, input and expected verbatim. Parse `input` exactly as the problem's Python Driver (`common/src/main/resources/drivers/<slug>/python.py`) reads it: usually one parameter per line, a list as JSON.
- **One run per sample** through `sample_run(wt, n, sample, input=...)`: it pins the run to the sample (`sampleInput`, and `expected` as the sample's expected-output text) and labels it "Example N"/"예시 N" when the description shows that example, else "Case N"/"케이스 N" as the test panel numbers samples (a problem often has more samples than Examples). `input=` is the display line, written like the description's `Input:` line. An extra run is `wt.run(..., extra=True)` after the sample runs; it has no `sampleInput`, and its `expected` is what the Driver prints for that input, written as a literal (for a round trip, the input itself).
- **The last frame's answer is a string**, printed as the Driver prints it: `answer=str(result)` for a number, `driver_list(result)` for a list. When the Driver prints several lines (`dedupe-textbook-shelf` prints k, then the kept front), the answer is those lines joined with `\n`, and the last caption states every line.

Every Text field (title, approach, view titles and labels, node tags, table columns, captions) is `{"en": ..., "ko": ...}`, both non-empty: the title is the problem's title in each language. A label that is an English word (`best`, `target`, a parameter like `votes`) keeps the code name with a Korean gloss, `{"en": "best", "ko": "best (최장 길이)"}`; one-letter names and `nums` stay plain strings. A `vars` item's `value` is never translated (an `{en, ko}` value draws as raw JSON): words go in its `label`, and the value stays a number, a short code-like string or a list.

A caption is one or two sentences in each language, and the setup frame names the run's actual values (the words, the first id, the numbers read). Write the Korean caption from the same numbers as the English one, in the Korean statement's terms.

**Korean particles.** A particle after a number depends on how the number is read aloud: `josa(n, "은는")` writes `3은` but `4는`, and takes `"이가"`, `"을를"`, `"과와"` and `"(으)로"` the same way (its docstring has the rule). Use it for every particle that follows a number. A particle after anything else whose reading isn't fixed (a quoted letter `'l'`, a closing bracket `s[0]`, `[1,3]`, `#`) can't be chosen by rule: put a noun before the particle (`[1,3] 구간과`, `번호 4개(7, 2, 9, 7)를`), or rephrase with `:` (`s[0] = 'y':`) or `의`.

**Go red first.** For a new problem, save a copy of the tracer in `scripts/walkthroughs/` (so its imports resolve) with a wrong answer on one run, and run it: the recorder must refuse it and leave no file. For a Walkthrough that exists, the red is step 4's test failing on the change. Then run the real tracer with `python3.12` (local `python3` is 3.9): `CODEBITE_DB=<database> scripts/walkthroughs/<slug>.py`, and delete the copy. Done when it prints the JSON's path; the recorder refuses a run whose answer isn't the expected output before it writes anything.

## 3. Review the frames

Besides the public checklist, hold every frame to the two rules (#273): (1) the drawing shows where the step's value came from and where it went, by a move or by marking both places; (2) a value with a position or range (a pointer, a window, the best range, a count per key, the answer so far) is drawn on the data, and `vars` holds only values with no place in it, such as `k`. A frame failing either goes back to the tracer.

The rules can hold while the picture still doesn't teach; the owner sent back three that passed them (#286). Check each Walkthrough for these too:
- **Each structure drawn in the shape the solver pictures.** A key packed into a string (`"1:5"`, `"0,1:2"`) is a structure flattened: draw what it encodes, such as one card per region holding its digits ([views.md](views.md), sets of composite keys).
- **One assignment per frame.** Where the code moves a value through a temp, or one cell at a time, the frames do too, with the temp a view of its own; two cells changing at once hides the order.
- **The description's Diagram look.** A view drawing a structure the description draws with a Diagram (a graph, a grid, intervals) matches its layout, so the learner recognises the picture: open the problem's description beside the shots.

The public skill's steps 5 and 6, with the pages and shots kept out of the repo under a name of your own (`<scratch>` below: another session's review script or page in a shared scratchpad gets overwritten):

```sh
node ~/.agents/skills/walkthrough/scripts/build.mjs common/src/main/resources/walkthroughs/<slug>.json --out <scratch>/<slug>.html
node ~/.agents/skills/walkthrough/scripts/capture.mjs <scratch>/<slug>.html --review --dir <scratch>/<slug>-review
```

and again with `--lang ko` on the build, into a `-ko` page and review directory. Build prints the page's path; when it prints nothing, no page was written (an older `build.mjs` run through the `~/.agents` symlink exits 0 silently: run `~/Work/walkthrough-skill/scripts/build.mjs` instead, or update the skill). Read every PNG against the public skill's `references/verify.md`, the Korean sheets too (a caption cut short, a label that wraps over a value). The capture fails on a view clipped in its card at 1440 or 390, naming the view's `id`, the width and the frames (a table wider than about 7 data columns is the usual one): lay that view out narrower, as rows instead of columns ([views.md](views.md)). Fix the tracer, run it, rebuild, shoot again.

Done when both captures end `✓ no console errors, no sideways scroll, no view clipped in its card` and every checklist item holds in every shot, in both languages.

## 4. Run the answer test

```sh
./gradlew :backend:test --tests 'com.codebite.problem.*'
```

`WalkthroughsMatchSamplesTest` checks every file in `walkthroughs/` against the migrated samples (one run per sample, in order, by `sampleInput` and `expected`, each ending on its answer) and the format; `ProblemSlugsTest` that the file names a current Slug. The rest of the package runs too because a new file changes what the endpoint and `hasWalkthrough` answer: #264's first file broke `WalkthroughEndpointTest`. It also fails on a caption of three or more sentences in either language. Wait until no other worktree's Gradle test run is going (`pgrep -f "Gradle Test Executor"` prints nothing): the machine fits one. Don't run it while `dev-branch-servers.sh` is compiling the backend: two Gradle builds in one worktree corrupt the backend build output (`./gradlew :backend:clean` recovers). Done when the package is green.

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
