class Solution:
    def bestBakeOrder(self, nums: list[int]) -> int:
        values = [1, *nums, 1]
        n = len(values)
        # best[left][right] = most points from popping every balloon strictly between left and right,
        # choosing which one is popped last
        best = [[0] * n for _ in range(n)]
        for gap in range(2, n):
            for left in range(n - gap):
                right = left + gap
                edge = values[left] * values[right]
                row = best[left]
                row[right] = max(
                    row[last] + best[last][right] + edge * values[last] for last in range(left + 1, right)
                )
        return best[0][n - 1]
