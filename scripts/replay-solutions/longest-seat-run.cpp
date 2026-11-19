#include <vector>
#include <unordered_set>
#include <algorithm>
using namespace std;

class Solution {
public:
    int longestSeatRun(vector<int>& seatIds) {
        unordered_set<int> seats(seatIds.begin(), seatIds.end());
        int longest = 0;
        for (int seat : seats) {
            if (seats.count(seat - 1)) continue;
            int end = seat;
            while (seats.count(end + 1)) end++;
            longest = max(longest, end - seat + 1);
        }
        return longest;
    }
};
