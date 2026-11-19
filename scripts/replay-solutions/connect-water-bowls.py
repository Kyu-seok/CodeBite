class Solution:
    def minHoseLength(self, bowls: list[list[int]]) -> int:
        # Prim's algorithm on the complete graph, O(n^2).
        n = len(bowls)
        best = [float('inf')] * n  # cheapest hose from the tree to each bowl
        best[0] = 0
        in_tree = [False] * n
        total = 0
        for _ in range(n):
            node = min((i for i in range(n) if not in_tree[i]), key=best.__getitem__)
            in_tree[node] = True
            total += best[node]
            x, y = bowls[node]
            for i in range(n):
                if not in_tree[i]:
                    cost = abs(x - bowls[i][0]) + abs(y - bowls[i][1])
                    if cost < best[i]:
                        best[i] = cost
        return total
