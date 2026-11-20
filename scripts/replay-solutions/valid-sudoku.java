class Solution {
    public boolean isValidSudoku(char[][] board) {
        Set<String> seen = new HashSet<>();
        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                char digit = board[r][c];
                if (digit == '.') continue;
                if (!seen.add("row" + r + digit) || !seen.add("col" + c + digit)
                        || !seen.add("box" + r / 3 + c / 3 + digit)) {
                    return false;
                }
            }
        }
        return true;
    }
}
