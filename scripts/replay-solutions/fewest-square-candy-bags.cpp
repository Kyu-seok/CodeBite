#include <vector>
#include <algorithm>
class Solution {
public:
    int fewestBags(int candies) {
        vector<int> fewest(candies + 1, 0);
        for (int a = 1; a <= candies; a++) {
            fewest[a] = a;
            for (int s = 1; s * s <= a; s++) fewest[a] = min(fewest[a], fewest[a - s * s] + 1);
        }
        return fewest[candies];
    }
};
