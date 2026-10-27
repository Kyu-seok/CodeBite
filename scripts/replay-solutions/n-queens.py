class Solution:
    def solveNQueens(self, n: int) -> list[list[str]]:
        boards: list[list[str]] = []
        queens: list[int] = []  # queens[row] = column
        columns: set[int] = set()
        diagonals: set[int] = set()  # row - column
        anti_diagonals: set[int] = set()  # row + column

        def place(row: int) -> None:
            if row == n:
                boards.append(["." * c + "Q" + "." * (n - c - 1) for c in queens])
                return
            for column in range(n):
                if column in columns or row - column in diagonals or row + column in anti_diagonals:
                    continue
                queens.append(column)
                columns.add(column)
                diagonals.add(row - column)
                anti_diagonals.add(row + column)
                place(row + 1)
                queens.pop()
                columns.remove(column)
                diagonals.remove(row - column)
                anti_diagonals.remove(row + column)

        place(0)
        return boards
