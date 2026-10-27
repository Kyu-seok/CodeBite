class FixedRing:
    def __init__(self, k: int) -> None:
        self.slots = [0] * k
        self.head = 0
        self.size = 0

    def push(self, value: int) -> bool:
        if self.isFull():
            return False
        self.slots[(self.head + self.size) % len(self.slots)] = value
        self.size += 1
        return True

    def pull(self) -> bool:
        if self.isEmpty():
            return False
        self.head = (self.head + 1) % len(self.slots)
        self.size -= 1
        return True

    def front(self) -> int:
        return -1 if self.isEmpty() else self.slots[self.head]

    def rear(self) -> int:
        return -1 if self.isEmpty() else self.slots[(self.head + self.size - 1) % len(self.slots)]

    def isEmpty(self) -> bool:
        return self.size == 0

    def isFull(self) -> bool:
        return self.size == len(self.slots)
