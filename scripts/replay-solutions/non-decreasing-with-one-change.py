class Solution:
    def canBeNonDecreasing(self, nums: list[int]) -> bool:
        nums = list(nums)
        changed = False
        for i in range(1, len(nums)):
            if nums[i] < nums[i - 1]:
                if changed:
                    return False
                changed = True
                # Lowering the earlier element is best; if that would break order behind it, raise this one.
                if i >= 2 and nums[i] < nums[i - 2]:
                    nums[i] = nums[i - 1]
        return True
