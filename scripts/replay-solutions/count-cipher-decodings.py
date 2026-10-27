class Solution:
    def num_decodings(self, scan: str) -> int:
        if not scan or scan[0] == "0":
            return 0
        # Decodings of the prefix one shorter and of the prefix so far.
        before, current = 1, 1
        for i in range(1, len(scan)):
            ways = current if scan[i] != "0" else 0
            if 10 <= int(scan[i - 1:i + 1]) <= 26:
                ways += before
            before, current = current, ways
        return current
