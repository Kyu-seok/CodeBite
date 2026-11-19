class Solution:
    def longestIncreasingPath(self, scores: list[list[int]]) -> int:
        rows, cols = len(scores), len(scores[0])
        # Visit tiles from highest to lowest, so every higher neighbour's path is already known.
        cells = sorted(((scores[r][c], r, c) for r in range(rows) for c in range(cols)), reverse=True)
        longest = [[1] * cols for _ in range(rows)]
        for value, r, c in cells:
            for nr, nc in ((r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)):
                if 0 <= nr < rows and 0 <= nc < cols and scores[nr][nc] > value:
                    longest[r][c] = max(longest[r][c], longest[nr][nc] + 1)
        return max(max(row) for row in longest)
