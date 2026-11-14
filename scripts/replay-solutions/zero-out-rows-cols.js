class Solution {
    /**
     * @param {number[][]} board
     * @return {void}
     */
    zeroOutRowsAndCols(board) {
        const m = board.length, n = board[0].length;
        const zeroRow = new Array(m).fill(false), zeroCol = new Array(n).fill(false);
        for (let r = 0; r < m; r++)
            for (let c = 0; c < n; c++)
                if (board[r][c] === 0) { zeroRow[r] = true; zeroCol[c] = true; }
        for (let r = 0; r < m; r++)
            for (let c = 0; c < n; c++)
                if (zeroRow[r] || zeroCol[c]) board[r][c] = 0;
    }
}
