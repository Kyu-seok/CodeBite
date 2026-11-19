#include <vector>
#include <algorithm>
class Solution {
public:
    int maxPopPoints(vector<int>& balloons) {
        vector<int> values;
        values.push_back(1);
        for (int b : balloons) values.push_back(b);
        values.push_back(1);
        int n = values.size();
        vector<vector<int>> best(n, vector<int>(n, 0));
        for (int gap = 2; gap < n; gap++)
            for (int left = 0; left + gap < n; left++) {
                int right = left + gap;
                for (int last = left + 1; last < right; last++)
                    best[left][right] = max(best[left][right],
                        best[left][last] + best[last][right] + values[left] * values[last] * values[right]);
            }
        return best[0][n - 1];
    }
};
