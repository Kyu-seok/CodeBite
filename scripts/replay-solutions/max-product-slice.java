class Solution {
    public int maxProduct(int[] nums) {
        // high and low are the largest and smallest products of a slice ending at the current element.
        int best = nums[0], high = nums[0], low = nums[0];
        for (int i = 1; i < nums.length; i++) {
            int value = nums[i];
            int a = high * value, b = low * value;
            high = Math.max(value, Math.max(a, b));
            low = Math.min(value, Math.min(a, b));
            best = Math.max(best, high);
        }
        return best;
    }
}
