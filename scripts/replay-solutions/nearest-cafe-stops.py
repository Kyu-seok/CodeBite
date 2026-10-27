import heapq


class Solution:
    def k_closest(self, stops: list[list[int]], k: int) -> list[list[int]]:
        return heapq.nsmallest(k, stops, key=lambda p: p[0] * p[0] + p[1] * p[1])
