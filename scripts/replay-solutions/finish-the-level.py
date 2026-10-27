class Solution:
    def canFinishLine(self, slack: list[int]) -> bool:
        farthest = 0
        for tile, jump in enumerate(slack):
            if tile > farthest:
                return False
            farthest = max(farthest, tile + jump)
        return True
