from collections import Counter


class Solution:
    def k_distinct_window(self, queue: str, k: int) -> int:
        if k == 0:
            return 0
        window: Counter[str] = Counter()
        best = 0
        left = 0
        for right, tag in enumerate(queue):
            window[tag] += 1
            while len(window) > k:
                window[queue[left]] -= 1
                if window[queue[left]] == 0:
                    del window[queue[left]]
                left += 1
            best = max(best, right - left + 1)
        return best
