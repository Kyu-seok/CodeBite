class Solution:
    def fewestBags(self, candies: int) -> int:
        squares = [i * i for i in range(1, int(candies ** 0.5) + 1)]
        fewest = [0] + [candies] * candies  # fewest[a]: fewest bags summing to a
        for amount in range(1, candies + 1):
            for square in squares:
                if square > amount:
                    break
                fewest[amount] = min(fewest[amount], fewest[amount - square] + 1)
        return fewest[candies]
