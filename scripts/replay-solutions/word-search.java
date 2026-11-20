class Solution {
    private char[][] board;
    private String word;

    public boolean exist(char[][] board, String word) {
        this.board = board;
        int[] available = new int[128];
        for (char[] row : board) {
            for (char letter : row) available[letter]++;
        }
        int[] wanted = new int[128];
        for (char letter : word.toCharArray()) {
            if (++wanted[letter] > available[letter]) return false;
        }
        // Start from the rarer end to prune sooner.
        boolean reversed = available[word.charAt(0)] > available[word.charAt(word.length() - 1)];
        this.word = reversed ? new StringBuilder(word).reverse().toString() : word;
        for (int r = 0; r < board.length; r++) {
            for (int c = 0; c < board[0].length; c++) {
                if (search(r, c, 0)) return true;
            }
        }
        return false;
    }

    private boolean search(int r, int c, int i) {
        if (i == word.length()) return true;
        if (r < 0 || r >= board.length || c < 0 || c >= board[0].length || board[r][c] != word.charAt(i)) {
            return false;
        }
        board[r][c] = '#';
        boolean found = search(r + 1, c, i + 1) || search(r - 1, c, i + 1)
                || search(r, c + 1, i + 1) || search(r, c - 1, i + 1);
        board[r][c] = word.charAt(i);
        return found;
    }
}
