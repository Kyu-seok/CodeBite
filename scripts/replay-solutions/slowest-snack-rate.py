class Solution:
    def min_eating_speed(self, piles: list[int], hours: int) -> int:
        low, high = 1, max(piles)
        while low < high:
            speed = (low + high) // 2
            needed = sum((pile + speed - 1) // speed for pile in piles)
            if needed <= hours:
                high = speed
            else:
                low = speed + 1
        return low
