class Solution:
    def findUnpairedFrame(self, frames: list[int]) -> int:
        # Pairs cancel out under XOR, leaving the loner.
        loner = 0
        for frame in frames:
            loner ^= frame
        return loner
