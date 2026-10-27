class Solution:
    def quadTrayDemand(self, trays: list[int], demand: int) -> list[list[int]]:
        nums = sorted(trays)
        n = len(nums)
        result: list[list[int]] = []
        for a in range(n - 3):
            if a > 0 and nums[a] == nums[a - 1]:
                continue
            for b in range(a + 1, n - 2):
                if b > a + 1 and nums[b] == nums[b - 1]:
                    continue
                low, high = b + 1, n - 1
                while low < high:
                    total = nums[a] + nums[b] + nums[low] + nums[high]
                    if total < demand:
                        low += 1
                    elif total > demand:
                        high -= 1
                    else:
                        result.append([nums[a], nums[b], nums[low], nums[high]])
                        low += 1
                        while low < high and nums[low] == nums[low - 1]:
                            low += 1
                        high -= 1
        return result
