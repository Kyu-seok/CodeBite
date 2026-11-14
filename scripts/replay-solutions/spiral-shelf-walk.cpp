#include <vector>
using namespace std;

class Solution {
public:
    vector<int> spiralOrder(vector<vector<int>>& shelf) {
        vector<int> result;
        int top = 0, bottom = shelf.size() - 1, left = 0, right = shelf[0].size() - 1;
        while (top <= bottom && left <= right) {
            for (int c = left; c <= right; c++) result.push_back(shelf[top][c]);
            for (int r = top + 1; r <= bottom; r++) result.push_back(shelf[r][right]);
            if (top < bottom) for (int c = right - 1; c >= left; c--) result.push_back(shelf[bottom][c]);
            if (left < right) for (int r = bottom - 1; r > top; r--) result.push_back(shelf[r][left]);
            top++; bottom--; left++; right--;
        }
        return result;
    }
};
