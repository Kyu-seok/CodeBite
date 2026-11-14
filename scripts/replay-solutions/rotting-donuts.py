class Solution:
    def minutes_until_stale(self, tray: list[list[int]]) -> int:
        rows = len(tray)
        cols = len(tray[0]) if tray else 0
        fresh = sum(row.count(1) for row in tray)
        rotten = [(r, c) for r in range(rows) for c in range(cols) if tray[r][c] == 2]
        minutes = 0
        while rotten and fresh:
            next_wave = []
            for r, c in rotten:
                for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                    if 0 <= nr < rows and 0 <= nc < cols and tray[nr][nc] == 1:
                        tray[nr][nc] = 2
                        fresh -= 1
                        next_wave.append((nr, nc))
            rotten = next_wave
            minutes += 1
        return -1 if fresh else minutes
