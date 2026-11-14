class Solution {
    biggestClearFloor(floor) {
        const m = floor.length, n = floor[0].length;
        const side = Array.from({ length: m + 1 }, () => new Array(n + 1).fill(0));
        let best = 0;
        for (let i = 1; i <= m; i++) {
            for (let j = 1; j <= n; j++) {
                if (floor[i - 1][j - 1] === '1') {
                    side[i][j] = 1 + Math.min(side[i - 1][j - 1], side[i - 1][j], side[i][j - 1]);
                    best = Math.max(best, side[i][j]);
                }
            }
        }
        return best * best;
    }
}
