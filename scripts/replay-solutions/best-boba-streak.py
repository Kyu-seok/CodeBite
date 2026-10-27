class Solution:
    def max_product(self, traffic: list[int]) -> int:
        best = high = low = traffic[0]
        for value in traffic[1:]:
            candidates = (value, high * value, low * value)
            high, low = max(candidates), min(candidates)
            best = max(best, high)
        return best
