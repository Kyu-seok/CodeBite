class Solution:
    def pairTiersBudget(self, menuPrice: list[int], budget: int) -> list[int]:
        left, right = 0, len(menuPrice) - 1
        while left < right:
            total = menuPrice[left] + menuPrice[right]
            if total == budget:
                return [left + 1, right + 1]
            if total < budget:
                left += 1
            else:
                right -= 1
        return []
