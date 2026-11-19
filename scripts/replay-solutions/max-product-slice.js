class Solution {
    maxProduct(nums) {
        // high and low are the largest and smallest products of a slice ending at the current element.
        let best = nums[0], high = nums[0], low = nums[0];
        for (let i = 1; i < nums.length; i++) {
            const value = nums[i];
            const a = high * value, b = low * value;
            high = Math.max(value, a, b);
            low = Math.min(value, a, b);
            best = Math.max(best, high);
        }
        return best;
    }
}
