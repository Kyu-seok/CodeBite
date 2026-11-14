#include <vector>
using namespace std;

class Solution {
public:
    bool hasPrice(vector<vector<int>>& menu, int target) {
        int cols = menu[0].size();
        int low = 0, high = (int)menu.size() * cols - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            int value = menu[mid / cols][mid % cols];
            if (value == target) return true;
            if (value < target) low = mid + 1;
            else high = mid - 1;
        }
        return false;
    }
};
