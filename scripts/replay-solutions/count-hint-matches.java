class Solution {
    public long countHintMatches(String notes, String target) {
        int m = target.length();
        long[] ways = new long[m + 1];
        ways[0] = 1;
        for (int i = 0; i < notes.length(); i++) {
            char letter = notes.charAt(i);
            for (int j = m; j >= 1; j--) if (target.charAt(j - 1) == letter) ways[j] += ways[j - 1];
        }
        return ways[m];
    }
}
