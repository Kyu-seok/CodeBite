# Views for common shapes

What the Arrays & Hashing Walkthroughs settled, on top of the public skill's `references/format.md`. Each line names a tracer in `scripts/walkthroughs/` that does it. Every Walkthrough meets the two rules in the checklist (`add-walkthrough` step 3): each frame shows where its value came from and went, and a value with a place in the data is drawn there, with only the rest in `vars`. Lines below that still describe a `table` or `vars` for such a value are the old look, redone ticket by ticket under #273.

## Shapes

- **A hash map** is a `map`, never a `table` or a list in `vars`: `{"entries": map_entries(counts)}` draws one key card per entry in insertion order, a count as dots and the number, a list as chips. Mark the key a step changed `good`. Each value read moves into its key's card: `moves=[move(at("log", i), at("uses", machine))]`. A ranking is its own frame, `ranks` badging the keys #1, #2… with the ones the answer takes `path` and the rest `dim`; then each one moves into an `output` view, which shows the answer forming (`top-espresso-machines`).
- **The answer** that is built up (a list of picks, a whiteboard) is an `output` view its values move into, not a `vars` list.
- **A set** is a one-row `table` with one cell per member (`spot-duplicate-locker`), or an `array` in the real loop order with each element tagged by its decision when the loop walks the set (`longest-seat-run`).
- **A set of composite keys** gets one table per key family (`valid-sudoku`: lines, boxes).
- **Strings** longer than about 4 characters go in table cells: `array` cells are a fixed 46px. A string walked letter by letter is an `array` of its characters; a string that grows is an `array` padded with `""` to its final length, so cells keep their place (`chat-log-codec`).
- **Intervals** are two tables, the input sorted and the output so far, with start and end columns, plus `vars` for the boundary compared (`merge-reservation-slots`).
- **Bit tricks** are an `array` with fixed-width binary tags, plus the running value in decimal and in bits in `vars` (`lonely-candy`).
- **A table wider than about 7 data columns** is clipped at 390px: turn it, one row per item (a 9-wide table becomes 9 rows of k columns, as `valid-sudoku`'s row and column sets do).
- **A window** is a span on its array, never `vars` values: `"spans": {"window": span(left, right, {"en": f"window {length}", "ko": f"구간 {length}"}, fade=True)}` draws a bracket above the cells labelled with its length and fades the cells outside it; the `left`/`right` pointers stay as carets, and cells not read yet are `unread` (dashed). The best so far is a second span, `span(a, b, f"best = {best}", below=True)`, dashed under the cells, marked `good` on the frame that beats it. The counts in the window are a `map` with `slots=k` when the window holds at most k keys, so the key that overflows shows red; that frame marks the window span `bad`. Each element dropped from the left is its own frame: it moves out of the map back to its cell (`move(at("window", g), at("queue", i), mark="bad")`), and a key whose count reaches 0 stays with value 0 and in `struck` for that frame. The last frame hides the window span and the pointers, marks the best span and its cells `path`, and the caption says where the run actually ended when the best window came earlier (`unique-genre-window`; the public skill's `examples/window-at-most-k-distinct`).
- **A running value** with a place (a prefix sum, a window length per right end) goes `under` its cell: `"under": [[i, str(total)]]`.

## Marks, tags and ids

- `lit` wins over `good` on the same item: mark a changed cell `good` only.
- A `vars` item's `mark` colours a number; the chips of a list value ignore it.
- For an index-slot or cyclic-placement problem, tag each cell with what it stands for (`for 3` / `3번 칸`); for a running count, tag each read cell with its effect (`+1`, `−1`). Tags take Text (`missing-sock-number`, `majority-boss-vote`).
- A view id `answer` or `moves` collides with `run.frame(answer=..., moves=...)` (a TypeError): name it `result`, titled "answer".
- View titles are uppercased by the kit's CSS; a table with no `columns` draws no header row.
