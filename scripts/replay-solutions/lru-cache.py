from collections import OrderedDict


class LRUCache:
    def __init__(self, capacity: int) -> None:
        self.capacity = capacity
        self.entries: OrderedDict[int, int] = OrderedDict()

    def get(self, key: int) -> int:
        if key not in self.entries:
            return -1
        self.entries.move_to_end(key)
        return self.entries[key]

    def put(self, key: int, value: int) -> None:
        self.entries[key] = value
        self.entries.move_to_end(key)
        if len(self.entries) > self.capacity:
            self.entries.popitem(last=False)
