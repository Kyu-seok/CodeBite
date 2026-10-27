class Solution:
    def orderTankDeviations(self, drifts: list[int]) -> list[int]:
        result = [0] * len(drifts)
        left, right = 0, len(drifts) - 1
        for slot in range(len(drifts) - 1, -1, -1):
            if abs(drifts[left]) > abs(drifts[right]):
                result[slot] = drifts[left] ** 2
                left += 1
            else:
                result[slot] = drifts[right] ** 2
                right -= 1
        return result
