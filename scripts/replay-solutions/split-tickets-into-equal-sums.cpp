#include <vector>
class Solution {
public:
    bool canSplitEqually(vector<int>& tickets) {
        int total = 0;
        for (int t : tickets) total += t;
        if (total % 2 != 0) return false;
        int half = total / 2;
        vector<bool> reachable(half + 1, false);
        reachable[0] = true;
        for (int t : tickets)
            for (int s = half; s >= t; s--)
                if (reachable[s - t]) reachable[s] = true;
        return reachable[half];
    }
};
