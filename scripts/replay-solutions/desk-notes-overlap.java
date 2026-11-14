class Solution {
    public int longestCommonSubsequence(String left, String right) {
        int[] previous = new int[right.length() + 1];
        for (int i = 0; i < left.length(); i++) {
            int[] current = new int[right.length() + 1];
            for (int j = 0; j < right.length(); j++) {
                current[j + 1] = left.charAt(i) == right.charAt(j)
                        ? previous[j] + 1
                        : Math.max(previous[j + 1], current[j]);
            }
            previous = current;
        }
        return previous[right.length()];
    }
}
