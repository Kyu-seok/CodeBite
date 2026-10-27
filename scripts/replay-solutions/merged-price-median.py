class Solution:
    def mergedZoneMedian(self, zonesA: list[int], zonesB: list[int]) -> float:
        a, b = zonesA, zonesB
        if len(a) > len(b):
            a, b = b, a
        m, n = len(a), len(b)
        half = (m + n + 1) // 2
        low, high = 0, m
        while low <= high:
            i = (low + high) // 2
            j = half - i
            a_left = a[i - 1] if i > 0 else float("-inf")
            a_right = a[i] if i < m else float("inf")
            b_left = b[j - 1] if j > 0 else float("-inf")
            b_right = b[j] if j < n else float("inf")
            if a_left <= b_right and b_left <= a_right:
                if (m + n) % 2:
                    return float(max(a_left, b_left))
                return (max(a_left, b_left) + min(a_right, b_right)) / 2
            if a_left > b_right:
                high = i - 1
            else:
                low = i + 1
        raise ValueError("inputs are not sorted")
