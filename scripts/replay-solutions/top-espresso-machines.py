from collections import Counter


class Solution:
    def busiestMachines(self, checkIns: list[int], k: int) -> list[int]:
        return [machine for machine, _ in Counter(checkIns).most_common(k)]
