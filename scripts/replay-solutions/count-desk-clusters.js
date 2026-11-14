class Solution {
    countClusters(board) {
        const rows = board.length, cols = board[0].length;
        const sink = (r, c) => {
            if (r < 0 || c < 0 || r >= rows || c >= cols || board[r][c] !== '1') return;
            board[r][c] = '0';
            sink(r + 1, c);
            sink(r - 1, c);
            sink(r, c + 1);
            sink(r, c - 1);
        };
        let clusters = 0;
        for (let r = 0; r < rows; r++) {
            for (let c = 0; c < cols; c++) {
                if (board[r][c] === '1') {
                    clusters++;
                    sink(r, c);
                }
            }
        }
        return clusters;
    }
}
