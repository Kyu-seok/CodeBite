class Solution {
    longestIncreasingPath(scores) {
        const m = scores.length, n = scores[0].length;
        const memo = Array.from({ length: m }, () => new Array(n).fill(0));
        const walk = (r, c) => {
            if (memo[r][c]) return memo[r][c];
            let best = 1;
            for (const [dr, dc] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
                const nr = r + dr, nc = c + dc;
                if (nr >= 0 && nr < m && nc >= 0 && nc < n && scores[nr][nc] > scores[r][c])
                    best = Math.max(best, 1 + walk(nr, nc));
            }
            return (memo[r][c] = best);
        };
        let best = 0;
        for (let r = 0; r < m; r++) for (let c = 0; c < n; c++) best = Math.max(best, walk(r, c));
        return best;
    }
}
