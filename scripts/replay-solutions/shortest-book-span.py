from collections import Counter


class Solution:
    def shortestShelfSpan(self, shelf: str, needed: str) -> str:
        if not needed:
            return ""
        missing = Counter(needed)
        to_cover = len(needed)
        start = 0
        best_start, best_len = 0, len(shelf) + 1
        for end, tag in enumerate(shelf):
            if missing[tag] > 0:
                to_cover -= 1
            missing[tag] -= 1
            while to_cover == 0:
                if end - start + 1 < best_len:
                    best_start, best_len = start, end - start + 1
                missing[shelf[start]] += 1
                if missing[shelf[start]] > 0:
                    to_cover += 1
                start += 1
        return shelf[best_start:best_start + best_len] if best_len <= len(shelf) else ""
