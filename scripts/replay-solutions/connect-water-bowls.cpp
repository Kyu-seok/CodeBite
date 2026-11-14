#include <vector>
#include <cstdlib>
#include <climits>
using namespace std;

class Solution {
public:
    int minHoseLength(vector<vector<int>>& bowls) {
        int n = bowls.size();
        vector<long long> best(n, LLONG_MAX);
        best[0] = 0;
        vector<bool> inTree(n, false);
        long long total = 0;
        for (int step = 0; step < n; step++) {
            int node = -1;
            for (int i = 0; i < n; i++) if (!inTree[i] && (node == -1 || best[i] < best[node])) node = i;
            inTree[node] = true;
            total += best[node];
            for (int i = 0; i < n; i++) if (!inTree[i]) {
                long long cost = llabs((long long) bowls[node][0] - bowls[i][0]) + llabs((long long) bowls[node][1] - bowls[i][1]);
                if (cost < best[i]) best[i] = cost;
            }
        }
        return (int) total;
    }
};
