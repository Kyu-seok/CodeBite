class Solution:
    def maxTastiness(self, tastiness: list[int]) -> int:
        if len(tastiness) == 1:
            return tastiness[0]

        def best_in_line(values: list[int]) -> int:
            skip, take = 0, 0
            for value in values:
                skip, take = max(skip, take), skip + value
            return max(skip, take)

        # The first and last are neighbours, so leave out one of them.
        return max(best_in_line(tastiness[1:]), best_in_line(tastiness[:-1]))
