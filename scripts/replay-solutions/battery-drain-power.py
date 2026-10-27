class Solution:
    def raiseForecastFactor(self, base: float, step: int) -> float:
        if step < 0:
            base, step = 1 / base, -step
        result = 1.0
        while step:
            if step & 1:
                result *= base
            base *= base
            step >>= 1
        return result
