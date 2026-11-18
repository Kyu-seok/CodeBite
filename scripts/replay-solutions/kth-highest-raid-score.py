import heapq


class Solution:
    def kthHighestScore(self, scores: list[int], k: int) -> int:
        heap: list[int] = []  # min-heap of the k highest scores so far; its root is the k-th highest
        for score in scores:
            if len(heap) < k:
                heapq.heappush(heap, score)
            elif score > heap[0]:
                heapq.heapreplace(heap, score)
        return heap[0]
