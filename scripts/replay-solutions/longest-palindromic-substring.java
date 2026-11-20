class Solution {
    public int longestPalindrome(String s) {
        // Expand around each of the 2n - 1 centres (letters and gaps between them).
        int longest = 0;
        for (int centre = 0; centre < 2 * s.length() - 1; centre++) {
            int left = centre / 2, right = (centre + 1) / 2;
            while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {
                left--;
                right++;
            }
            longest = Math.max(longest, right - left - 1);
        }
        return longest;
    }
}
