class Solution:
    def largest_square(self, matrix: list[list[str]]) -> int:
        cols = len(matrix[0])
        # side[c] = side of the largest clear square whose bottom-right is this row, column c - 1
        side = [0] * (cols + 1)
        biggest = 0
        for row in matrix:
            diagonal = 0  # side[c - 1] from the row above
            for c in range(1, cols + 1):
                above = side[c]
                side[c] = min(above, side[c - 1], diagonal) + 1 if row[c - 1] == "1" else 0
                diagonal = above
                biggest = max(biggest, side[c])
        return biggest * biggest
