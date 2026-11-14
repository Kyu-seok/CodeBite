#include <vector>
using namespace std;

class Solution {
public:
    bool findCalorie(vector<vector<int>>& menu, int target) {
        int row = 0, col = (int)menu[0].size() - 1;
        while (row < (int)menu.size() && col >= 0) {
            int value = menu[row][col];
            if (value == target) return true;
            if (value > target) col--; else row++;
        }
        return false;
    }
};
