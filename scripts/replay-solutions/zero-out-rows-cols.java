class Solution {
    public void zeroOutRowsAndCols(int[][] board) {
        int m = board.length, n = board[0].length;
        boolean[] zeroRow = new boolean[m], zeroCol = new boolean[n];
        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                if (board[r][c] == 0) { zeroRow[r] = true; zeroCol[c] = true; }
        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                if (zeroRow[r] || zeroCol[c]) board[r][c] = 0;
    }
}
