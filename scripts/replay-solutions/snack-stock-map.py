class ChainedMap:
    BUCKETS = 2069

    def __init__(self) -> None:
        self.buckets: list[list[list[int]]] = [[] for _ in range(self.BUCKETS)]

    def _bucket(self, key: int) -> list[list[int]]:
        return self.buckets[key % self.BUCKETS]

    def set(self, key: int, value: int) -> None:
        bucket = self._bucket(key)
        for entry in bucket:
            if entry[0] == key:
                entry[1] = value
                return
        bucket.append([key, value])

    def lookup(self, key: int) -> int:
        for k, v in self._bucket(key):
            if k == key:
                return v
        return -1

    def erase(self, key: int) -> None:
        bucket = self._bucket(key)
        for i, entry in enumerate(bucket):
            if entry[0] == key:
                bucket.pop(i)
                return
