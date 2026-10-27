class Solution:
    def longestVineAscent(self, matrix: list[list[int]]) -> int:
        rows, cols = len(matrix), len(matrix[0])
        # Visit tiles from highest to lowest, so every higher neighbour's path is already known.
        cells = sorted(((matrix[r][c], r, c) for r in range(rows) for c in range(cols)), reverse=True)
        longest = [[1] * cols for _ in range(rows)]
        for value, r, c in cells:
            for nr, nc in ((r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)):
                if 0 <= nr < rows and 0 <= nc < cols and matrix[nr][nc] > value:
                    longest[r][c] = max(longest[r][c], longest[nr][nc] + 1)
        return max(max(row) for row in longest)
