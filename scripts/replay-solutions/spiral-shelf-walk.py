class Solution:
    def traceOutwardWalk(self, board: list[list[int]]) -> list[int]:
        result: list[int] = []
        if not board or not board[0]:
            return result
        top, bottom = 0, len(board) - 1
        left, right = 0, len(board[0]) - 1
        while top <= bottom and left <= right:
            for c in range(left, right + 1):
                result.append(board[top][c])
            for r in range(top + 1, bottom + 1):
                result.append(board[r][right])
            if top < bottom:
                for c in range(right - 1, left - 1, -1):
                    result.append(board[bottom][c])
            if left < right:
                for r in range(bottom - 1, top, -1):
                    result.append(board[r][left])
            top, bottom, left, right = top + 1, bottom - 1, left + 1, right - 1
        return result
