class Solution {
    public int maxPopPoints(int[] balloons) {
        int n = balloons.length + 2;
        int[] values = new int[n];
        values[0] = 1;
        values[n - 1] = 1;
        for (int i = 0; i < balloons.length; i++) values[i + 1] = balloons[i];
        int[][] best = new int[n][n];
        for (int gap = 2; gap < n; gap++)
            for (int left = 0; left + gap < n; left++) {
                int right = left + gap;
                for (int last = left + 1; last < right; last++)
                    best[left][right] = Math.max(best[left][right],
                            best[left][last] + best[last][right] + values[left] * values[last] * values[right]);
            }
        return best[0][n - 1];
    }
}
