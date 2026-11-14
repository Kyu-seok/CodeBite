from itertools import permutations


class Solution:
    def listVisitOrders(self, stops: list[int]) -> list[list[int]]:
        return [list(order) for order in permutations(stops)]
