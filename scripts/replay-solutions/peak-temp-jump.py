class Solution:
    def maxTempSwing(self, readings: list[int]) -> int:
        lowest = float("inf")
        best = 0
        for reading in readings:
            lowest = min(lowest, reading)
            best = max(best, reading - lowest)
        return best
