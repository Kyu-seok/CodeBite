class Solution:
    def tallyPriorityFlags(self, upperId: int) -> list[int]:
        counts = [0] * (upperId + 1)
        for i in range(1, upperId + 1):
            # i & (i - 1) is i with its lowest 1 bit cleared: a smaller number, already counted.
            counts[i] = counts[i & (i - 1)] + 1
        return counts
