class Solution:
    def scheduleObservingWindow(self, slots: list[list[int]], newSlot: list[int]) -> list[list[int]]:
        start, end = newSlot
        result: list[list[int]] = []
        i = 0
        while i < len(slots) and slots[i][1] < start:
            result.append(slots[i])
            i += 1
        while i < len(slots) and slots[i][0] <= end:
            start = min(start, slots[i][0])
            end = max(end, slots[i][1])
            i += 1
        result.append([start, end])
        result.extend(slots[i:])
        return result
