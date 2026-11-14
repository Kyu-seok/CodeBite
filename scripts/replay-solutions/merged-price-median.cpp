#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    double mergedPriceMedian(vector<int>& pricesA, vector<int>& pricesB) {
        vector<int> merged(pricesA);
        merged.insert(merged.end(), pricesB.begin(), pricesB.end());
        sort(merged.begin(), merged.end());
        int n = merged.size();
        if (n % 2 == 1) return merged[n / 2];
        return (merged[n / 2 - 1] + (double) merged[n / 2]) / 2.0;
    }
};
