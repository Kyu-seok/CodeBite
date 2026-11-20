class Solution {
    private final List<List<String>> boards = new ArrayList<>();
    private int n;
    private int[] queens; // queens[row] = column
    private boolean[] columns, diagonals, antiDiagonals;

    public List<List<String>> solveNQueens(int n) {
        this.n = n;
        queens = new int[n];
        columns = new boolean[n];
        diagonals = new boolean[2 * n]; // row - column + n
        antiDiagonals = new boolean[2 * n]; // row + column
        place(0);
        return boards;
    }

    private void place(int row) {
        if (row == n) {
            List<String> board = new ArrayList<>();
            for (int column : queens) {
                char[] line = new char[n];
                Arrays.fill(line, '.');
                line[column] = 'Q';
                board.add(new String(line));
            }
            boards.add(board);
            return;
        }
        for (int column = 0; column < n; column++) {
            if (columns[column] || diagonals[row - column + n] || antiDiagonals[row + column]) continue;
            queens[row] = column;
            columns[column] = diagonals[row - column + n] = antiDiagonals[row + column] = true;
            place(row + 1);
            columns[column] = diagonals[row - column + n] = antiDiagonals[row + column] = false;
        }
    }
}
