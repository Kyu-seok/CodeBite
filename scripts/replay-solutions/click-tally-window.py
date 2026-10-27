from collections import deque


class ClickTally:
    def __init__(self) -> None:
        self.clicks: deque[int] = deque()

    def record(self, timestamp: int) -> None:
        self.clicks.append(timestamp)

    def countSince(self, timestamp: int) -> int:
        while self.clicks and self.clicks[0] <= timestamp - 300:
            self.clicks.popleft()
        return len(self.clicks)
