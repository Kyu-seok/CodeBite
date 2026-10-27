class Solution:
    def isReversibleCode(self, code: int) -> bool:
        text = str(code)
        return text == text[::-1]
