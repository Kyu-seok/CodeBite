class Solution:
    def detectFlowValue(self, menu: list[list[int]], target: int) -> bool:
        if not menu or not menu[0]:
            return False
        cols = len(menu[0])
        low, high = 0, len(menu) * cols - 1
        while low <= high:
            mid = (low + high) // 2
            value = menu[mid // cols][mid % cols]
            if value == target:
                return True
            if value < target:
                low = mid + 1
            else:
                high = mid - 1
        return False
