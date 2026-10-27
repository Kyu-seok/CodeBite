class Solution:
    def splitZoneRuns(self, s: str) -> list[int]:
        last = {letter: i for i, letter in enumerate(s)}
        sizes = []
        start = end = 0
        for i, letter in enumerate(s):
            end = max(end, last[letter])
            if i == end:  # every letter seen in this chunk has finished
                sizes.append(end - start + 1)
                start = i + 1
        return sizes
