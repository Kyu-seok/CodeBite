#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int largestPosterArea(vector<int>& lockers) {
        int left = 0, right = (int) lockers.size() - 1, best = 0;
        while (left < right) {
            best = max(best, min(lockers[left], lockers[right]) * (right - left));
            if (lockers[left] < lockers[right]) left++;
            else right--;
        }
        return best;
    }
};
