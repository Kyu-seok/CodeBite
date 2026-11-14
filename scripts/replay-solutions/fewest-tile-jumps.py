class Solution:
    def minJumps(self, maxJump: list[int]) -> int:
        jumps = 0
        current_end = 0
        farthest = 0
        for i in range(len(maxJump) - 1):
            farthest = max(farthest, i + maxJump[i])
            if i == current_end:
                jumps += 1
                current_end = farthest
        return jumps
