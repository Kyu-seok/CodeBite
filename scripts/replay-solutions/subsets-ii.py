class Solution:
    def subsetsWithDup(self, nums: list[int]) -> list[list[int]]:
        nums = sorted(nums)
        subsets: list[list[int]] = []

        def build(start: int, chosen: list[int]) -> None:
            subsets.append(chosen[:])
            for i in range(start, len(nums)):
                if i > start and nums[i] == nums[i - 1]:
                    continue
                chosen.append(nums[i])
                build(i + 1, chosen)
                chosen.pop()

        build(0, [])
        return subsets
