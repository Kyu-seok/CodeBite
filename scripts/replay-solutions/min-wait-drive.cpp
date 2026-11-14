#include <vector>
#include <algorithm>
#include <climits>

class Solution {
public:
    int minWaitRoute(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<int>> best(grid);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (i == 0 && j == 0) continue;
                int up = i > 0 ? best[i - 1][j] : INT_MAX;
                int left = j > 0 ? best[i][j - 1] : INT_MAX;
                best[i][j] += min(up, left);
            }
        }
        return best[m - 1][n - 1];
    }
};
