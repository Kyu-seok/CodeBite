import heapq


class StreamMedian:
    def __init__(self) -> None:
        self.low: list[int] = []   # max-heap of the lower half, negated
        self.high: list[int] = []  # min-heap of the upper half

    def record(self, num: int) -> None:
        heapq.heappush(self.low, -num)
        heapq.heappush(self.high, -heapq.heappop(self.low))
        if len(self.high) > len(self.low):
            heapq.heappush(self.low, -heapq.heappop(self.high))

    def median(self) -> float:
        if len(self.low) > len(self.high):
            return float(-self.low[0])
        return (-self.low[0] + self.high[0]) / 2
