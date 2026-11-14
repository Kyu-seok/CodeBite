class Solution:
    def maxProduct(self, nums: list[int]) -> int:
        best = high = low = nums[0]
        for value in nums[1:]:
            candidates = (value, high * value, low * value)
            high, low = max(candidates), min(candidates)
            best = max(best, high)
        return best
