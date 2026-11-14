class LowTrackStack:
    def __init__(self) -> None:
        self.entries: list[tuple[int, int]] = []

    def push(self, val: int) -> None:
        low = min(val, self.entries[-1][1]) if self.entries else val
        self.entries.append((val, low))

    def pop(self) -> None:
        self.entries.pop()

    def top(self) -> int:
        return self.entries[-1][0]

    def getMin(self) -> int:
        return self.entries[-1][1]
