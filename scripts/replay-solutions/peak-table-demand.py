import heapq


class Solution:
    def min_meeting_rooms(self, visits: list[list[int]]) -> int:
        leaving: list[int] = []
        for arrive, leave in sorted(visits):
            if leaving and leaving[0] <= arrive:
                heapq.heapreplace(leaving, leave)
            else:
                heapq.heappush(leaving, leave)
        return len(leaving)
