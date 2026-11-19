class Solution {
    private int[][] memo;

    public int longestIncreasingPath(int[][] scores) {
        int m = scores.length, n = scores[0].length;
        memo = new int[m][n];
        int best = 0;
        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                best = Math.max(best, walk(scores, r, c));
        return best;
    }

    private int walk(int[][] scores, int r, int c) {
        if (memo[r][c] > 0) return memo[r][c];
        int[][] steps = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        int best = 1;
        for (int[] s : steps) {
            int nr = r + s[0], nc = c + s[1];
            if (nr >= 0 && nr < scores.length && nc >= 0 && nc < scores[0].length && scores[nr][nc] > scores[r][c])
                best = Math.max(best, 1 + walk(scores, nr, nc));
        }
        return memo[r][c] = best;
    }
}
