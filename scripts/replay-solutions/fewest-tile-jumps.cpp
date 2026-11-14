#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int minJumps(vector<int>& maxJump) {
        int jumps = 0, currentEnd = 0, farthest = 0;
        for (int i = 0; i + 1 < (int)maxJump.size(); i++) {
            farthest = max(farthest, i + maxJump[i]);
            if (i == currentEnd) {
                jumps++;
                currentEnd = farthest;
            }
        }
        return jumps;
    }
};
