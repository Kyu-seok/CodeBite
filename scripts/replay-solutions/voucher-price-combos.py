class Solution:
    def listVoucherSums(self, prices: list[int], voucher: int) -> list[list[int]]:
        prices = sorted(prices)
        baskets: list[list[int]] = []

        def build(start: int, remaining: int, basket: list[int]) -> None:
            if remaining == 0:
                baskets.append(basket[:])
                return
            for i in range(start, len(prices)):
                if prices[i] > remaining:
                    break
                basket.append(prices[i])
                build(i, remaining - prices[i], basket)
                basket.pop()

        build(0, voucher, [])
        return baskets
