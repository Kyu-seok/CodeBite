class Solution {
    earliestCrossingTime(elevation) {
        // Binary search on t, flood fill from (0, 0) over tiles at most t.
        const n = elevation.length;
        const canCross = (t) => {
            if (elevation[0][0] > t) return false;
            const seen = elevation.map(row => row.map(() => false));
            const stack = [[0, 0]];
            seen[0][0] = true;
            while (stack.length) {
                const [r, c] = stack.pop();
                if (r === n - 1 && c === n - 1) return true;
                for (const [dr, dc] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
                    const nr = r + dr, nc = c + dc;
                    if (nr >= 0 && nr < n && nc >= 0 && nc < n && !seen[nr][nc] && elevation[nr][nc] <= t) {
                        seen[nr][nc] = true;
                        stack.push([nr, nc]);
                    }
                }
            }
            return false;
        };
        let lo = 0, hi = Math.max(...elevation.flat());
        while (lo < hi) {
            const mid = Math.floor((lo + hi) / 2);
            if (canCross(mid)) hi = mid; else lo = mid + 1;
        }
        return lo;
    }
}
