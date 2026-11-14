#include <vector>
#include <algorithm>
using namespace std;

class Solution {
    vector<vector<int>> memo;
    int walk(vector<vector<int>>& scores, int r, int c) {
        if (memo[r][c]) return memo[r][c];
        int dr[] = {1, -1, 0, 0}, dc[] = {0, 0, 1, -1};
        int best = 1;
        for (int k = 0; k < 4; k++) {
            int nr = r + dr[k], nc = c + dc[k];
            if (nr >= 0 && nr < (int)scores.size() && nc >= 0 && nc < (int)scores[0].size() && scores[nr][nc] > scores[r][c])
                best = max(best, 1 + walk(scores, nr, nc));
        }
        return memo[r][c] = best;
    }
public:
    int longestIncreasingPath(vector<vector<int>>& scores) {
        memo.assign(scores.size(), vector<int>(scores[0].size(), 0));
        int best = 0;
        for (int r = 0; r < (int)scores.size(); r++)
            for (int c = 0; c < (int)scores[0].size(); c++)
                best = max(best, walk(scores, r, c));
        return best;
    }
};
