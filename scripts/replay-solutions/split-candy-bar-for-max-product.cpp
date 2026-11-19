#include <vector>
#include <algorithm>
class Solution {
public:
    int maxSplitProduct(int length) {
        vector<long long> best(length + 1, 0);
        best[1] = 1;
        for (int total = 2; total <= length; total++)
            for (int first = 1; first < total; first++)
                best[total] = max(best[total], (long long) first * max((long long) (total - first), best[total - first]));
        return (int) best[length];
    }
};
