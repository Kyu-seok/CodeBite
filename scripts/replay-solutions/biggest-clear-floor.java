class Solution {
    public int biggestClearFloor(char[][] floor) {
        int m = floor.length, n = floor[0].length, best = 0;
        int[][] side = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (floor[i - 1][j - 1] == '1') {
                    side[i][j] = 1 + Math.min(side[i - 1][j - 1], Math.min(side[i - 1][j], side[i][j - 1]));
                    best = Math.max(best, side[i][j]);
                }
            }
        }
        return best * best;
    }
}
