from itertools import permutations


class Solution:
    def listStationOrders(self, stops: list[int]) -> list[list[int]]:
        return [list(order) for order in permutations(stops)]
