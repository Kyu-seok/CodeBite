MASK = 0xFFFFFFFF  # Python ints are unbounded, so work in 32-bit two's complement
SIGN_BIT = 0x80000000


class Solution:
    def combineCounters(self, firstCount: int, secondCount: int) -> int:
        a, b = firstCount & MASK, secondCount & MASK
        while b:
            a, b = (a ^ b) & MASK, ((a & b) << 1) & MASK
        return a if a < SIGN_BIT else ~(a ^ MASK)
