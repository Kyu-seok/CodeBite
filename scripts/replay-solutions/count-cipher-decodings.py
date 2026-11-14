class Solution:
    def count_decodings(self, digits: str) -> int:
        if not digits or digits[0] == "0":
            return 0
        # Decodings of the prefix one shorter and of the prefix so far.
        before, current = 1, 1
        for i in range(1, len(digits)):
            ways = current if digits[i] != "0" else 0
            if 10 <= int(digits[i - 1:i + 1]) <= 26:
                ways += before
            before, current = current, ways
        return current
