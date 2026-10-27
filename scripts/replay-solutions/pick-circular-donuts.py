class Solution:
    def pickCircuitTargets(self, yields: list[int]) -> int:
        if len(yields) == 1:
            return yields[0]

        def best_in_line(values: list[int]) -> int:
            skip, take = 0, 0
            for value in values:
                skip, take = max(skip, take), skip + value
            return max(skip, take)

        # The first and last are neighbours, so leave out one of them.
        return max(best_in_line(yields[1:]), best_in_line(yields[:-1]))
