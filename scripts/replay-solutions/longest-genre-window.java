class Solution {
    public int longestGenreWindow(String feed) {
        int[] lastSeen = new int[128];
        java.util.Arrays.fill(lastSeen, -1);
        int start = 0;
        int best = 0;
        for (int i = 0; i < feed.length(); i++) {
            char tag = feed.charAt(i);
            if (lastSeen[tag] >= start) {
                start = lastSeen[tag] + 1;
            }
            lastSeen[tag] = i;
            best = Math.max(best, i - start + 1);
        }
        return best;
    }
}
