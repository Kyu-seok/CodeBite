class Solution:
    def tallyPlantedRegions(self, board: list[list[str]]) -> int:
        rows = len(board)
        cols = len(board[0]) if board else 0
        seen: set[tuple[int, int]] = set()
        clusters = 0
        for r in range(rows):
            for c in range(cols):
                if board[r][c] != "1" or (r, c) in seen:
                    continue
                clusters += 1
                seen.add((r, c))
                stack = [(r, c)]
                while stack:
                    y, x = stack.pop()
                    for ny, nx in ((y + 1, x), (y - 1, x), (y, x + 1), (y, x - 1)):
                        if 0 <= ny < rows and 0 <= nx < cols and board[ny][nx] == "1" and (ny, nx) not in seen:
                            seen.add((ny, nx))
                            stack.append((ny, nx))
        return clusters
