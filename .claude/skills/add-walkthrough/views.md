# Views for common shapes

What the Arrays & Hashing Walkthroughs settled, on top of the public skill's `references/format.md`. Each line names a tracer in `scripts/walkthroughs/` that does it.

## Shapes

- **A hash map** is a `table`: one row per entry in insertion order, the key as the row label and the value in a cell (`columns: [{"en": "count", "ko": "개수"}]`), so one entry can be marked. A map of lists gets one cell per item (`group-anagrams`). On the last frame the entries the answer used are `path` and the rest `dim` (`top-espresso-machines`).
- **A set** is a one-row `table` with one cell per member (`spot-duplicate-locker`), or an `array` in the real loop order with each element tagged by its decision when the loop walks the set (`longest-seat-run`).
- **A set of composite keys** gets one table per key family (`valid-sudoku`: lines, boxes).
- **Strings** longer than about 4 characters go in table cells: `array` cells are a fixed 46px. A string walked letter by letter is an `array` of its characters; a string that grows is an `array` padded with `""` to its final length, so cells keep their place (`chat-log-codec`).
- **Intervals** are two tables, the input sorted and the output so far, with start and end columns, plus `vars` for the boundary compared (`merge-reservation-slots`).
- **Bit tricks** are an `array` with fixed-width binary tags, plus the running value in decimal and in bits in `vars` (`lonely-candy`).
- **A table wider than about 7 data columns** is clipped at 390px: turn it, one row per item (a 9-wide table becomes 9 rows of k columns, as `valid-sudoku`'s row and column sets do).
- **A window** is the array with `left`/`right` pointers and everything outside it `dim`. When the answer is the best window seen before the run ended, the last frame hides the pointers, marks that window and its `vars` value `path`, draws the counts of that window, and the caption says where the run actually ended (`unique-genre-window`).

## Marks, tags and ids

- `lit` wins over `good` on the same item: mark a changed cell `good` only.
- A `vars` item's `mark` colours a number; the chips of a list value ignore it.
- For an index-slot or cyclic-placement problem, tag each cell with what it stands for (`for 3` / `3번 칸`); for a running count, tag each read cell with its effect (`+1`, `−1`). Tags take Text (`missing-sock-number`, `majority-boss-vote`).
- A view id `answer` collides with `run.frame(answer=...)` (a TypeError): name it `result`, titled "answer".
- View titles are uppercased by the kit's CSS; a table with no `columns` draws no header row.
