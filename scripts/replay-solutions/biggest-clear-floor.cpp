#include <vector>
#include <algorithm>

class Solution {
public:
    int biggestClearFloor(vector<vector<char>>& floor) {
        int m = floor.size(), n = floor[0].size(), best = 0;
        vector<vector<int>> side(m + 1, vector<int>(n + 1, 0));
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (floor[i - 1][j - 1] == '1') {
                    side[i][j] = 1 + min(side[i - 1][j - 1], min(side[i - 1][j], side[i][j - 1]));
                    best = max(best, side[i][j]);
                }
            }
        }
        return best * best;
    }
};
