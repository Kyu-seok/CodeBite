#include <vector>
using namespace std;

class Solution {
public:
    int countClusters(vector<vector<char>>& board) {
        int clusters = 0;
        for (int r = 0; r < (int)board.size(); r++) {
            for (int c = 0; c < (int)board[0].size(); c++) {
                if (board[r][c] == '1') {
                    clusters++;
                    sink(board, r, c);
                }
            }
        }
        return clusters;
    }

private:
    void sink(vector<vector<char>>& board, int r, int c) {
        if (r < 0 || c < 0 || r >= (int)board.size() || c >= (int)board[0].size() || board[r][c] != '1') return;
        board[r][c] = '0';
        sink(board, r + 1, c);
        sink(board, r - 1, c);
        sink(board, r, c + 1);
        sink(board, r, c - 1);
    }
};
