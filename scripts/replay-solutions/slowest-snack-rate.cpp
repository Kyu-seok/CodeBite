#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int minEatingRate(vector<int>& piles, int hours) {
        int low = 1, high = *max_element(piles.begin(), piles.end());
        while (low < high) {
            int rate = low + (high - low) / 2;
            long long needed = 0;
            for (int pile : piles) needed += (pile + (long long)rate - 1) / rate;
            if (needed <= hours) high = rate;
            else low = rate + 1;
        }
        return low;
    }
};
