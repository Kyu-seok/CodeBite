class Solution:
    def tallyPriorityFlags(self, upperId: int) -> list[int]:
        counts = [0] * (upperId + 1)
        for i in range(1, upperId + 1):
            counts[i] = counts[i >> 1] + (i & 1)
        return counts
