#include <vector>
using namespace std;

class Solution {
public:
    int fewestBags(vector<int>& bagSizes, int quota) {
        int unreachable = quota + 1;
        vector<int> fewest(quota + 1, unreachable);
        fewest[0] = 0;
        for (int total = 1; total <= quota; total++) {
            for (int size : bagSizes) {
                if (size <= total && fewest[total - size] + 1 < fewest[total]) {
                    fewest[total] = fewest[total - size] + 1;
                }
            }
        }
        return fewest[quota] == unreachable ? -1 : fewest[quota];
    }
};
