#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int minDailyCapacity(vector<int>& volumes, int days) {
        int low = 0, high = 0;
        for (int v : volumes) { low = max(low, v); high += v; }
        while (low < high) {
            int mid = (low + high) / 2;
            int used = 1, load = 0;
            for (int v : volumes) {
                if (load + v > mid) { used++; load = 0; }
                load += v;
            }
            if (used <= days) high = mid; else low = mid + 1;
        }
        return low;
    }
};
