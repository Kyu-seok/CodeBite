#include <vector>
using namespace std;

class Solution {
public:
    vector<int> daysUntilWarmer(vector<int>& readings) {
        vector<int> wait(readings.size(), 0);
        vector<int> pending;
        for (int day = 0; day < (int)readings.size(); day++) {
            while (!pending.empty() && readings[pending.back()] < readings[day]) {
                int earlier = pending.back();
                pending.pop_back();
                wait[earlier] = day - earlier;
            }
            pending.push_back(day);
        }
        return wait;
    }
};
