class Solution {
    longestSameLetterRun(s, k) {
        const counts = new Array(26).fill(0);
        let start = 0, top = 0, best = 0;
        for (let end = 0; end < s.length; end++) {
            top = Math.max(top, ++counts[s.charCodeAt(end) - 65]);
            while (end - start + 1 - top > k) {
                counts[s.charCodeAt(start) - 65]--;
                start++;
            }
            best = Math.max(best, end - start + 1);
        }
        return best;
    }
}
