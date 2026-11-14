class Solution {
    public int minutesUntilStale(int[][] tray) {
        int rows = tray.length, cols = tray[0].length, fresh = 0;
        java.util.ArrayDeque<int[]> stale = new java.util.ArrayDeque<>();
        for (int r = 0; r < rows; r++)
            for (int c = 0; c < cols; c++) {
                if (tray[r][c] == 1) fresh++;
                else if (tray[r][c] == 2) stale.add(new int[]{r, c});
            }
        int minutes = 0;
        int[][] dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        while (!stale.isEmpty() && fresh > 0) {
            for (int k = stale.size(); k > 0; k--) {
                int[] p = stale.poll();
                for (int[] d : dirs) {
                    int nr = p[0] + d[0], nc = p[1] + d[1];
                    if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && tray[nr][nc] == 1) {
                        tray[nr][nc] = 2;
                        fresh--;
                        stale.add(new int[]{nr, nc});
                    }
                }
            }
            minutes++;
        }
        return fresh > 0 ? -1 : minutes;
    }
}
