class Solution {
    longestRisingScores(scores) {
        // tails[k] is the smallest score that ends a strictly increasing subsequence of length k + 1.
        const tails = [];
        for (const score of scores) {
            let lo = 0, hi = tails.length;
            while (lo < hi) {
                const mid = (lo + hi) >> 1;
                if (tails[mid] < score) lo = mid + 1; else hi = mid;
            }
            tails[lo] = score;
        }
        return tails.length;
    }
}
