class Solution:
    def traceDualDrainage(self, field: list[list[int]]) -> list[list[int]]:
        if not field or not field[0]:
            return []
        rows, cols = len(field), len(field[0])

        def reachable(starts: list[tuple[int, int]]) -> set[tuple[int, int]]:
            seen = set(starts)
            stack = list(starts)
            while stack:
                r, c = stack.pop()
                for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                    if (0 <= nr < rows and 0 <= nc < cols and (nr, nc) not in seen
                            and field[nr][nc] >= field[r][c]):
                        seen.add((nr, nc))
                        stack.append((nr, nc))
            return seen

        top_left = reachable([(0, c) for c in range(cols)] + [(r, 0) for r in range(rows)])
        bottom_right = reachable([(rows - 1, c) for c in range(cols)] + [(r, cols - 1) for r in range(rows)])
        return [[r, c] for r, c in sorted(top_left & bottom_right)]
