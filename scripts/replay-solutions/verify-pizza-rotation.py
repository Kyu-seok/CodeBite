class Solution:
    def verifyBakeOrder(self, nums: list[int]) -> bool:
        trays = list(nums)
        changed = False
        for i in range(1, len(trays)):
            if trays[i] < trays[i - 1]:
                if changed:
                    return False
                changed = True
                # Lowering the earlier slot is best; if that would break order behind it, raise this one.
                if i >= 2 and trays[i] < trays[i - 2]:
                    trays[i] = trays[i - 1]
        return True
