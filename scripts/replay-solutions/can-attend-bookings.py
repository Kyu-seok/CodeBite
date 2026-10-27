from itertools import pairwise


class Solution:
    def verifyTableBookings(self, intervals: list[list[int]]) -> bool:
        return all(earlier[1] <= later[0] for earlier, later in pairwise(sorted(intervals)))
