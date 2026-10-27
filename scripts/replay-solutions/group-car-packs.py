class Solution:
    def groupTrainPacks(self, target: int, position: list[int], speed: list[int]) -> int:
        packs = 0
        slowest_arrival = 0.0
        for start, pace in sorted(zip(position, speed), reverse=True):
            arrival = (target - start) / pace
            if arrival > slowest_arrival:
                packs += 1
                slowest_arrival = arrival
        return packs
