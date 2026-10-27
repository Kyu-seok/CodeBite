class Solution:
    def findWords(self, board: list[list[str]], words: list[str]) -> list[str]:
        trie: dict = {}
        for word in words:
            node = trie
            for letter in word:
                node = node.setdefault(letter, {})
            node["$"] = word

        rows, cols = len(board), len(board[0])
        found: list[str] = []

        def search(r: int, c: int, parent: dict) -> None:
            letter = board[r][c]
            node = parent[letter]
            if "$" in node:
                found.append(node.pop("$"))
            board[r][c] = "#"
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if 0 <= nr < rows and 0 <= nc < cols and board[nr][nc] in node:
                    search(nr, nc, node)
            board[r][c] = letter
            if not node:
                parent.pop(letter)  # prune finished branches

        for r in range(rows):
            for c in range(cols):
                if board[r][c] in trie:
                    search(r, c, trie)
        return found
