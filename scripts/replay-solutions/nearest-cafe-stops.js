class Solution {
    selectNearestStops(stops, k) {
        const dist = ([x, y]) => BigInt(x) * BigInt(x) + BigInt(y) * BigInt(y);
        return [...stops]
            .sort((a, b) => {
                const d = dist(a) - dist(b);
                return d < 0n ? -1 : d > 0n ? 1 : 0;
            })
            .slice(0, k);
    }
}
