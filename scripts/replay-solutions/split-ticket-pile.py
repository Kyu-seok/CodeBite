class Solution:
    def canSplitLoads(self, nums: list[int]) -> bool:
        total = sum(nums)
        if total % 2:
            return False
        reachable = {0}  # sums some subset of the tickets seen so far adds up to
        for num in nums:
            reachable |= {s + num for s in reachable}
        return total // 2 in reachable
