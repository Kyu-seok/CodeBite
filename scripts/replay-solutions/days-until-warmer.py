class Solution:
    def daysToUpgrade(self, readings: list[int]) -> list[int]:
        waits = [0] * len(readings)
        pending: list[int] = []  # days still waiting for a higher reading
        for day, reading in enumerate(readings):
            while pending and readings[pending[-1]] < reading:
                earlier = pending.pop()
                waits[earlier] = day - earlier
            pending.append(day)
        return waits
