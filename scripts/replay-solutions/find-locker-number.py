class Solution:
    def locateCallNumber(self, shelf: list[int], target: int) -> int:
        low, high = 0, len(shelf) - 1
        while low <= high:
            mid = (low + high) // 2
            if shelf[mid] == target:
                return mid
            if shelf[mid] < target:
                low = mid + 1
            else:
                high = mid - 1
        return -1
