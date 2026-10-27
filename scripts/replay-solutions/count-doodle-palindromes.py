class Solution:
    def count_substrings(self, code: str) -> int:
        count = 0
        n = len(code)
        # Grow around each of the 2n - 1 centres: letters and gaps between them.
        for center in range(2 * n - 1):
            left, right = center // 2, (center + 1) // 2
            while left >= 0 and right < n and code[left] == code[right]:
                count += 1
                left -= 1
                right += 1
        return count
