class Solution {
    maxPopPoints(balloons) {
        const values = [1, ...balloons, 1];
        const n = values.length;
        const best = Array.from({ length: n }, () => new Array(n).fill(0));
        for (let gap = 2; gap < n; gap++)
            for (let left = 0; left + gap < n; left++) {
                const right = left + gap;
                for (let last = left + 1; last < right; last++)
                    best[left][right] = Math.max(best[left][right],
                        best[left][last] + best[last][right] + values[left] * values[last] * values[right]);
            }
        return best[0][n - 1];
    }
}
