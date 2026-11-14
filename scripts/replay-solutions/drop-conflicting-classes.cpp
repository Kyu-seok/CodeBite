#include <vector>
#include <algorithm>
#include <climits>

class Solution {
public:
    int dropClassConflicts(vector<vector<int>>& classes) {
        sort(classes.begin(), classes.end(), [](const vector<int>& a, const vector<int>& b) { return a[1] < b[1]; });
        int dropped = 0;
        long long end = LLONG_MIN;
        for (const auto& c : classes) {
            if (c[0] >= end) end = c[1];
            else dropped++;
        }
        return dropped;
    }
};
