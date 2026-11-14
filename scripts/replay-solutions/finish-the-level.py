class Solution:
    def canFinishLevel(self, jumps: list[int]) -> bool:
        farthest = 0
        for tile, jump in enumerate(jumps):
            if tile > farthest:
                return False
            farthest = max(farthest, tile + jump)
        return True
