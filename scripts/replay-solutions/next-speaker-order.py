class Solution:
    def nextLineup(self, lineup: list[int]) -> None:
        # The rightmost position that can still grow.
        i = len(lineup) - 2
        while i >= 0 and lineup[i] >= lineup[i + 1]:
            i -= 1
        if i >= 0:
            j = len(lineup) - 1
            while lineup[j] <= lineup[i]:
                j -= 1
            lineup[i], lineup[j] = lineup[j], lineup[i]
        lineup[i + 1:] = reversed(lineup[i + 1:])
