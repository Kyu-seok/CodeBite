import bisect


class TimestampedStore:
    def __init__(self) -> None:
        self.times: dict[str, list[int]] = {}
        self.values: dict[str, list[str]] = {}

    def write(self, key: str, value: str, timestamp: int) -> None:
        self.times.setdefault(key, []).append(timestamp)
        self.values.setdefault(key, []).append(value)

    def readAt(self, key: str, timestamp: int) -> str:
        times = self.times.get(key)
        if not times:
            return ""
        i = bisect.bisect_right(times, timestamp)
        return self.values[key][i - 1] if i else ""
