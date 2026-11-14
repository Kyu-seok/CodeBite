#include <vector>
#include <queue>
#include <tuple>
#include <algorithm>
using namespace std;

class Solution {
public:
    int earliestCrossingTime(vector<vector<int>>& elevation) {
        int n = elevation.size();
        vector<vector<bool>> seen(n, vector<bool>(n, false));
        priority_queue<tuple<int, int, int>, vector<tuple<int, int, int>>, greater<tuple<int, int, int>>> heap;
        heap.push(make_tuple(elevation[0][0], 0, 0));
        seen[0][0] = true;
        int highest = 0;
        int dr[] = {1, -1, 0, 0}, dc[] = {0, 0, 1, -1};
        while (!heap.empty()) {
            int height, r, c;
            tie(height, r, c) = heap.top();
            heap.pop();
            highest = max(highest, height);
            if (r == n - 1 && c == n - 1) return highest;
            for (int d = 0; d < 4; d++) {
                int nr = r + dr[d], nc = c + dc[d];
                if (nr >= 0 && nr < n && nc >= 0 && nc < n && !seen[nr][nc]) {
                    seen[nr][nc] = true;
                    heap.push(make_tuple(elevation[nr][nc], nr, nc));
                }
            }
        }
        return highest;
    }
};
