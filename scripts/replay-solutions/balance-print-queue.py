class Solution:
    def canBalanceJobs(self, s: str) -> bool:
        # The number of unmatched openers can be anything in [low, high].
        low = high = 0
        for tag in s:
            match tag:
                case "(":
                    low += 1
                    high += 1
                case ")":
                    low -= 1
                    high -= 1
                case _:
                    low -= 1
                    high += 1
            if high < 0:
                return False
            low = max(low, 0)
        return low == 0
