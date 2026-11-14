class Solution {
    maxTastiness(tastiness) {
        const n = tastiness.length;
        if (n === 1) return tastiness[0];
        const bestInLine = (from, to) => {
            let skip = 0, take = 0;
            for (let i = from; i < to; i++) {
                [skip, take] = [Math.max(skip, take), skip + tastiness[i]];
            }
            return Math.max(skip, take);
        };
        // The first and last are neighbours, so leave out one of them.
        return Math.max(bestInLine(1, n), bestInLine(0, n - 1));
    }
}
