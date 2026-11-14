#include <vector>
using namespace std;

class Solution {
public:
    void zeroOutRowsAndCols(vector<vector<int>>& board) {
        int m = board.size(), n = board[0].size();
        vector<bool> zeroRow(m, false), zeroCol(n, false);
        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                if (board[r][c] == 0) { zeroRow[r] = true; zeroCol[c] = true; }
        for (int r = 0; r < m; r++)
            for (int c = 0; c < n; c++)
                if (zeroRow[r] || zeroCol[c]) board[r][c] = 0;
    }
};
