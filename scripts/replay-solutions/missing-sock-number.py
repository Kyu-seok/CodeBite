class Solution:
    def lowestMissingTarget(self, socks: list[int]) -> int:
        # Put each number k in 1..n at index k - 1; the first index holding the wrong number is the answer.
        n = len(socks)
        for i in range(n):
            while 1 <= socks[i] <= n and socks[socks[i] - 1] != socks[i]:
                target = socks[i] - 1
                socks[i], socks[target] = socks[target], socks[i]
        for i in range(n):
            if socks[i] != i + 1:
                return i + 1
        return n + 1
