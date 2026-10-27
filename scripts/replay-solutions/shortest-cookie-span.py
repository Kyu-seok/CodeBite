class Solution:
    def shortestBakeSpan(self, trays: list[int], target: int) -> int:
        best = len(trays) + 1
        total = 0
        left = 0
        for right, cookies in enumerate(trays):
            total += cookies
            while total >= target and left <= right:
                best = min(best, right - left + 1)
                total -= trays[left]
                left += 1
        return best if best <= len(trays) else 0
