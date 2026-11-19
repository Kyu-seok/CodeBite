class Solution:
    def cheapestRoute(self, n: int, links: list[list[int]], src: int, dst: int, maxStops: int) -> int:
        # Bellman-Ford limited to maxStops + 1 legs (maxStops stops).
        cost = [float('inf')] * n
        cost[src] = 0
        for _ in range(maxStops + 1):
            updated = cost[:]
            for start, end, price in links:
                if cost[start] + price < updated[end]:
                    updated[end] = cost[start] + price
            cost = updated
        return -1 if cost[dst] == float('inf') else cost[dst]
