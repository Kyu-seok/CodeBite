class Solution {
public:
    int maxProduct(vector<int>& nums) {
        // high and low are the largest and smallest products of a slice ending at the current element.
        int best = nums[0], high = nums[0], low = nums[0];
        for (size_t i = 1; i < nums.size(); i++) {
            int value = nums[i];
            int a = high * value, b = low * value;
            high = max(value, max(a, b));
            low = min(value, min(a, b));
            best = max(best, high);
        }
        return best;
    }
};
