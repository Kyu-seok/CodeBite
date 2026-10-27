from collections import Counter


class Solution:
    def listMontageScenes(self, snacks: list[int]) -> list[list[int]]:
        combos: list[list[int]] = [[]]
        for flavor, count in Counter(snacks).items():
            combos = [combo + [flavor] * taken for combo in combos for taken in range(count + 1)]
        return combos
