class Solution:
    def fewestBagSizes(self, bagSizes: list[int], quota: int) -> int:
        unreachable = quota + 1
        fewest = [0] + [unreachable] * quota
        for total in range(1, quota + 1):
            for size in bagSizes:
                if size <= total and fewest[total - size] + 1 < fewest[total]:
                    fewest[total] = fewest[total - size] + 1
        return fewest[quota] if fewest[quota] != unreachable else -1
