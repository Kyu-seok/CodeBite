class Solution:
    def nthSmoothBatch(self, n: int) -> int:
        levels = [1]
        i2 = i3 = i5 = 0  # next level to multiply by 2, 3 and 5
        while len(levels) < n:
            following = min(levels[i2] * 2, levels[i3] * 3, levels[i5] * 5)
            levels.append(following)
            if following == levels[i2] * 2:
                i2 += 1
            if following == levels[i3] * 3:
                i3 += 1
            if following == levels[i5] * 5:
                i5 += 1
        return levels[n - 1]
