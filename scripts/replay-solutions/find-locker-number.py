class Solution:
    def findLocker(self, lockers: list[int], target: int) -> int:
        low, high = 0, len(lockers) - 1
        while low <= high:
            mid = (low + high) // 2
            if lockers[mid] == target:
                return mid
            if lockers[mid] < target:
                low = mid + 1
            else:
                high = mid - 1
        return -1
