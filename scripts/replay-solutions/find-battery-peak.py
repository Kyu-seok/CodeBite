class Solution:
    def find_peak_element(self, readings: list[int]) -> int:
        # Climb toward the higher neighbor: a peak always lies on the rising side.
        low, high = 0, len(readings) - 1
        while low < high:
            mid = (low + high) // 2
            if readings[mid] < readings[mid + 1]:
                low = mid + 1
            else:
                high = mid
        return low
