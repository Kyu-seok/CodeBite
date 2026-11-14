#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<vector<int>> zeroSumTrios(vector<int>& deltas) {
        vector<int> nums(deltas);
        sort(nums.begin(), nums.end());
        vector<vector<int>> trios;
        int n = nums.size();
        for (int i = 0; i + 2 < n; i++) {
            if (i > 0 && nums[i] == nums[i - 1]) continue;
            int left = i + 1, right = n - 1;
            while (left < right) {
                long long total = (long long) nums[i] + nums[left] + nums[right];
                if (total < 0) left++;
                else if (total > 0) right--;
                else {
                    trios.push_back({nums[i], nums[left], nums[right]});
                    left++;
                    while (left < right && nums[left] == nums[left - 1]) left++;
                    right--;
                }
            }
        }
        return trios;
    }
};
