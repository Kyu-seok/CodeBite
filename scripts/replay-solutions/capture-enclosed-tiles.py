class Solution:
    def seizeEnclosedZones(self, board: list[list[str]]) -> list[list[str]]:
        rows, cols = len(board), len(board[0])
        # Mark every 'O' reachable from the border as safe ('S'), then flip the rest.
        stack = [(r, c) for r in range(rows) for c in range(cols)
                 if (r in (0, rows - 1) or c in (0, cols - 1)) and board[r][c] == 'O']
        while stack:
            r, c = stack.pop()
            if 0 <= r < rows and 0 <= c < cols and board[r][c] == 'O':
                board[r][c] = 'S'
                stack.extend(((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)))
        for row in board:
            for c, cell in enumerate(row):
                row[c] = 'O' if cell == 'S' else 'X'
        return board
