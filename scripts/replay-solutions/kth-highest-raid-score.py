import heapq


class Solution:
    def kthHighestScore(self, scores: list[int], k: int) -> int:
        return heapq.nlargest(k, scores)[-1]
