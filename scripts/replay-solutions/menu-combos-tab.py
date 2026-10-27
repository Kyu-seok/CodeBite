class Solution:
    def listQuotaBatches(self, pastries: list[int], tab: int) -> list[list[int]]:
        prices = sorted(pastries)
        combos: list[list[int]] = []
        chosen: list[int] = []

        def pick(start: int, remaining: int) -> None:
            if remaining == 0:
                combos.append(chosen.copy())
                return
            for i in range(start, len(prices)):
                if prices[i] > remaining:
                    break
                if i > start and prices[i] == prices[i - 1]:
                    continue
                chosen.append(prices[i])
                pick(i + 1, remaining - prices[i])
                chosen.pop()

        pick(0, tab)
        return combos
