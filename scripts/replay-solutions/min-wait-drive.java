class Solution {
    public int minWaitRoute(int[][] grid) {
        int m = grid.length, n = grid[0].length;
        int[][] best = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j == 0) best[i][j] = grid[i][j];
                else if (i == 0) best[i][j] = best[i][j - 1] + grid[i][j];
                else if (j == 0) best[i][j] = best[i - 1][j] + grid[i][j];
                else best[i][j] = Math.min(best[i - 1][j], best[i][j - 1]) + grid[i][j];
            }
        }
        return best[m - 1][n - 1];
    }
}
