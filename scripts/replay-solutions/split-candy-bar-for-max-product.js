class Solution {
    maxSplitProduct(length) {
        const best = new Array(length + 1).fill(0);
        best[1] = 1;
        for (let total = 2; total <= length; total++)
            for (let first = 1; first < total; first++)
                best[total] = Math.max(best[total], first * Math.max(total - first, best[total - first]));
        return best[length];
    }
}
