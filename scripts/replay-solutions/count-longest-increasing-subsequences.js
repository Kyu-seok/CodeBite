class Solution {
    countLongestIncreasing(nums) {
        const n = nums.length;
        const length = new Array(n).fill(1); // longest increasing subsequence ending at i
        const count = new Array(n).fill(1);  // how many subsequences reach that length
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < i; j++) {
                if (nums[j] < nums[i]) {
                    if (length[j] + 1 > length[i]) {
                        length[i] = length[j] + 1;
                        count[i] = count[j];
                    } else if (length[j] + 1 === length[i]) {
                        count[i] += count[j];
                    }
                }
            }
        }
        const longest = Math.max(...length);
        let total = 0;
        for (let i = 0; i < n; i++) if (length[i] === longest) total += count[i];
        return total;
    }
}
