class Solution:
    def compactShelf(self, books: list[int]) -> int:
        if not books:
            return 0
        k = 1
        for i in range(1, len(books)):
            if books[i] != books[k - 1]:
                books[k] = books[i]
                k += 1
        return k
