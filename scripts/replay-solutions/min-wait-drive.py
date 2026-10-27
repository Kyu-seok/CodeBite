class Solution:
    def cheapest_path(self, grid: list[list[int]]) -> int:
        cols = len(grid[0])
        # cost[c] = smallest wait to reach column c of the current row
        cost = [float("inf")] * cols
        cost[0] = 0
        for row in grid:
            cost[0] += row[0]
            for c in range(1, cols):
                cost[c] = min(cost[c], cost[c - 1]) + row[c]
        return cost[-1]
