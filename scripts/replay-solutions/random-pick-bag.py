import random


class RandomBag:
    def __init__(self) -> None:
        self.cards: list[int] = []
        self.where: dict[int, int] = {}

    def insert(self, val: int) -> bool:
        if val in self.where:
            return False
        self.where[val] = len(self.cards)
        self.cards.append(val)
        return True

    def remove(self, val: int) -> bool:
        if val not in self.where:
            return False
        i = self.where.pop(val)
        last = self.cards.pop()
        if last != val:
            self.cards[i] = last
            self.where[last] = i
        return True

    def drawRandom(self) -> int:
        return random.choice(self.cards)
