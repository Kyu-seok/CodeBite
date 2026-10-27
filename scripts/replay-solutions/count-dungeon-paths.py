from math import comb


class Solution:
    def unique_paths(self, rows: int, cols: int) -> int:
        # Any path is some arrangement of rows - 1 downs among rows + cols - 2 moves.
        return comb(rows + cols - 2, rows - 1)
