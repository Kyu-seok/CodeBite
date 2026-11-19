class Solution:
    def findVacantSlot(self, lockers: list[int]) -> int:
        # Every number 0..n is XORed in once from the range and once from the list, except the missing one,
        # so the pairs cancel (x ^ x = 0) and only it is left.
        missing = len(lockers)
        for i, locker in enumerate(lockers):
            missing ^= i ^ locker
        return missing
