import heapq
from collections import defaultdict


class Solution:
    def propagateAlertWave(self, edges: list[list[int]], n: int, src: int) -> int:
        graph: dict[int, list[tuple[int, int]]] = defaultdict(list)
        for source, target, minutes in edges:
            graph[source].append((target, minutes))
        arrival: dict[int, int] = {}
        heap = [(0, src)]
        while heap:
            time, player = heapq.heappop(heap)
            if player in arrival:
                continue
            arrival[player] = time
            for target, minutes in graph[player]:
                if target not in arrival:
                    heapq.heappush(heap, (time + minutes, target))
        return max(arrival.values()) if len(arrival) == n else -1
