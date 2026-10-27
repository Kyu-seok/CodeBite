class Solution:
    def spotCatalogTarget(self, catalog: list[int], target: int) -> int:
        low, high = 0, len(catalog) - 1
        while low <= high:
            mid = (low + high) // 2
            if catalog[mid] == target:
                return mid
            if catalog[low] <= catalog[mid]:  # left half is sorted
                if catalog[low] <= target < catalog[mid]:
                    high = mid - 1
                else:
                    low = mid + 1
            else:  # right half is sorted
                if catalog[mid] < target <= catalog[high]:
                    low = mid + 1
                else:
                    high = mid - 1
        return -1
