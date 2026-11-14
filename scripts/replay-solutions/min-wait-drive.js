class Solution {
    minWaitRoute(grid) {
        const m = grid.length, n = grid[0].length;
        const best = grid.map(row => [...row]);
        for (let i = 0; i < m; i++) {
            for (let j = 0; j < n; j++) {
                if (i === 0 && j === 0) continue;
                const up = i > 0 ? best[i - 1][j] : Infinity;
                const left = j > 0 ? best[i][j - 1] : Infinity;
                best[i][j] += Math.min(up, left);
            }
        }
        return best[m - 1][n - 1];
    }
}
