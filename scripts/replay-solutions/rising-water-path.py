import heapq


class Solution:
    def crossFloodedCorridors(self, grid: list[list[int]]) -> int:
        # Always step onto the lowest tile bordering the explored area.
        n = len(grid)
        seen = {(0, 0)}
        heap = [(grid[0][0], 0, 0)]
        highest = 0
        while heap:
            height, r, c = heapq.heappop(heap)
            highest = max(highest, height)
            if (r, c) == (n - 1, n - 1):
                return highest
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if 0 <= nr < n and 0 <= nc < n and (nr, nc) not in seen:
                    seen.add((nr, nc))
                    heapq.heappush(heap, (grid[nr][nc], nr, nc))
        return highest
