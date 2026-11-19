class Solution:
    def captureEnclosedTiles(self, board: list[list[str]]) -> None:
        rows, cols = len(board), len(board[0])
        # Mark every 'O' on the border safe ('S') and flood from it, marking each 'O' safe as it is pushed;
        # then flip the rest: 'O' to 'X', and 'S' back to 'O'.
        stack = []
        for r in range(rows):
            for c in range(cols):
                if (r in (0, rows - 1) or c in (0, cols - 1)) and board[r][c] == 'O':
                    board[r][c] = 'S'
                    stack.append((r, c))
        while stack:
            r, c = stack.pop()
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if 0 <= nr < rows and 0 <= nc < cols and board[nr][nc] == 'O':
                    board[nr][nc] = 'S'
                    stack.append((nr, nc))
        for row in board:
            for c, cell in enumerate(row):
                row[c] = 'O' if cell == 'S' else 'X'
