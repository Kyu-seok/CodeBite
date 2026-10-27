from collections import Counter


class Solution:
    def countWindowTallies(self, readings: list[int], k: int) -> int:
        seen = Counter({0: 1})
        total = 0
        count = 0
        for reading in readings:
            total += reading
            count += seen[total - k]
            seen[total] += 1
        return count
