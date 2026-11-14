class Solution:
    def findLonelyCandy(self, candies: list[int]) -> int:
        # Pairs cancel out under XOR, leaving the loner.
        loner = 0
        for candy in candies:
            loner ^= candy
        return loner
