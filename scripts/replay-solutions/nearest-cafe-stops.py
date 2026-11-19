import heapq


class Solution:
    def selectNearestStops(self, stops: list[list[int]], k: int) -> list[list[int]]:
        # A max-heap (heapq on negated squared distances) of the k nearest stops so far: its root is the
        # farthest of them, so a stop nearer than the root replaces it and any other can't be among the k.
        heap = []
        for x, y in stops:
            d = x * x + y * y
            if len(heap) < k:
                heapq.heappush(heap, (-d, x, y))
            elif d < -heap[0][0]:
                heapq.heapreplace(heap, (-d, x, y))
        return [[x, y] for _, x, y in heap]
