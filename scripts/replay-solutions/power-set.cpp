class Solution {
public:
    vector<vector<int>> powerSet(vector<int>& nums) {
        vector<vector<int>> out;
        for (int mask = 0; mask < (1 << nums.size()); mask++) {
            vector<int> s;
            for (size_t i = 0; i < nums.size(); i++) if (mask >> i & 1) s.push_back(nums[i]);
            out.push_back(s);
        }
        return out;
    }
};
