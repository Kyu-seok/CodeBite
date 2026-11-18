class Solution:
    def countPaths(self, rows: int, cols: int) -> int:
        # A tile is entered only from above or from the left, so the paths reaching it are those two counts added.
        paths = [[0] * cols for _ in range(rows)]
        paths[0][0] = 1
        for r in range(rows):
            for c in range(cols):
                if r > 0:
                    paths[r][c] += paths[r - 1][c]
                if c > 0:
                    paths[r][c] += paths[r][c - 1]
        return paths[rows - 1][cols - 1]
