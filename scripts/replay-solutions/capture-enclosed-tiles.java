class Solution {
    public void captureEnclosedTiles(char[][] board) {
        int rows = board.length, cols = board[0].length;
        Deque<int[]> stack = new ArrayDeque<>();
        for (int r = 0; r < rows; r++)
            for (int c = 0; c < cols; c++)
                if ((r == 0 || r == rows - 1 || c == 0 || c == cols - 1) && board[r][c] == 'O')
                    stack.push(new int[]{r, c});
        while (!stack.isEmpty()) {
            int[] cell = stack.pop();
            int r = cell[0], c = cell[1];
            if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != 'O') continue;
            board[r][c] = 'S';
            stack.push(new int[]{r + 1, c});
            stack.push(new int[]{r - 1, c});
            stack.push(new int[]{r, c + 1});
            stack.push(new int[]{r, c - 1});
        }
        for (char[] row : board)
            for (int c = 0; c < cols; c++)
                row[c] = row[c] == 'S' ? 'O' : 'X';
    }
}
