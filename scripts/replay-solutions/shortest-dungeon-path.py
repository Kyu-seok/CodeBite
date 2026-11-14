from collections import deque


class Solution:
    def shortestPathLength(self, board: list[list[int]]) -> int:
        n = len(board)
        if board[0][0] or board[n - 1][n - 1]:
            return -1
        tiles = [[0] * n for _ in range(n)]  # tiles on the shortest path so far; 0 = unvisited
        tiles[0][0] = 1
        queue = deque([(0, 0)])
        while queue:
            r, c = queue.popleft()
            if (r, c) == (n - 1, n - 1):
                return tiles[r][c]
            for dr in (-1, 0, 1):
                for dc in (-1, 0, 1):
                    nr, nc = r + dr, c + dc
                    if 0 <= nr < n and 0 <= nc < n and board[nr][nc] == 0 and tiles[nr][nc] == 0:
                        tiles[nr][nc] = tiles[r][c] + 1
                        queue.append((nr, nc))
        return -1
