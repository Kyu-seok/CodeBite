class Solution:
    def isSoloSpecies(self, specimenCount: int) -> bool:
        return specimenCount > 0 and specimenCount & (specimenCount - 1) == 0
