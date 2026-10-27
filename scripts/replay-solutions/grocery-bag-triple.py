class Solution:
    def canBuildBales(self, triplets: list[list[int]], target: list[int]) -> bool:
        # Taking every usable bag never hurts; it only has to reach each cap somewhere.
        reached = [False, False, False]
        for bag in triplets:
            if all(reading <= cap for reading, cap in zip(bag, target)):
                for channel in range(3):
                    if bag[channel] == target[channel]:
                        reached[channel] = True
        return all(reached)
