from collections import defaultdict


class Solution:
    def resolvePriceRatios(self, equations: list[list[str]], values: list[float],
                           queries: list[list[str]]) -> list[float]:
        graph: dict[str, list[tuple[str, float]]] = defaultdict(list)
        for (a, b), value in zip(equations, values):
            graph[a].append((b, value))
            graph[b].append((a, 1 / value))

        def ratio(start: str, goal: str) -> float:
            if start not in graph or goal not in graph:
                return -1.0
            seen = {start}
            stack = [(start, 1.0)]
            while stack:
                node, product = stack.pop()
                if node == goal:
                    return product
                for neighbour, value in graph[node]:
                    if neighbour not in seen:
                        seen.add(neighbour)
                        stack.append((neighbour, product * value))
            return -1.0

        return [ratio(c, d) for c, d in queries]
