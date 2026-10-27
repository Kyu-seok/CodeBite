from collections import defaultdict


class Solution:
    def find_itinerary(self, tickets: list[list[str]]) -> list[str]:
        # Hierholzer's algorithm, always taking the smallest remaining street first.
        outgoing: dict[str, list[str]] = defaultdict(list)
        for start, end in sorted(tickets, reverse=True):
            outgoing[start].append(end)
        walk: list[str] = []
        stack = ["HUB"]
        while stack:
            if outgoing[stack[-1]]:
                stack.append(outgoing[stack[-1]].pop())
            else:
                walk.append(stack.pop())
        return walk[::-1]
