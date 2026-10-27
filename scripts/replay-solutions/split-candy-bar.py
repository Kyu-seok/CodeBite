class Solution:
    def break_integer(self, n: int) -> int:
        # best[k] = largest product from k, either kept whole or split further
        best = [0] * (n + 1)
        best[1] = 1
        for total in range(2, n + 1):
            for first in range(1, total):
                rest = max(total - first, best[total - first])
                best[total] = max(best[total], first * rest)
        return best[n]
