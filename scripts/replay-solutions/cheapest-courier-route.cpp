#include <vector>
#include <climits>
using namespace std;

class Solution {
public:
    int cheapestRoute(int n, vector<vector<int>>& links, int src, int dst, int maxStops) {
        const long long INF = LLONG_MAX / 4;
        vector<long long> cost(n, INF);
        cost[src] = 0;
        for (int round = 0; round <= maxStops; round++) {
            vector<long long> updated = cost;
            for (auto& link : links) {
                if (cost[link[0]] != INF && cost[link[0]] + link[2] < updated[link[1]]) {
                    updated[link[1]] = cost[link[0]] + link[2];
                }
            }
            cost = updated;
        }
        return cost[dst] == INF ? -1 : (int) cost[dst];
    }
};
