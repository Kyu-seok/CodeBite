class Solution {
    fewestBags(bagSizes, quota) {
        const unreachable = quota + 1;
        const fewest = new Array(quota + 1).fill(unreachable);
        fewest[0] = 0;
        for (let total = 1; total <= quota; total++) {
            for (const size of bagSizes) {
                if (size <= total && fewest[total - size] + 1 < fewest[total]) {
                    fewest[total] = fewest[total - size] + 1;
                }
            }
        }
        return fewest[quota] === unreachable ? -1 : fewest[quota];
    }
}
