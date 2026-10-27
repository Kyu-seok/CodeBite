class Solution:
    def longestPalindrome(self, s: str) -> int:
        # Expand around each of the 2n - 1 centres (letters and gaps between them).
        longest = 0
        for centre in range(2 * len(s) - 1):
            left, right = centre // 2, (centre + 1) // 2
            while left >= 0 and right < len(s) and s[left] == s[right]:
                left -= 1
                right += 1
            longest = max(longest, right - left - 1)
        return longest
