# Views for common shapes

What the Arrays & Hashing Walkthroughs settled, on top of the public skill's `references/format.md`. Each line names a tracer in `scripts/walkthroughs/` that does it. Every Walkthrough meets the two rules in the checklist (`add-walkthrough` step 3): each frame shows where its value came from and went, and a value with a place in the data is drawn there, with only the rest in `vars`. Lines below that still describe a `table` or `vars` for such a value are the old look, redone ticket by ticket under #273.

## Shapes

- **A hash map** is a `map`, never a `table` or a list in `vars`: `{"entries": map_entries(counts)}` draws one key card per entry in insertion order, a count as dots and the number, a list as chips. Mark the key a step changed `good`. Each value read moves into its key's card: `moves=[move(at("log", i), at("uses", machine))]`. A ranking is its own frame, `ranks` badging the keys #1, #2… with the ones the answer takes `path` and the rest `dim`; then each one moves into an `output` view, which shows the answer forming (`top-espresso-machines`).
- **The answer** that is built up (a list of picks, a whiteboard) is an `output` view its values move into, not a `vars` list.
- **A set** is a one-row `table` with one cell per member (`spot-duplicate-locker`), or an `array` in the real loop order with each element tagged by its decision when the loop walks the set (`longest-seat-run`).
- **A set of composite keys** gets one table per key family (`valid-sudoku`: lines, boxes).
- **Strings** longer than about 4 characters go in table cells: `array` cells are a fixed 46px. A string walked letter by letter is an `array` of its characters; a string that grows is an `array` padded with `""` to its final length, so cells keep their place (`chat-log-codec`).
- **Intervals** sit on one number line, an `intervals` view, never two tables: the input sorted and the output so far are two `groups` over one axis (pin it with `domain` in the run `setup`, so it holds still while the output grows). Light the interval read, mark the output interval it lands in `good`, and move it there: `moves=[move(at("line", [0, i]), at("line", [1, j]))]`, an address being `[group, index]`. The boundary compared is a `points` entry on the axis (`{"at": last_end, "label": ..., "mark": "lit"}`), drawn from its value before the step, not in `vars`. The last frame marks the output group `path` (`merge-reservation-slots`).
- **Bit tricks** are an `array` with fixed-width binary tags, plus the running value in decimal and in bits in `vars` (`lonely-candy`).
- **A table wider than about 7 data columns** is clipped at 390px: turn it, one row per item (a 9-wide table becomes 9 rows of k columns, as `valid-sudoku`'s row and column sets do).
- **A window** is the array with `left`/`right` pointers and everything outside it `dim`. When the answer is the best window seen before the run ended, the last frame hides the pointers, marks that window and its `vars` value `path`, draws the counts of that window, and the caption says where the run actually ended (`unique-genre-window`).

## Marks, tags and ids

- `lit` wins over `good` on the same item: mark a changed cell `good` only.
- A `vars` item's `mark` colours a number; the chips of a list value ignore it.
- For an index-slot or cyclic-placement problem, tag each cell with what it stands for (`for 3` / `3번 칸`); for a running count, tag each read cell with its effect (`+1`, `−1`). Tags take Text (`missing-sock-number`, `majority-boss-vote`).
- A view id `answer` or `moves` collides with `run.frame(answer=..., moves=...)` (a TypeError): name it `result`, titled "answer".
- View titles are uppercased by the kit's CSS; a table with no `columns` draws no header row.
