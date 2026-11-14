class Solution {
public:
    vector<vector<int>> fourTraySum(vector<int>& trays, int demand) {
        vector<int> nums(trays);
        sort(nums.begin(), nums.end());
        int n = nums.size();
        vector<vector<int>> result;
        for (int a = 0; a < n - 3; a++) {
            if (a > 0 && nums[a] == nums[a - 1]) continue;
            for (int b = a + 1; b < n - 2; b++) {
                if (b > a + 1 && nums[b] == nums[b - 1]) continue;
                int low = b + 1, high = n - 1;
                while (low < high) {
                    long long total = (long long)nums[a] + nums[b] + nums[low] + nums[high];
                    if (total < demand) low++;
                    else if (total > demand) high--;
                    else {
                        result.push_back({nums[a], nums[b], nums[low], nums[high]});
                        low++;
                        while (low < high && nums[low] == nums[low - 1]) low++;
                        high--;
                    }
                }
            }
        }
        return result;
    }
};
