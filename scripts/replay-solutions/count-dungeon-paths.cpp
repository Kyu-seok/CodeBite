#include <vector>
using namespace std;

class Solution {
public:
    int countPaths(int rows, int cols) {
        vector<int> ways(cols, 1);
        for (int r = 1; r < rows; r++) {
            for (int c = 1; c < cols; c++) ways[c] += ways[c - 1];
        }
        return ways[cols - 1];
    }
};
