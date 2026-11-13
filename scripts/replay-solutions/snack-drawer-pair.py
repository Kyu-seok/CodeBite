class Solution:
    def findPairIndices(self, snacks: list[int], target: int) -> list[int]:
        seen: dict[int, int] = {}
        for i, calories in enumerate(snacks):
            partner = target - calories
            if partner in seen:
                return [seen[partner], i]
            seen[calories] = i
        return []
