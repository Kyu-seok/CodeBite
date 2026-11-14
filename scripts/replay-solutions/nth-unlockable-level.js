class Solution {
    nthUnlockableLevel(n) {
        const levels = [1];
        let i2 = 0, i3 = 0, i5 = 0;
        while (levels.length < n) {
            const next = Math.min(levels[i2] * 2, levels[i3] * 3, levels[i5] * 5);
            levels.push(next);
            if (next === levels[i2] * 2) i2++;
            if (next === levels[i3] * 3) i3++;
            if (next === levels[i5] * 5) i5++;
        }
        return levels[n - 1];
    }
}
