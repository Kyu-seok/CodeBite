#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int shortestCookieSpan(vector<int>& trays, int target) {
        int n = trays.size(), best = n + 1, left = 0;
        long long total = 0;
        for (int right = 0; right < n; right++) {
            total += trays[right];
            while (total >= target) {
                best = min(best, right - left + 1);
                total -= trays[left++];
            }
        }
        return best <= n ? best : 0;
    }
};
