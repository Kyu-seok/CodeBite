class Solution:
    def pickPlotHaul(self, snacks: list[int]) -> int:
        skipped, taken = 0, 0
        for haul in snacks:
            skipped, taken = max(skipped, taken), skipped + haul
        return max(skipped, taken)
