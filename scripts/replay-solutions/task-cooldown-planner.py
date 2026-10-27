from collections import Counter


class Solution:
    def planStationRuns(self, jobs: list[str], n: int) -> int:
        counts = Counter(jobs).values()
        most = max(counts)
        tied = sum(1 for count in counts if count == most)
        return max(len(jobs), (most - 1) * (n + 1) + tied)
