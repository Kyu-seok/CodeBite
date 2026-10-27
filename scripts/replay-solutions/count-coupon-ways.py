class Solution:
    def countCouponCombos(self, amount: int, coins: list[int]) -> int:
        # Adding one coupon value at a time counts each combination once, regardless of order.
        ways = [1] + [0] * amount
        for coin in coins:
            for total in range(coin, amount + 1):
                ways[total] += ways[total - coin]
        return ways[amount]
