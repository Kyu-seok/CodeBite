#include <algorithm>
#include <vector>
using namespace std;

class Solution {
    int bestInLine(const vector<int>& values, int from, int to) {
        int skip = 0, take = 0;
        for (int i = from; i < to; i++) {
            int nextTake = skip + values[i];
            skip = max(skip, take);
            take = nextTake;
        }
        return max(skip, take);
    }

public:
    int maxTastiness(vector<int>& tastiness) {
        int n = tastiness.size();
        if (n == 1) return tastiness[0];
        // The first and last are neighbours, so leave out one of them.
        return max(bestInLine(tastiness, 1, n), bestInLine(tastiness, 0, n - 1));
    }
};
