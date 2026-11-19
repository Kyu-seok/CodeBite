#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    bool verifyTableBookings(vector<vector<int>>& bookings) {
        vector<vector<int>> sorted = bookings;
        sort(sorted.begin(), sorted.end());
        for (size_t i = 1; i < sorted.size(); i++) {
            if (sorted[i - 1][1] > sorted[i][0]) return false;
        }
        return true;
    }
};
