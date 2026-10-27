class Solution:
    def peakReadingSum(self, nums: list[int]) -> int:
        best = current = nums[0]
        for score in nums[1:]:
            current = max(score, current + score)
            best = max(best, current)
        return best
