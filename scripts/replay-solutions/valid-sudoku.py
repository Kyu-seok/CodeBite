class Solution:
    def isValidSudoku(self, board: list[list[str]]) -> bool:
        seen: set[tuple] = set()
        for r in range(9):
            for c in range(9):
                digit = board[r][c]
                if digit == ".":
                    continue
                keys = [("row", r, digit), ("col", c, digit), ("box", r // 3, c // 3, digit)]
                if any(key in seen for key in keys):
                    return False
                seen.update(keys)
        return True
