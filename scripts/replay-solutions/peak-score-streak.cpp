#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int maxScoreStreak(vector<int>& nums) {
        int best = nums[0], current = nums[0];
        for (size_t i = 1; i < nums.size(); i++) {
            current = max(nums[i], current + nums[i]);
            best = max(best, current);
        }
        return best;
    }
};
