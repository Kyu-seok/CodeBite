#include <vector>
#include <queue>
#include <utility>
using namespace std;

class Solution {
public:
    int shortestPathLength(vector<vector<int>>& board) {
        int n = board.size();
        if (board[0][0] || board[n - 1][n - 1]) return -1;
        vector<vector<int>> tiles(n, vector<int>(n, 0));
        tiles[0][0] = 1;
        queue<pair<int, int>> q;
        q.push(make_pair(0, 0));
        while (!q.empty()) {
            int r = q.front().first, c = q.front().second;
            q.pop();
            if (r == n - 1 && c == n - 1) return tiles[r][c];
            for (int dr = -1; dr <= 1; dr++)
                for (int dc = -1; dc <= 1; dc++) {
                    int nr = r + dr, nc = c + dc;
                    if (nr >= 0 && nr < n && nc >= 0 && nc < n && board[nr][nc] == 0 && tiles[nr][nc] == 0) {
                        tiles[nr][nc] = tiles[r][c] + 1;
                        q.push(make_pair(nr, nc));
                    }
                }
        }
        return -1;
    }
};
