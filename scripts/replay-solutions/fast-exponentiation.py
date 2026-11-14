class Solution:
    def power(self, base: float, exponent: int) -> float:
        if exponent < 0:
            base, exponent = 1 / base, -exponent
        result = 1.0
        while exponent:
            if exponent & 1:
                result *= base
            base *= base
            exponent >>= 1
        return result
