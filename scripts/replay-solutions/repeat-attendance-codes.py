class Solution:
    def listRepeatedCodes(self, codes: list[int]) -> list[int]:
        repeated: list[int] = []
        for code in codes:
            index = abs(code) - 1
            if codes[index] < 0:
                repeated.append(abs(code))
            else:
                codes[index] = -codes[index]
        return repeated
