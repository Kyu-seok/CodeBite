class Solution:
    def relayDispatchCost(self, n: int, flights: list[list[int]], src: int, dst: int, k: int) -> int:
        # Bellman-Ford limited to k + 1 legs (k intermediate cafes).
        cost = [float('inf')] * n
        cost[src] = 0
        for _ in range(k + 1):
            updated = cost[:]
            for start, end, minutes in flights:
                if cost[start] + minutes < updated[end]:
                    updated[end] = cost[start] + minutes
            cost = updated
        return -1 if cost[dst] == float('inf') else cost[dst]
