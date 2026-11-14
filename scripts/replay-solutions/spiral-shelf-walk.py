class Solution:
    def spiralOrder(self, shelf: list[list[int]]) -> list[int]:
        result: list[int] = []
        if not shelf or not shelf[0]:
            return result
        top, bottom = 0, len(shelf) - 1
        left, right = 0, len(shelf[0]) - 1
        while top <= bottom and left <= right:
            for c in range(left, right + 1):
                result.append(shelf[top][c])
            for r in range(top + 1, bottom + 1):
                result.append(shelf[r][right])
            if top < bottom:
                for c in range(right - 1, left - 1, -1):
                    result.append(shelf[bottom][c])
            if left < right:
                for r in range(bottom - 1, top, -1):
                    result.append(shelf[r][left])
            top, bottom, left, right = top + 1, bottom - 1, left + 1, right - 1
        return result
