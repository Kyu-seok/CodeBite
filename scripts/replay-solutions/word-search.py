from collections import Counter


class Solution:
    def exist(self, board: list[list[str]], word: str) -> bool:
        rows, cols = len(board), len(board[0])
        available = Counter(letter for row in board for letter in row)
        if any(available[letter] < count for letter, count in Counter(word).items()):
            return False
        # Start from the rarer end to prune sooner.
        if available[word[0]] > available[word[-1]]:
            word = word[::-1]

        def search(r: int, c: int, i: int) -> bool:
            if i == len(word):
                return True
            if not (0 <= r < rows and 0 <= c < cols) or board[r][c] != word[i]:
                return False
            board[r][c] = "#"
            found = (search(r + 1, c, i + 1) or search(r - 1, c, i + 1)
                     or search(r, c + 1, i + 1) or search(r, c - 1, i + 1))
            board[r][c] = word[i]
            return found

        return any(search(r, c, 0) for r in range(rows) for c in range(cols))
