class Solution:
    def countReservoirPaths(self, n: int) -> int:
        previous, current = 1, 1
        for _ in range(n - 1):
            previous, current = current, previous + current
        return current
