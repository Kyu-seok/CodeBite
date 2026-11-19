class LowTrackStack:
    def __init__(self) -> None:
        self.values: list[int] = []
        self.lows: list[int] = []  # lows[i] is the smallest of values[0..i]

    def push(self, val: int) -> None:
        low = min(val, self.lows[-1]) if self.lows else val
        self.values.append(val)
        self.lows.append(low)

    def pop(self) -> None:
        self.values.pop()
        self.lows.pop()

    def top(self) -> int:
        return self.values[-1]

    def getMin(self) -> int:
        return self.lows[-1]
