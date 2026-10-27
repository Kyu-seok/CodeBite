class Solution:
    def minVanHops(self, fuel: list[int]) -> int:
        jumps = 0
        current_end = 0
        farthest = 0
        for i in range(len(fuel) - 1):
            farthest = max(farthest, i + fuel[i])
            if i == current_end:
                jumps += 1
                current_end = farthest
        return jumps
