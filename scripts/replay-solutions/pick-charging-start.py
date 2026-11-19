class Solution:
    def pickStartStop(self, energy: list[int], drain: list[int]) -> int:
        if sum(energy) < sum(drain):
            return -1
        start = 0
        tank = 0
        for i, (gain, use) in enumerate(zip(energy, drain)):
            tank += gain - use
            if tank < 0:
                start = i + 1
                tank = 0
        return start
