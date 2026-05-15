# Problem Diagrams — Roadmap

## Context

Many CodeBite problems have descriptions whose example blocks are technically complete but visually opaque — `[1, null, 2, 3]` for a tree or `[[0,1],[1,2],[0,2]]` for a graph forces the reader to mentally render the structure before they can think about the problem. Adding inline diagrams makes the structure visible at a glance, which is especially valuable for trees, graphs, and 2D grid problems.

The **goal is not 100% coverage**. AI-generated images (DALL-E etc.) are not viable for this — they hallucinate node labels, miscount cells, and connect arrows wrong. Instead this roadmap uses **deterministic React/SVG components** driven by small text directives embedded in the markdown description. AI's role is limited to *drafting the directive*, not rendering pixels.

Targeting is **tag-driven**, not blanket. Most array/binary-search/stack problems would be made worse by a diagram that just restates the input.

---

## Scope

### High-value targets (~80–100 of 200 problems)

| Category | Diagram value | Coverage target |
|---|---|---|
| Trees | Text array notation `[1,null,2,3]` is opaque | ~100% of tree problems |
| Graphs | Edge lists are unreadable past 4 nodes | ~100% of graph problems |
| 2D-grid problems (matrix, islands, grid-DP, grid-backtracking) | Visual structure *is* the problem | ~100% |
| Linked Lists — *only* cycle / intersection / reverse-pointer cases | Plain `1→2→3` is fine in text; only complex pointer arrangements need a picture | ~30–50% of linked-list problems |
| Backtracking (non-grid) | Only when a decision-tree visualization adds clarity | ~20% |
| DP on sequences | Rarely — DP tables are more code than concept | ~10% |

### Intentionally skipped

- 1D array diagrams (Arrays & Hashing, Two Pointers, Sliding Window, Stack, Binary Search, Heap, Greedy). The input array *is* the diagram; a row of boxes adds noise without signal.
- AI image generation (DALL-E, Midjourney, Stable Diffusion). Wrong tool for structured CS diagrams.

---

## Directive format

A diagram is a fenced markdown code block whose info string is `diagram-*`. The body is a small YAML-ish key/value spec — language-neutral data only, so the same block can be copy-pasted verbatim into both `en` and `ko` descriptions.

### `diagram-tree`

```
\`\`\`diagram-tree
nodes: [3, 9, 20, null, null, 15, 7]
highlight: [3, 6]   # array indices, not values (handles duplicate values)
after: [3, 20, 9, 7, 15, null, null]   # optional — see "Before/after pairs"
\`\`\`
```

- `nodes`: LeetCode level-order array, `null` for missing children.
- `highlight` (optional): list of array indices to mark prominently.
- `after` (optional): a second tree to render side-by-side with the input. See "Before/after pairs" below.

### `diagram-graph`

```
\`\`\`diagram-graph
edges: [[0,1], [1,2], [0,2], [2,3]]
directed: false
highlight_path: [0, 2, 3]   # optional ordered list of nodes
after: [[0,1], [1,2], [2,3]]   # optional — e.g. MST, transposed, pruned
\`\`\`
```

- `edges`: edge list. Nodes implied from edge endpoints; or use `nodes: [0,1,2,3]` to add isolated nodes.
- `directed` (optional, default `false`): renders arrowheads when true.
- `highlight_path` (optional): emphasizes a path.
- `after` (optional): a second edge list to render side-by-side. Useful for transformation problems (MST, transpose, prune). See "Before/after pairs" below.

### `diagram-grid`

```
\`\`\`diagram-grid
cells: [[1,2,3], [4,5,6], [7,8,9]]
highlight: [[0,0], [1,1], [2,2]]   # optional [row, col] list
after: [[7,4,1], [8,5,2], [9,6,3]]   # optional — e.g. rotated, set-zeros, transformed
\`\`\`
```

- `cells`: 2D array, any primitive type.
- `highlight` (optional): list of `[row, col]` cells to mark.
- `after` (optional): a second grid to render side-by-side. Useful for transformation problems (rotate matrix, set zeros, game of life). See "Before/after pairs" below.

Unrecognized keys are ignored (forward-compatible). Malformed input falls back to rendering the raw block as `<pre>` so the page never breaks on a bad diagram.

### Before/after pairs

When a problem transforms its input (invert tree, rotate matrix, MST, etc.), include the result as `after`. The component renders the two diagrams **side-by-side, in the same row, separated by a hollow right-pointing arrow** — matches the LeetCode convention and makes the transformation visible at a glance instead of forcing the reader to mentally diff two stacked diagrams.

```
[ before ]   →   [ after ]
```

Example, from the POC `mirror-menu-tree`:

```
\`\`\`diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
after: [5, 8, 3, 9, 7, 4, 2]
\`\`\`
```

Rules:
- `after` must have the same shape kind as `nodes`/`edges`/`cells` (level-order array, edge list, 2D array respectively).
- Highlights apply to the **before** diagram only; if you need separate highlighting on the after, that's a future extension (`highlight_after`) — not in scope today.
- On narrow viewports the pair wraps to stacked layout automatically, with the arrow re-orienting downward.
- Apply this whenever the problem has a clear "given X, return Y where Y is a structural transformation of X." Skip it for problems whose output is a scalar (e.g., max depth, count of islands) — there's no "after" to show.

---

## Components to build

All under `frontend/src/components/markdown/diagrams/` (co-located with the markdown infra since they only render via `MarkdownRenderer`).

