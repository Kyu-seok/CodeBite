import heapq


class Solution:
    def last_stone_weight(self, blocks: list[int]) -> int:
        pile = [-weight for weight in blocks]
        heapq.heapify(pile)
        while len(pile) > 1:
            heaviest = -heapq.heappop(pile)
            second = -heapq.heappop(pile)
            if heaviest != second:
                heapq.heappush(pile, -(heaviest - second))
        return -pile[0] if pile else 0
