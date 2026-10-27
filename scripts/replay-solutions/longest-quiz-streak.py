from bisect import bisect_left


class Solution:
    def longestBrightRun(self, scores: list[int]) -> int:
        # tails[k] is the smallest score that ends a strictly increasing run of length k + 1.
        tails: list[int] = []
        for score in scores:
            i = bisect_left(tails, score)
            if i == len(tails):
                tails.append(score)
            else:
                tails[i] = score
        return len(tails)
