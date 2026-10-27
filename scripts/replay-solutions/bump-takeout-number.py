class Solution:
    def bumpParcelCode(self, digits: list[int]) -> list[int]:
        result = digits[:]
        for i in range(len(result) - 1, -1, -1):
            if result[i] < 9:
                result[i] += 1
                return result
            result[i] = 0
        return [1] + result
