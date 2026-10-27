class Solution:
    def clearDefectRows(self, board: list[list[int]]) -> None:
        zero_rows = {r for r, row in enumerate(board) if 0 in row}
        zero_cols = {c for row in board for c, value in enumerate(row) if value == 0}
        for r, row in enumerate(board):
            for c in range(len(row)):
                if r in zero_rows or c in zero_cols:
                    row[c] = 0
