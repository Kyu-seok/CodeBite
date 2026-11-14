class Solution {
    mergedPriceMedian(pricesA, pricesB) {
        const merged = [...pricesA, ...pricesB].sort((a, b) => a - b);
        const n = merged.length;
        if (n % 2 === 1) return merged[(n - 1) / 2];
        return (merged[n / 2 - 1] + merged[n / 2]) / 2;
    }
}
