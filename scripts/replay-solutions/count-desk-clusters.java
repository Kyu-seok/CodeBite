class Solution {
    public int countClusters(char[][] board) {
        int clusters = 0;
        for (int r = 0; r < board.length; r++) {
            for (int c = 0; c < board[0].length; c++) {
                if (board[r][c] == '1') {
                    clusters++;
                    sink(board, r, c);
                }
            }
        }
        return clusters;
    }

    private void sink(char[][] board, int r, int c) {
        if (r < 0 || c < 0 || r >= board.length || c >= board[0].length || board[r][c] != '1') return;
        board[r][c] = '0';
        sink(board, r + 1, c);
        sink(board, r - 1, c);
        sink(board, r, c + 1);
        sink(board, r, c - 1);
    }
}
