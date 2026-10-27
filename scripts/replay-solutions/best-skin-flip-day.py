class Solution:
    def bestTierResale(self, prices: list[int]) -> int:
        holding = float("-inf")  # best profit while holding a copy
        sold = 0                 # best profit having sold today (cooldown tomorrow)
        resting = 0              # best profit while free to buy
        for price in prices:
            holding, sold, resting = (
                max(holding, resting - price),
                holding + price,
                max(resting, sold),
            )
        return max(sold, resting)
