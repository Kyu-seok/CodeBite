class Solution:
    def can_complete_circuit(self, energy: list[int], drain: list[int]) -> int:
        if sum(energy) < sum(drain):
            return -1
        start = 0
        tank = 0
        for i, (gain, cost) in enumerate(zip(energy, drain)):
            tank += gain - cost
            if tank < 0:
                start = i + 1
                tank = 0
        return start
