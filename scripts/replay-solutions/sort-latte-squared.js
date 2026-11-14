class Solution {
    sortedSquaredDrifts(drifts) {
        const n = drifts.length;
        const out = new Array(n);
        let lo = 0, hi = n - 1;
        for (let k = n - 1; k >= 0; k--) {
            const a = drifts[lo] * drifts[lo], b = drifts[hi] * drifts[hi];
            if (a > b) { out[k] = a; lo++; } else { out[k] = b; hi--; }
        }
        return out;
    }
}
