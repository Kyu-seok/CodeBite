class Solution {
    shortestPathLength(board) {
        const n = board.length;
        if (board[0][0] || board[n - 1][n - 1]) return -1;
        const tiles = Array.from({ length: n }, () => new Array(n).fill(0));
        tiles[0][0] = 1;
        const queue = [[0, 0]];
        for (let head = 0; head < queue.length; head++) {
            const [r, c] = queue[head];
            if (r === n - 1 && c === n - 1) return tiles[r][c];
            for (let dr = -1; dr <= 1; dr++)
                for (let dc = -1; dc <= 1; dc++) {
                    const nr = r + dr, nc = c + dc;
                    if (nr >= 0 && nr < n && nc >= 0 && nc < n && board[nr][nc] === 0 && tiles[nr][nc] === 0) {
                        tiles[nr][nc] = tiles[r][c] + 1;
                        queue.push([nr, nc]);
                    }
                }
        }
        return -1;
    }
}
