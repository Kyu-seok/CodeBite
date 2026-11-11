class Solution {
    public int longestSameLetterRun(String s, int k) {
        int[] counts = new int[26];
        int start = 0, top = 0, best = 0;
        for (int end = 0; end < s.length(); end++) {
            top = Math.max(top, ++counts[s.charAt(end) - 'A']);
            while (end - start + 1 - top > k) {
                counts[s.charAt(start) - 'A']--;
                start++;
            }
            best = Math.max(best, end - start + 1);
        }
        return best;
    }
}
