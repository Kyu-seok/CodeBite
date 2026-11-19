class Solution:
    def listSnackCombos(self, snacks: list[int]) -> list[list[int]]:
        snacks = sorted(snacks)
        combos: list[list[int]] = []
        combo: list[int] = []

        def build(start: int) -> None:
            combos.append(combo.copy())
            for i in range(start, len(snacks)):
                if i > start and snacks[i] == snacks[i - 1]:
                    continue  # the same flavor again at this depth would repeat a combo
                combo.append(snacks[i])
                build(i + 1)
                combo.pop()

        build(0)
        return combos
