class Solution:
    def perfect_sum(self, n: int) -> int:
        squares = [i * i for i in range(1, int(n ** 0.5) + 1)]
        fewest = [0] + [n] * n  # fewest[a]: fewest bags summing to a
        for amount in range(1, n + 1):
            for square in squares:
                if square > amount:
                    break
                fewest[amount] = min(fewest[amount], fewest[amount - square] + 1)
        return fewest[n]
