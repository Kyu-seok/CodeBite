class Solution:
    def reverseFlags(self, statusWord: int) -> int:
        result = 0
        for i in range(32):
            if statusWord >> i & 1:
                result |= 1 << (31 - i)  # bit i lands at position 31 - i
        return result
