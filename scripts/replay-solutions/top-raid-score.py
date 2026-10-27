import heapq


class Solution:
    def findBrightestTargets(self, scores: list[int], k: int) -> int:
        return heapq.nlargest(k, scores)[-1]
