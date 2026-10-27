class Solution:
    def erase_overlap_intervals(self, classes: list[list[int]]) -> int:
        dropped = 0
        last_end = float("-inf")
        for start, end in sorted(classes, key=lambda c: c[1]):
            if start >= last_end:
                last_end = end
            else:
                dropped += 1
        return dropped
