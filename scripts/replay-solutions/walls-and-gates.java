class Solution {
    private static final int EMPTY = 2147483647;

    public void wallsAndGates(int[][] rooms) {
        int rows = rooms.length, cols = rooms[0].length;
        Deque<int[]> queue = new ArrayDeque<>();
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if (rooms[r][c] == 0) queue.add(new int[] {r, c});
            }
        }
        int[][] steps = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        while (!queue.isEmpty()) {
            int[] cell = queue.poll();
            for (int[] step : steps) {
                int nr = cell[0] + step[0], nc = cell[1] + step[1];
                if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && rooms[nr][nc] == EMPTY) {
                    rooms[nr][nc] = rooms[cell[0]][cell[1]] + 1;
                    queue.add(new int[] {nr, nc});
                }
            }
        }
    }
}
