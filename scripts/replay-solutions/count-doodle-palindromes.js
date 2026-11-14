class Solution {
    countPalindromicSubstrings(doodle) {
        const n = doodle.length;
        let count = 0;
        for (let center = 0; center < 2 * n - 1; center++) {
            let left = Math.floor(center / 2), right = Math.floor((center + 1) / 2);
            while (left >= 0 && right < n && doodle[left] === doodle[right]) {
                count++;
                left--;
                right++;
            }
        }
        return count;
    }
}
