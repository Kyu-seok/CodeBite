from collections import Counter


class Solution:
    def matchesZoneAnagram(self, pattern: str, log: str) -> bool:
        size = len(pattern)
        if size > len(log):
            return False
        need = Counter(pattern)
        window = Counter(log[:size])
        if window == need:
            return True
        for i in range(size, len(log)):
            window[log[i]] += 1
            window[log[i - size]] -= 1
            if window == need:
                return True
        return False
