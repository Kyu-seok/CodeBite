class Solution:
    def frameLargestBale(self, lockers: list[int]) -> int:
        left, right = 0, len(lockers) - 1
        best = 0
        while left < right:
            best = max(best, min(lockers[left], lockers[right]) * (right - left))
            if lockers[left] < lockers[right]:
                left += 1
            else:
                right -= 1
        return best
