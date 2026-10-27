from collections import deque


class Solution:
    def peakFlowPerStretch(self, combo: list[int], k: int) -> list[int]:
        # Indices in the deque hold decreasing values; the front is the window's max.
        window: deque[int] = deque()
        peaks: list[int] = []
        for i, value in enumerate(combo):
            while window and combo[window[-1]] <= value:
                window.pop()
            window.append(i)
            if window[0] <= i - k:
                window.popleft()
            if i >= k - 1:
                peaks.append(combo[window[0]])
        return peaks
