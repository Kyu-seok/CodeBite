#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int minStaminaToFinish(vector<int>& cost) {
        int twoBack = 0, oneBack = 0;
        for (size_t i = 2; i <= cost.size(); i++) {
            int here = min(oneBack + cost[i - 1], twoBack + cost[i - 2]);
            twoBack = oneBack;
            oneBack = here;
        }
        return oneBack;
    }
};
