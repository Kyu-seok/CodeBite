import heapq
from collections import Counter, deque


class Solution:
    def minPrintSlots(self, jobs: list[str], n: int) -> int:
        # Each slot prints the label with the most jobs left among those not cooling down (a max-heap of
        # counts, the earlier label first on a tie); a printed label waits in a queue until n slots have passed.
        heap = [(-count, label) for label, count in Counter(jobs).items()]
        heapq.heapify(heap)
        waiting = deque()  # (slot it may print again, -count left, label), in the order they were printed
        slot = 0
        while heap or waiting:
            if waiting and waiting[0][0] == slot:
                _, count, label = waiting.popleft()
                heapq.heappush(heap, (count, label))
            if heap:
                count, label = heapq.heappop(heap)
                if count + 1 < 0:
                    waiting.append((slot + n + 1, count + 1, label))
            slot += 1
        return slot
