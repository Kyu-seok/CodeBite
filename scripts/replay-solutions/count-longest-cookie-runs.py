class Solution:
    def countLongestTrail(self, nums: list[int]) -> int:
        n = len(nums)
        length = [1] * n  # longest increasing trail ending at i
        count = [1] * n   # how many trails reach that length
        for i in range(n):
            for j in range(i):
                if nums[j] < nums[i]:
                    if length[j] + 1 > length[i]:
                        length[i] = length[j] + 1
                        count[i] = count[j]
                    elif length[j] + 1 == length[i]:
                        count[i] += count[j]
        longest = max(length)
        return sum(c for l, c in zip(length, count) if l == longest)
