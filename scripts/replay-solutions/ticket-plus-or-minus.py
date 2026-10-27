from collections import Counter


class Solution:
    def partitionTankDoses(self, nums: list[int], target: int) -> int:
        ways = Counter({0: 1})  # net score -> number of sign assignments reaching it
        for value in nums:
            following: Counter[int] = Counter()
            for total, count in ways.items():
                following[total + value] += count
                following[total - value] += count
            ways = following
        return ways[target]
