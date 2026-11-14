class Solution:
    def reverseFlags(self, statusWord: int) -> int:
        return int(f"{statusWord:032b}"[::-1], 2)
