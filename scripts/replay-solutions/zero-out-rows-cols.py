class Solution:
    def zeroOutRowsAndCols(self, board: list[list[int]]) -> None:
        # First note every row and column holding an original 0, then write: a 0 written in the second pass
        # never adds a row or column, so only the original zeros wipe.
        zero_rows, zero_cols = set(), set()
        for r, row in enumerate(board):
            for c, value in enumerate(row):
                if value == 0:
                    zero_rows.add(r)
                    zero_cols.add(c)
        for r, row in enumerate(board):
            for c in range(len(row)):
                if r in zero_rows or c in zero_cols:
                    row[c] = 0
