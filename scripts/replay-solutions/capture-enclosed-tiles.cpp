#include <vector>
#include <utility>
using namespace std;

class Solution {
public:
    void captureEnclosedTiles(vector<vector<char>>& board) {
        int rows = board.size(), cols = board[0].size();
        vector<pair<int, int>> stack;
        for (int r = 0; r < rows; r++)
            for (int c = 0; c < cols; c++)
                if ((r == 0 || r == rows - 1 || c == 0 || c == cols - 1) && board[r][c] == 'O')
                    stack.push_back(make_pair(r, c));
        while (!stack.empty()) {
            int r = stack.back().first, c = stack.back().second;
            stack.pop_back();
            if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != 'O') continue;
            board[r][c] = 'S';
            stack.push_back(make_pair(r + 1, c));
            stack.push_back(make_pair(r - 1, c));
            stack.push_back(make_pair(r, c + 1));
            stack.push_back(make_pair(r, c - 1));
        }
        for (auto& row : board)
            for (int c = 0; c < cols; c++)
                row[c] = row[c] == 'S' ? 'O' : 'X';
    }
};
