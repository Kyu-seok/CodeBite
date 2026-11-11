from collections import Counter


class Solution:
    def longestSameLetterRun(self, s: str, k: int) -> int:
        counts: Counter[str] = Counter()
        start = 0
        top = 0
        best = 0
        for end, letter in enumerate(s):
            counts[letter] += 1
            top = max(top, counts[letter])
            while end - start + 1 - top > k:
                counts[s[start]] -= 1
                start += 1
            best = max(best, end - start + 1)
        return best
