class Solution:
    def findVacantSlot(self, lockers: list[int]) -> int:
        n = len(lockers)
        return n * (n + 1) // 2 - sum(lockers)
