class Solution:
    def mergeSeatingWindows(self, seatings: list[list[int]]) -> list[list[int]]:
        merged: list[list[int]] = []
        for start, end in sorted(seatings):
            if merged and start <= merged[-1][1]:
                merged[-1][1] = max(merged[-1][1], end)
            else:
                merged.append([start, end])
        return merged