| File | Purpose |
|---|---|
| `TreeDiagram.tsx` | Pure SVG. Naive level-order layout: depth = `floor(log2(i+1))`, x = even spacing. Circles + value labels + parent→child lines. CSS-var-driven colors (auto dark-mode). When `after` is provided, renders pair layout (see "Before/after pairs"). |
| `GraphDiagram.tsx` | Pure SVG. Circular layout (nodes on a circle, edges as chords) — adequate for ≤12 nodes. Optional arrowheads when `directed: true`. Pair layout when `after` is provided. |
| `GridDiagram.tsx` | Plain CSS grid (no SVG needed). Cells as styled divs. Highlight is a colored ring. Pair layout when `after` is provided. |
| `BeforeAfterPair.tsx` (shared) | Wraps two diagrams in a flex row with a hollow right-pointing SVG arrow between them. Falls back to stacked layout on narrow viewports. Used by all three diagram components when their `after` field is set. |
| `parseDirective.ts` | One small parser shared across the three. Each `key: value` line is parsed independently; the value side accepts JSON literals (arrays, numbers, booleans). |

**Markdown integration** (single edit to `frontend/src/components/markdown/MarkdownRenderer.tsx`):

Extend the existing `code` renderer. When `language` starts with `diagram-`, parse the body and render the matching component. Otherwise fall through to the existing code-block rendering.

---

## Workflow — staged, not all-at-once

### Stage 1 — POC: trees only

Single commit, ~2 hours.

1. Build `TreeDiagram.tsx` + `parseDirective.ts`.
2. Wire into `MarkdownRenderer.tsx`.
3. Pick **one** tree problem. Write a Flyway migration (V177) that updates its `problems.description` (en) and `problem_translations.description` (ko, if present) to embed the directive next to "Example 1."
4. Verify: light mode, dark mode, highlights point at correct nodes, fallback works on a deliberately malformed directive.

Stop. Don't build graph/grid yet. Confirm the markdown plumbing and visual style are right before duplicating the work.

### Stage 2 — Trees vertical slice

After stage 1 ships, hand-author diagrams for **all tree problems** in the catalog (~15–20 problems based on the Trees + Tries tags). One Flyway migration covers the batch.

This stage tests the workflow end-to-end at meaningful scale and surfaces issues the POC won't (e.g. very deep trees breaking the naive layout, awkward author UX).

### Stage 3 — Calibrate

After stage 2, look at the result honestly:

- Are the diagrams genuinely improving comprehension, or are they noise?
- How long did each one actually take to author + verify?
- Did the naive layout look OK, or do we need Reingold–Tilford?
- Is the en/ko duplication painful enough to refactor toward a separate `Problem.diagrams` field with anchor markers in description?

Decide based on data, not the original plan.

### Stage 4 — Graph + Grid components

Same pattern as stage 1, one component at a time. ~1 hour each. Each followed by a small vertical slice (graph problems, then grid problems).

### Stage 5 (conditional) — Bulk pass with AI-generated drafts

Only run this if stages 1–4 confirm diagrams are worth the effort.

A small Node script:
1. For each problem matching a target tag, call the Claude API with the problem description + tag.
2. Prompt asks for either `{ skip: true, reason }` or a full `diagram-*` directive ready to embed.
3. Output to a review file (`/tmp/diagram-drafts.json`).
4. Human reviews — expect ~20% need adjustment, ~10% should be skipped despite the tag matching.
5. Approved drafts get bundled into one Flyway migration that updates both `problems.description` and `problem_translations.description`.

This is much faster than hand-authoring 60+ remaining diagrams; the human is reviewing AI output, not generating it.

---

## Critical files

**New (Stage 1)**
- `frontend/src/components/markdown/diagrams/TreeDiagram.tsx`
- `frontend/src/components/markdown/diagrams/parseDirective.ts`
- `common/src/main/resources/db/migration/V177__diagram_poc_tree_problem.sql`

**Modified (Stage 1)**
- `frontend/src/components/markdown/MarkdownRenderer.tsx` — extend the `code` renderer to detect `diagram-*` languages.

**New (Stages 4)**
- `frontend/src/components/markdown/diagrams/GraphDiagram.tsx`
- `frontend/src/components/markdown/diagrams/GridDiagram.tsx`

**New (Stage 5, conditional)**
- `scripts/generate-diagram-drafts.ts` (or wherever scripts live in this repo)

---

## What's intentionally NOT planned

- **1D array diagrams.** Input is already the diagram.
- **AI image generation.** Wrong tool — hallucinates structure.
- **Mermaid integration.** Considered but rejected: ~600KB bundle cost, no clean highlighting model, no grid support. Hand-rolled SVG is leaner and gives uniform style across all three diagram types.
- **Per-locale separate diagrams.** Data is language-neutral; same fenced block goes into both `en` and `ko` descriptions.
- **Locking in "all 200 problems must have a diagram."** Calibrate after stage 2; expect end state of ~80–100 problems with diagrams, not 200.
- **Live admin preview** (typing the directive and seeing it render in the problem editor). Worth doing later if authoring volume warrants it; not for the POC.

---

## Verification per stage

- **Stage 1**: build clean, browser-render the one POC problem in both light + dark, intentionally break the directive to confirm the fallback. If the problem is a transformation (e.g. invert), confirm the before/after pair renders side-by-side with the arrow.
- **Stage 2**: every tree problem renders without error; spot-check 5 in dark mode. Confirm transformation problems use `after` and render as a pair; non-transformation problems (max depth, count, etc.) render as a single tree.
- **Stage 4**: graph problems with ≤12 nodes render readably; grid problems render at multiple sizes (3×3, 5×8, 10×10). Verify `after` works for at least one transformation in each new diagram type (e.g. rotate matrix for grid, MST for graph).
- **Stage 5**: review file has clear skip/include decisions; approved migration applies cleanly against H2 in `:backend:test`.
