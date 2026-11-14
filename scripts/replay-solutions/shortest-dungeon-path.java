class Solution {
    public int shortestPathLength(int[][] board) {
        int n = board.length;
        if (board[0][0] == 1 || board[n - 1][n - 1] == 1) return -1;
        int[][] tiles = new int[n][n];
        tiles[0][0] = 1;
        ArrayDeque<int[]> queue = new ArrayDeque<>();
        queue.add(new int[]{0, 0});
        while (!queue.isEmpty()) {
            int[] cur = queue.poll();
            int r = cur[0], c = cur[1];
            if (r == n - 1 && c == n - 1) return tiles[r][c];
            for (int dr = -1; dr <= 1; dr++)
                for (int dc = -1; dc <= 1; dc++) {
                    int nr = r + dr, nc = c + dc;
                    if (nr >= 0 && nr < n && nc >= 0 && nc < n && board[nr][nc] == 0 && tiles[nr][nc] == 0) {
                        tiles[nr][nc] = tiles[r][c] + 1;
                        queue.add(new int[]{nr, nc});
                    }
                }
        }
        return -1;
    }
}
