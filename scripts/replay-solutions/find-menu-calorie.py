class Solution:
    def probeSugarReading(self, menu: list[list[int]], target: int) -> bool:
        if not menu or not menu[0]:
            return False
        row, col = 0, len(menu[0]) - 1
        while row < len(menu) and col >= 0:
            value = menu[row][col]
            if value == target:
                return True
            if value > target:
                col -= 1
            else:
                row += 1
        return False
