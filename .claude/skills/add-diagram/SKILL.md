---
name: add-diagram
description: Add a Diagram (a drawn grid, tree, graph or linked list) under a CodeBite problem's examples, in English and Korean. Use when a problem's example input is hard to read as one line, or a problem should get a diagram.
---

# Add a Diagram

A **Diagram** (GLOSSARY.md) is a fenced block in a problem's description whose info string is `diagram-grid`, `diagram-tree`, `diagram-graph` or `diagram-linked-list`. `MarkdownRenderer` draws it; a block it can't parse shows as raw text instead. The body is language-neutral data, so the English description and the Korean translation carry the same block byte for byte. The keys of each kind are in `docs/PROBLEM_DIAGRAMS_ROADMAP.md` under "Directive format".

A Diagram sits under its example's code block. The one-line `Input:` stays: it is the exact input the user's code receives.

## When a problem gets one

| Input | Diagram |
|---|---|
| 2D grid or matrix | always: `diagram-grid` (a Sudoku-like board adds `boxes` and `blank`) |
| binary tree | always: `diagram-tree` |
| graph (edge list, adjacency) | always: `diagram-graph` |
| linked list | only with a cycle, an intersection or a pointer rearrangement: `diagram-linked-list` |
| a size (`n = 4`) whose output is boards or grids | the output: one `diagram-grid` per board, as in N-Queens |
| 1D array, string, number | never: the input line already is the picture |

Draw the examples where the picture explains something the line can't. Example 1 is usually enough; draw a later example too when its point is visual (Valid Sudoku's Example 2 is the clash of two 8s). Use `after` when the problem transforms its input into something of the same shape; use `highlight` only for a cell, node or path the example's answer points at unambiguously.

A new problem from the `problem-generator` agent writes its Diagrams straight into the description in its own migration and skips step 2 below.

## 1. Write the directives

1. Read the problem's newest English and Korean descriptions and its sample Test Cases, as in step 1 of `.claude/skills/restate-problem/SKILL.md`.
2. Copy each drawn example's input into its directive's data exactly as the example states it.

Done when every value in each directive traces back to its example, and every highlighted cell, node or path is part of that example's answer.

## 2. Write the migration

Copy `common/src/main/java/db/migration/V198__add_grid_diagrams_batch2.java` to `V<next>__add_<slug_with_underscores>_diagrams.java` (`<next>`: one above the highest version on `origin/master`, counting both `common/src/main/resources/db/migration/` and `common/src/main/java/db/migration/`). Replace its `DIAGRAMS` list with one `Diagram(slug, example, body…)` per drawn example (several bodies draw several grids under one example, in order), and its comment with why each is drawn. Several problems may share one migration.

The migration inserts each block under `**Example N:**` and `**예시 N:**` through `V183.injectDiagram`, and fails when either marker is missing, so a reworded description can't silently go without its Diagram.

## 3. Verify

1. Add a test to `backend/src/test/java/com/codebite/problem/DiagramMigrationTest.java` that reads the problem's English and Korean descriptions and checks each block sits under its example (the V197 test is the model). Run `./gradlew :backend:test --tests '*DiagramMigrationTest'`.
2. Open `/problems/<slug>` in the running app (the `run` skill), in English and Korean, light and dark: every Diagram draws (a raw `diagram-*` block means it failed to parse) and matches its example.

Done when the test is green and you have looked at every Diagram in both languages and both themes.

Commit `feat(problem): Diagrams for <slug>`.
