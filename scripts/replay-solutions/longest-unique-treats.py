from collections import Counter


class Solution:
    def fruit_picker(self, treats: list[int]) -> int:
        window: Counter[int] = Counter()
        best = 0
        left = 0
        for right, flavor in enumerate(treats):
            window[flavor] += 1
            while len(window) > 2:
                window[treats[left]] -= 1
                if window[treats[left]] == 0:
                    del window[treats[left]]
                left += 1
            best = max(best, right - left + 1)
        return best
